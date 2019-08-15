import UIKit

class DynamicColumnUnsafeWebSimulatorViewController: WebSimulatorViewController {
    
    let attackA = A()
    let afterSortP = P()
    let sortedBooksTable = Table()
    let beforeSortP = P()
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
<a href="http://www.unsafe.co.jp/books.php?sort_key=<?php echo $sortKey; ?>">攻撃を仕掛ける</a>
""", language: .php, force: false)
        attackA.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
        afterSortP.set(text: "ソート後")
        sortedBooksTable.set(code: """
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
        sortedBooksTable.set(headers: ["タイトル", "著者名", "価格"])
        sortedBooksTable.append(row: ["title1", "author1", "1"])
        sortedBooksTable.append(row: ["title2", "author2", "2"])
        beforeSortP.set(text: "ソート前")
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
                echo "<td>", $data, "</td>";
            }
            echo "</tr>";
        }
    ?>
</table>
""", language: .php)
        booksTable.set(headers: ["タイトル", "著者名", "価格"])
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
このクエリパラメータの値の$sortKeyには以下の値が設定されていました。
$sortkey = "price; DELETE FROM books;--";
""", programingLanguages: [.php, .sql]),
            GuideText(text: "この値が脆弱なWebページのSQL文に直接埋め込まれることによってデータベース内のデータが削除されてしまうのでした。"),
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
        body.append(element: afterSortP)
        body.append(element: sortedBooksTable)
        body.appendBreak()
        body.append(element: beforeSortP)
        body.append(element: booksTable)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが攻撃先のWebページです。"),
            GuideText(text: """
なお、今回の例では以下の値がbooksテーブルにあるものとします。
title: title1, author: author1, price: 1
title: title2, author: author2, price: 2
"""),])
        appendGuideSection([
            GuideText(text: "この赤枠で囲まれた部分に攻撃者が渡した$sortKeyの値を元にソートされたデータが表示されています。", programingLanguages: [.php]),
            GuideText(text: "displayBooks関数にソート列を指定した場合のSQL文は以下でした。\nSELECT title, author, price FROM books ORDER BY $sortKey DESC", programingLanguages: [.php, .sql]),
            GuideText(text: "このSQLは攻撃者によって渡された$sortKeyによって最終的に次のSQLになるのでした。", programingLanguages: [.php]),
            GuideText(text: "SELECT title, author, price FROM books ORDER BY price; DELETE FROM books;-- DESC", programingLanguages: [.sql]),
            GuideText(text: "今回はこの攻撃が成立してしまうので、このSQLによって、booksテーブルの全てのデータがprice列を元にして昇順にソートされ選択されます。\nその後、booksテーブルの全てのデータが削除されます。"),
            GuideText(text: "データが選択された後に削除されているため、この<table>要素では全てのデータが表示されています。", programingLanguages: [.html]),
            ], onEnter: { completion in
                self.focus(on: self.sortedBooksTable) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.sortedBooksTable) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "この赤枠で囲まれた部分では全ての本をソートせずに表示するはずでしたが、こちらはヘッダーしか表示されていません。"),
            GuideText(text: "これは、この1つ前のSQL文によってbooksテーブルの全てのデータが削除されてしまったためです。"),
            GuideText(text: "今回、displayBooks関数を呼び出した順番は次の順番であったことを思い出してください。"),
            GuideText(text: """
<p>ソート後</p>
<?php displayBooks($_GET["sort_key"]); ?>
<p>ソート前</p>
<?php displayBooks(); ?>
""", programingLanguages: [.php]),
            GuideText(text: "つまり、全てのデータが削除されてしまった後に、この<table>要素用のdisplayBooks関数が呼ばれたために、ヘッダーのみしか表示されていません。", programingLanguages: [.html]),
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
            GuideText(text: "このようにSQLインジェクション攻撃を受けて、データベース内のデータが削除されてしまうと非常に大きな被害を受けてしまうことになりますので、早急に対策する必要があります。"),
            GuideText(text: "この攻撃への対策は同レッスンの対策編で解説していますので、そちらを参考にしてください。"),
            GuideText(text: "今回のレッスンはこれで以上です。\nお疲れ様でした。"),
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
