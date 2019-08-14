import UIKit

class FalsifyDatabaseSafeWebSimulatorViewController: WebSimulatorViewController {
    
    let attackA = A()
    let selectedDataP = P()
    let selectedBooksTable = Table()
    let allDataP = P()
    let allBooksTable = Table()
    
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
<a href="http://www.safe.co.jp/books.php?author=<?php echo $author; ?>">攻撃を仕掛ける</a>
""", language: .php, force: false)
        attackA.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
        selectedDataP.set(text: "選択したデータ")
        selectedBooksTable.set(code: """
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
                echo "<td>", $data, "</td>";
            }
            echo "</tr>";
        }
    ?>
</table>
""", language: .php)
        selectedBooksTable.set(headers: ["タイトル", "著者名", "価格"])
        allDataP.set(text: "全てのデータ")
        allBooksTable.set(code: """
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
                echo "<td>", $data, "</td>";
            }
            echo "</tr>";
        }
    ?>
</table>
""", language: .php)
        allBooksTable.set(headers: ["タイトル", "著者名", "価格"])
        allBooksTable.append(row: ["title1", "author1", "1"])
        allBooksTable.append(row: ["title2", "author2", "2"])
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
$author = "'; DELETE FROM books;--";
""", programingLanguages: [.php, .sql]),
            GuideText(text: "もしこれがこの$authorの値を直接SQL文に埋め込んでいるような場合には攻撃が成立してしまいますが、今回はプレースホルダを用いてSQL文のコンパイルが終わってから$authorの値を埋め込んでいるため、この攻撃が成立することはありません。", programingLanguages: [.php]),
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
        body.append(element: selectedDataP)
        body.append(element: selectedBooksTable)
        body.appendBreak()
        body.append(element: allDataP)
        body.append(element: allBooksTable)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが攻撃先のWebページです。"),
            GuideText(text: """
なお、今回の例では以下の値がbooksテーブルにあるものとします。
title: title1, author: author1, price: 1
title: title2, author: author2, price: 2
"""),])
        appendGuideSection([
            GuideText(text: "この赤枠で囲まれた部分に検索した本の情報が表示されますが今回はヘッダーのみで内容が表示されていません。"),
            GuideText(text: "今回の本を検索するSQLは以下でした。\nSELECT title, author, price FROM books WHERE author=?", programingLanguages: [.php, .sql]),
            GuideText(text: "このauthorに対応するプレースホルダにバインドした値は攻撃者が渡した以下の値でした。\n'; DELETE FROM books;--", programingLanguages: [.sql]),
            GuideText(text: "この攻撃者が渡した値を設定するときには既にSQL文のコンパイルは終了しているので、体験編の時のようにSQL文の構造が変更されることはなく、booksテーブルからauthorが「'; DELETE FROM books;--」の行を探しにいきます。", programingLanguages: [.sql]),
            GuideText(text: "今回のbooksテーブルには前述のとおり、author列が「'; DELETE FROM books;--」の行はありませんので、今回の検索結果では何も行が取得されません。", programingLanguages: [.sql]),
            GuideText(text: "この結果、この赤枠で囲まれた部分には<table>要素のヘッダー部分しか表示されていません。", programingLanguages: [.html]),
            ], onEnter: { completion in
                self.focus(on: self.selectedBooksTable) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.selectedBooksTable) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "今回は攻撃を受けていないので、データベース内のデータが削除されていません。\nよってこの赤枠で囲まれた部分で全ての本の情報が表示されています。")
            ], onEnter: { completion in
                self.focus(on: self.allBooksTable) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.allBooksTable) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "このようにSQLインジェクションはプレースホルダを用いてSQL文をコンパイルしておき、後から値をバインドすることで対策することができます。\nSQLインジェクション攻撃は影響の大きな被害をもたらすので必ず対策しておきましょう。"),
            GuideText(text: "以上でこのレッスンは終了です。\nこの他にも様々なレッスンを用意していますのでそちらも参考にしてみてください。\nお疲れ様でした。")
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

