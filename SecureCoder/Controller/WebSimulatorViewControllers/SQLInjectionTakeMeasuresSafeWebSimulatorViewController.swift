import UIKit

class SQLInjectionTakeMeasuresSafeWebSimulatorViewController: WebSimulatorViewController {
    
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
<a href="http://www.safe.co.jp/books.php?author=<?php echo $author; ?>">攻撃を仕掛ける</a>
""", language: .php, force: false)
        attackA.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
        booksTable.set(code: """
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
このクエリパラメータの値の$authorには以下の値が設定されていました。
$author = "' UNION SELECT name, password, NULL FROM users;--";
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
        body.append(element: booksTable)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが攻撃先のWebページです。")])
        appendGuideSection([
            GuideText(text: "この赤枠で囲まれた部分に検索した本の情報が表示されますが今回はヘッダーのみで内容が表示されていません。"),
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
            GuideText(text: "今回の本を検索するSQLは以下でした。\nSELECT title, author, price FROM books WHERE author=?", programingLanguages: [.php, .sql]),
            GuideText(text: "このauthorに対応するプレースホルダにバインドした値は攻撃者が渡した以下の値でした。\n' UNION SELECT name, password, NULL FROM users;--", programingLanguages: [.sql]),
            GuideText(text: "この攻撃者が渡した値を設定するときには既にSQL文のコンパイルは終了しているので、体験編の時のようにSQL文の構造が変更されることはなく、booksテーブルからauthorが「' UNION SELECT name, password, NULL FROM users;--」の行を探しにいきます。", programingLanguages: [.sql]),
            GuideText(text: "今回のbooksテーブルには前述のとおり、author列が「' UNION SELECT name, password, NULL FROM users;--」の行はありませんので、今回の検索結果では何も行が取得されません。", programingLanguages: [.sql]),
            GuideText(text: "この結果、この赤枠で囲まれた部分には<table>要素のヘッダー部分しか表示されていません。", programingLanguages: [.html]),
            GuideText(text: "これでユーザ情報の漏洩を防ぐことができました。")
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
            GuideText(text: "このようにSQLインジェクションはプレースホルダを用いてSQL文をコンパイルしておき、後から値をバインドすることで対策することができます。\nこの他のSQLインジェクションのレッスンでは対策法は全て同じですが、様々なケースの攻撃を体験することに主眼を置いていますので、そちらも参考にしてみてください。"),
            GuideText(text: "お疲れ様でした。")
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
