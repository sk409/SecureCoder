import UIKit

class AuthenticationBypassSafeWebSimulatorViewController: WebSimulatorViewController {
    
    let attackA = A()
    let failedText = Text()
    
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
<a href="http://www.safe.co.jp/auth.php?name=<?php echo $name; ?>">攻撃を仕掛ける</a>
""", language: .php, force: false)
        attackA.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
        failedText.set(text: "認証に失敗しました")
        failedText.set(code:"""
echo "認証に失敗しました";
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
このクエリパラメータの値の$nameには以下の値が設定されていました。
$name = "' OR 1=1;--";
""", programingLanguages: [.php, .sql]),
            GuideText(text: "体験編ではこの$nameの値を直接SQL文に埋め込んでいたため、全てのデータを取得するSQL文となってしまうのでした。", programingLanguages: [.php]),
            GuideText(text: "しかし、今回はしっかりとプレースホルダを用いてSQL文のコンパイルが終わった後に$nameを埋め込んでいるので、この攻撃が成立することはありません。", programingLanguages: [.php]),
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
        body.append(element: failedText)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが攻撃先のWebページです。"),])
        appendGuideSection([
            GuideText(text: "この赤枠で囲まれた部分で認証の結果が表示されています。"),
            GuideText(text: """
今回の例では以下の値がusersテーブルにあるものとします。
name: name1, password: pass1,
name: name2, password: pass2
"""),
            GuideText(text: "今回のユーザを検索するSQLは以下でした。\nSELECT 'X' FROM users WHERE name='$name' AND password='$password'", programingLanguages: [.php, .sql]),
            GuideText(text: """
今回攻撃者が渡した$nameの値は以下でした。
$name = "' OR 1=1;--";
""", programingLanguages: [.php]),
            GuideText(text: """
passwordに関しては攻撃者は渡していないので、$_GET["password"]はnullです。
""", programingLanguages: [.php]),
            GuideText(text: """
よって、今回はパスワードを取得するときに以下のように記述していたので、$passwordの値は空文字列になります。
なお、見切れている部分はスクロールすることによって最後まで見ることができます。
$password = $_GET["password"] == null ?
            "" :
            $_GET["password"];
""", programingLanguages: [.php]),
            GuideText(text: "そして今回はしっかりとプレースホルダを用いてSQL文のコンパイルを行ってから$nameと$passwordを埋め込みました。", programingLanguages: [.php, .sql]),
            GuideText(text: "よって、最終的にこのSQLは、nameの値が「' OR 1=1;--」であり、さらにpasswordの値が空文字列である行を検索します。"),
            GuideText(text: "先述のとおり、usersテーブルにこの検索条件を満たす行は存在しないため、このSQL文の結果行数は0です。"),
            GuideText(text: """
そしてその結果を以下のif文によって判定していました。
if (0 < $stm->rowCount()) {
    echo "認証に成功しました";
} else {
    echo "認証に失敗しました";
}
""", programingLanguages: [.php]),
            GuideText(text: "つまり、今回は結果行数が0であるため、「認証に失敗しました」と表示されました。"),
            ], onEnter: { completion in
                self.focus(on: self.failedText) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.failedText) {
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

