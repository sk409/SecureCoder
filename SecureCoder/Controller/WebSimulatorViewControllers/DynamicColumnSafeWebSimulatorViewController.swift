import UIKit

class DynamicColumnSafeWebSimulatorViewController: WebSimulatorViewController {
    
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
<a href="http://www.safe.co.jp/books.php?sort_key=<?php echo $sortKey; ?>">攻撃を仕掛ける</a>
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
        booksTable.append(row: ["title1", "author1", "1"])
        booksTable.append(row: ["title2", "author2", "2"])
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
            GuideText(text: "もしこれが値のチェックを行わずに$sortKeyの値を直接SQL文に埋め込んでいる場合には、SQLインジェクション攻撃が成立してしまいますが、今回はしっかりとホワイトリストを用いて値のチェックを行なっているためこの攻撃が成立することはありません。", programingLanguages: [.php]),
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
            GuideText(text: "この赤枠で囲まれた部分でもしGETリクエストで渡された$sortKeyの値がホワイトリストにあれば、ソートした後のデータが表示されます。", programingLanguages: [.php]),
            GuideText(text: """
今回GETリクエストで渡された$sortKeyの値は以下でした。
$sortkey = "price; DELETE FROM books;--";
""", programingLanguages: [.php, .sql]),
            GuideText(text: """
それに対してホワイトリストは以下でした。
$keys = ["title", "author", "price"];
""", programingLanguages: [.php]),
            GuideText(text: "つまり、今回渡された$sortKeyの値はホワイトリストに含まれていないので、ソートは実行されず全ての本のデータが表示されています。", programingLanguages: [.php]),
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
            GuideText(text: "今回は攻撃を受けていないので、データベース内のデータが削除されていません。\nよってこの赤枠で囲まれた部分で全ての本の情報がソートされずに表示されています。"),
            GuideText(text: "先ほど見た<table>要素もソートされずに表示されていたため、この<table>要素と全く同じ表示内容になっています。", programingLanguages: [.html])
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
            GuideText(text: "このようにプレースホルダを用いることができない場合でもホワイトリストを用いてテーブル名や列名を制限できるので覚えておきましょう。"),
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

