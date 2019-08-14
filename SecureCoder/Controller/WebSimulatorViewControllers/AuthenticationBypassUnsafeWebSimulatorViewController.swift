import UIKit

class AuthenticationBypassUnsafeWebSimulatorViewController: WebSimulatorViewController {
    
    let attackA = A()
    let succeededText = Text()
    
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
<a href="http://www.unsafe.co.jp/auth.php?name=<?php echo $name; ?>">攻撃を仕掛ける</a>
""", language: .php, force: false)
        attackA.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
        succeededText.set(text: "認証に成功しました")
        succeededText.set(code: """
echo "認証に成功しました";
""", language: .php)
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
$author = "' OR 1=1;--";
""", programingLanguages: [.php, .sql]),
            GuideText(text: "この値が脆弱なWebページのSQL文に直接埋め込まれることによって、全てのデータを取得するSQL文となってしまうのでした。"),
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
        body.append(element: succeededText)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが攻撃先のWebページです。")])
        appendGuideSection([
            GuideText(text: "この赤枠で囲まれた部分で認証の結果が表示されています。"),
            GuideText(text: """
今回の例では以下の値がusersテーブルにあるものとします。
name: name1, password: pass1,
name: name2, password: pass2
"""),
            GuideText(text: "今回のユーザを検索するSQLは以下でした。\nSELECT 'X' FROM users WHERE name='$name' AND password='$password'", programingLanguages: [.php, .sql]),
            GuideText(text: "このSQLは攻撃者によって渡された$nameによって最終的に次のSQLになるのでした。", programingLanguages: [.php]),
            GuideText(text: "SELECT 'X' FROM users WHERE name='' OR 1=1;--' AND password='$password'", programingLanguages: [.sql]),
            GuideText(text: "このSQLによって、usersテーブル内のデータが全て結果として返されます。"),
            GuideText(text: """
そしてその結果を以下のif文によって判定していました。
なお、見切れている部分はスクロールすることによって最後まで見ることができます。
if (0 < $stm->rowCount()) {
    echo "認証に成功しました";
} else {
    echo "認証に失敗しました";
}
""", programingLanguages: [.php]),
            GuideText(text: "攻撃者によって先ほどのSQLはusersテーブル内の全てのデータを取得する文となっており、今回のusersテーブルには2件のデータがあるため、このif文の分岐により「認証に成功しました」と表示されました。", programingLanguages: [.php]),
            ], onEnter: { completion in
                self.focus(on: self.succeededText) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.succeededText) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "このようにSQLインジェクション脆弱性があると認証を回避され、不正にアプリケーションを利用されてしまう可能性があるため、早急に対策をする必要があります。"),
            GuideText(text: "この攻撃への対策は同レッスンの対策編で解説していますのでそちらを参考にしてください。"),
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
