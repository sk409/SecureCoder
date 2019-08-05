import UIKit

class JavaScriptSchemeSafeWebSimulatorViewController: WebSimulatorViewController {
    
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
        trapA.set(code: "<a href=\"http://www.safe.co.jp/welcome.php?url=<?php echo $url; ?>\">このサイト本当に面白い!!</a>", language: .php, force: false)
        trapA.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
        welcomeH1.set(text: "ようこそ安全株式会社へ")
        linkA.set(text: "リンク先")
        linkA.set(code: """
<a href="<?php echo htmlspecialchars(check_url($_GET["url"]), ENT_QUOTES); ?>">リンク先</a>
""", language: .php, force: false)
    }
    
    private func showTrap() {
        body.clear()
        body.append(element: trapA)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが攻撃者が用意した罠サイトです。")
            ])
        appendGuideSection([
            GuideText(text: "この赤枠で囲まれたリンクをタップすると攻撃を仕掛ける値とともに攻撃先のWebページに遷移します。\nリンクの下に示されたコードと見比べてみましょう。"),
            GuideText(text: "このクエリパラメータの値の$urlには以下の値が設定されていました。\n$url = urlencode(\"javascript:alert('クレジットカード情報が流出しました')\");", programingLanguages: [.php]),
            GuideText(text: "この値をjavascriptスキームが有効になっている属性に設定してしまうと、「クレジットカード情報が流出しました」というアラートが表示されてしまいます。"),
            GuideText(text: "しかし、今回は「check_url」関数にて「http://」または「https://」または「/」で始まる文字列以外は空文字列に変換されるので、この攻撃が成立することはありません。", programingLanguages: [.html])
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
            GuideText(text: "それでは実際に攻撃先のWebページに遷移してみましょう。")
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
            GuideText(text: "これが最初に見た攻撃先のWebページです。")
            ])
        appendGuideSection([
            GuideText(text: "今回攻撃を受けたのは、この赤枠で囲まれた<a>要素です。\n<a>要素のhref属性ではjavascriptスキームが有効になっているため、攻撃ページで渡された値によってはjavascriptのコードを埋め込まれてしまいますが、今回は値のチェックを行なってしっかりと無効化したため、アラートが表示されることはありませんので実際にタップして確かめてみてください。", programingLanguages: [.html]),
            GuideText(text: """
以下にhref属性が設定された後のこの<a>要素のコードを示します。
<a href="">リンク先</a>
""", programingLanguages: [.html]),
            GuideText(text: "このようにhref属性が空文字列となっているためタップしても何も起こりません。", programingLanguages: [.html]),
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
            GuideText(text: "このようにjavascriptスキームが有効になっている属性にユーザから渡された値が設定される可能性がある場合にはしっかりと値のチェックを行うようにしましょう。"),
            GuideText(text: "今回の説明はこれで以上です\n他にも様々なレッスンを用意していますのでそちらも参考にしてみてください。\nお疲れ様でした。"),
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
    
}
