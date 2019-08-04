import UIKit

class JavaScriptSchemeUnsafeWebSimulatorViewController: WebSimulatorViewController {
    
    let trapA = A()
    let welcomeH1 = H1()
    let linkA = A()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showTrap()
    }
    
    private func setupViews() {
        trapA.set(text: "このサイト本当に面白い!!")
        trapA.set(code: "<a href=\"http://www.unsafe.co.jp/welcome.php?name=<?php echo $url; ?>\">このサイト本当に面白い!!</a>", language: .php, force: false)
        trapA.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
        welcomeH1.set(text: "ようこそ脆弱株式会社へ")
        linkA.set(text: "リンク先")
        linkA.set(code: """
<a href="<?php echo htmlspecialchars($_GET["url"], ENT_QUOTES); ?>">リンク先</a>
""", language: .php, force: false)
        linkA.button.addTarget(self, action: #selector(handleLinkA(_:)), for: .touchUpInside)
    }
    
    private func showTrap() {
        body.clear()
        body.append(element: trapA)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが攻撃者が用意した罠サイトです。")
            ])
        appendGuideSection([
            GuideText(text: "この赤枠で囲まれたリンクをタップすると攻撃を仕掛ける値とともに脆弱なWebページに遷移します。\nリンクの下に示されたコードと見比べてみましょう。"),
            GuideText(text: "このクエリパラメータの値の$urlには以下の値が設定されていました。\n$url = urlencode(\"javascript:alert('クレジットカード情報が流出しました')\");", programingLanguages: [.php]),
            GuideText(text: "この値をjavascriptスキームが有効になっている属性に設定してしまうと、「クレジットカード情報が流出しました」というアラートが表示されてしまいます。"),
            GuideText(text: "そして、今回はこの値を<a>要素のhref属性に設定しているのでこの攻撃が成立してしまいます。", programingLanguages: [.html])
            ], onEnter: { completion in
                self.focus(on: self.trapA) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.trapA) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "それでは実際に脆弱なWebページに遷移してみましょう。")
            ], onEnter: { completion in
                self.trapA.button.removeTarget(self, action: #selector(self.handleDisabledButton(_:)), for: .touchUpInside)
                self.trapA.button.addTarget(self, action: #selector(self.handleTrapA(_:)), for: .touchUpInside)
                completion?()
        })
        removeCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
    private func showWelcome() {
        body.clear()
        body.append(element: welcomeH1)
        body.append(element: linkA)
        body.appendBreak()
        body.appendBreak()
        body.appendBreak()
        body.appendBreak()
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが最初に見た脆弱なWebページです。")
            ])
        appendGuideSection([
            GuideText(text: "今回攻撃を受けたのは、この赤枠で囲まれた<a>要素です。\n<a>要素のhref属性ではjavascriptスキームが有効になっているため、攻撃ページで渡された値によって攻撃が成立してしまいます。", programingLanguages: [.html]),
            GuideText(text: """
以下に攻撃が成立した後のこの<a>要素のコードを示します。
<a href="javascript:alert('クレジットカード情報が流出しました')">リンク先</a>
""", programingLanguages: [.html]),
            GuideText(text: "このように攻撃を受けた結果、この<a>要素はタップまたはクリックされたときにアラートを表示するようになってしまっています。\n実際にこの<a>要素をタップしてアラートが表示されることを確認してみましょう。", programingLanguages: [.html]),
            ], onEnter: { completion in
                self.focus(on: self.linkA) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.linkA) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "実際にこの攻撃を受けたユーザは非常に怖い思いをするでしょうし、もうこのサイトを使おうとは思わないでしょう。\nサイトへの信頼を失わないためにも早急に対策する必要があります。"),
            GuideText(text: "この攻撃への対策は同レッスンの対策編で解説していますので、そちらを参考にしてください。\nお疲れ様でした。")
            ])
        addCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
    @objc
    private func handleTrapA(_ sender: A) {
        hideGuideMessageCollectionView() {
            self.unfocusAll() {
                self.showWelcome()
            }
        }
    }
    
    @objc
    private func handleLinkA(_ sender: A) {
        let alertController = UIAlertController(title: "", message: "クレジットカード情報が流出しました", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
}
