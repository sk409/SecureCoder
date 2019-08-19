import UIKit

class InformationSchemaUnsafeWebSimulatorViewController: WebSimulatorViewController {
    
    let attackA = A()
    let booksTable = Table()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAttack()
    }
    
    private func setupViews() {
        attackA.set(text: "攻撃を仕掛ける")
        attackA.set(code: """
<a href="http://www.unsafe.co.jp/books.php?author=<?php echo $author; ?>">攻撃を仕掛ける</a>
""", language: .php, force: false)
        attackA.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
        booksTable.set(code: """
<table>
    <tr>
        <th>タイトル</th>
        <th>著者名</th>
        <th>価格</th>
    </tr>
    <?php
        while ($row = $stm->fetch(PDO::FETCH_ASSOC)) {
            echo "<tr>";
            foreach ($row as $data) {
                echo "<td>";
                echo $data;
                echo "</td>";
            }
            echo "</tr>";
        }
    ?>
</table>
""", language: .php)
        booksTable.set(headers: ["タイトル", "著者名", "価格"])
        booksTable.append(row: ["books", "title", "varchar"])
        booksTable.append(row: ["books", "author", "varchar"])
        booksTable.append(row: ["books", "price", "int"])
        booksTable.append(row: ["users", "name", "varchar"])
        booksTable.append(row: ["users", "password", "varchar"])
    }
    
    private func showAttack() {
        body.clear()
        body.append(element: attackA)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが攻撃者が用意した攻撃用のWebページです。")
            ])
        appendGuideSection([
            GuideText(text: "この赤枠で囲まれたリンクをタップすると攻撃を仕掛ける値とともに攻撃先のWebページに遷移します。\nリンクの下に示されたコードと見比べてみましょう。"),
            GuideText(text: """
このクエリパラメータの値の$authorには以下の値が設定されていました。
$author = "' UNION SELECT table_name, column_name, data_type FROM information_schema.columns;--";
""", programingLanguages: [.php, .sql]),
            GuideText(text: "この値が脆弱なWebページのSQL文に直接埋め込まれることによってDBMS内部の情報を表示するSQL文となってしまうのでした。"),
            ], onEnter: { completion in
                self.focus(on: self.attackA) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.attackA) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "それでは実際に攻撃先のWebページに遷移してみましょう。")
            ], onEnter: { completion in
                self.attackA.button.removeTarget(self, action: #selector(self.handleDisabledButton(_:)), for: .touchUpInside)
                self.attackA.button.addTarget(self, action: #selector(self.handleAttackA(_:)), for: .touchUpInside)
                completion?()
        })
        removeCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
    private func showBooks() {
        body.clear()
        body.append(element: booksTable)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが攻撃先のWebページです。")])
        appendGuideSection([
            GuideText(text: "このWebページの製作者の意図としては、この赤枠で囲まれた部分に検索した本の情報が表示されますが今回はDBMS内部の情報が表示されてしまっています。"),
            GuideText(text: "なお、本来はここに表示されている以外にも様々な情報が表示されますが、見づらくなってしまうため、booksテーブルとusersテーブルに関する情報のみ表示しています。"),
            GuideText(text: """
今回の例では以下の値がbooksテーブルにあるものとします。
title: title1, author: author1, price: 1
title: title2, author: author2, price: 2
"""),
            GuideText(text: "usersテーブルは「name, password」という列を持っているものとします。"),
            GuideText(text: "今回の本を検索するSQLは以下でした。\nSELECT title, author, price FROM books WHERE author='$author'", programingLanguages: [.php, .sql]),
            GuideText(text: "このSQLは攻撃者によって渡された$authorによって最終的に次のSQLになるのでした。", programingLanguages: [.php]),
            GuideText(text: "SELECT title, author, price FROM books WHERE author='' UNION SELECT table_name, column_name, data_type FROM information_schema.columns;--'", programingLanguages: [.sql]),
            GuideText(text: "このSQLによって、booksテーブルのauthor列が空の行とcolumnsテーブルの行を結合した結果が選択されます。\nこの選択された値のtable_nameがタイトル列に、column_nameが著者名列に、data_typeが価格列に表示されています。"),
            GuideText(text: "今回のbooksテーブルにはauthor列が空の行はありませんので、この赤枠で囲まれた部分にcolumnsテーブルの行のみが表示されています。"),
            GuideText(text: "この攻撃によってDBMS内部の情報が攻撃者に漏洩してしまうため、より被害の大きな攻撃を仕掛けるための手がかりとなってしまう可能性があります。")
            ], onEnter: { completion in
                self.focus(on: self.booksTable) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.booksTable) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "このようにDBMS内部の情報が漏洩してしまうと、データの改ざんや個人情報の漏洩など、被害の大きな攻撃を引き起こしてしまう可能性があるので早急に対策が必要です。\nこの攻撃への対策は同レッスンの対策編で解説していますので、そちらを参考にしてみてください。"),
            GuideText(text: "お疲れ様でした。"),
            ])
        addCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
    @objc
    private func handleAttackA(_ sender: A) {
        hideGuideMessageCollectionView() {
            self.unfocusAll() {
                self.showBooks()
            }
        }
    }
    
}
