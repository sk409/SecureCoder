import UIKit

class SQLInjectionTakeMeasuresWebSimulatorViewController: WebSimulatorViewController {
    
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
while ($row = $stm->fetch(PDO::FETCH_ASSOC)) {
    echo "<tr>";
    foreach ($row as $data) {
        echo "<td>", $data, "</td>";
    }
    echo "</tr>";
}
""", language: .php)
        booksTable.set(headers: ["タイトル", "著者名", "価格"])
        booksTable.append(row: ["name1", "pass1", ""])
        booksTable.append(row: ["name2", "pass2", ""])
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
$author = "' UNION SELECT name, password, NULL FROM users;--";
""", programingLanguages: [.php, .sql]),
            GuideText(text: "この値が脆弱なWebページのSQL文に直接埋め込まれることによってユーザ情報を表示するSQL文となってしまうのでした。"),
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
            GuideText(text: "本来であれば、この赤枠で囲まれた部分に検索した本の情報が表示されますが今回はユーザ情報が表示されてしまっています。"),
            GuideText(text: """
今回の例では以下の値がデータベースにあるものとします。
なお、見切れている部分はスクロールすることで最後まで見ることができます。
・booksテーブル
title: title1, author: author1, price: 1
title: title2, author: author2, price: 2
・usersテーブル
name: name1, password: pass1
name: name2, password: pass2
"""),
            GuideText(text: "今回の本を検索するSQLは以下でした。\nSELECT title, author, price FROM books WHERE author='$author'", programingLanguages: [.php, .sql]),
            GuideText(text: "このSQLは攻撃者によって渡された$authorによって最終的に次のSQLになるのでした。", programingLanguages: [.php]),
            GuideText(text: "SELECT title, author, price FROM books WHERE author='' UNION SELECT name, password, NULL FROM users;--'", programingLanguages: [.sql]),
            GuideText(text: "このSQLによって、booksテーブルのauthor列が空の行とusersテーブルの全ての行を結合した結果が選択されます。"),
            GuideText(text: "今回のbooksテーブルにはauthor列が空の行はありませんので、この赤枠で囲まれた部分にusersテーブルの全ての行のみが表示されています。"),
            GuideText(text: "この攻撃によって全てのユーザの情報が攻撃者に漏洩してしまいますので、次の攻撃につながる可能性があり、さらに大きな被害となってしまう恐れがあります。")
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
            GuideText(text: "このようにSQLインジェクション脆弱性は情報漏洩やデータの改ざんなど影響の大きな攻撃を受けてしまいますので、早急に対策する必要があります。\nこの攻撃への対策は同レッスンの対策編で解説していますのでそちらを参考にしてください。\nお疲れ様でした。")
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
