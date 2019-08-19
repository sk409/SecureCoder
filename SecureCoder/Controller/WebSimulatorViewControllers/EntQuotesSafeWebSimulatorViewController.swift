import UIKit

class EntQuotesSafeWebSimulatorViewController: WebSimulatorViewController {
    
    let trapA = A()
    let welcomeH1 = H1()
    let nameLabel = Text()
    let nameInput = Input()
    let ageLabel = Text()
    let ageInput = Input()
    let registerButton = Button()
    
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
        trapA.set(code: "<a href=\"http://www.safe.co.jp/welcome.php?name=<?php echo $name; ?>\">このサイト本当に面白い!!</a>", language: .php, force: false)
        trapA.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
        welcomeH1.set(text: "ようこそ安全株式会社へ")
        nameLabel.set(text: "名前: ")
        nameInput.textField.text = "1' onclick='alert(\"クレジットカード情報が流出しました\")"
        nameInput.set(code: "<input type='text' name='name' value='<?php echo htmlspecialchars($_GET[\"name\"], ENT_QUOTES); ?>'>", language: .php, force: false)
        ageLabel.set(text: "年齢: ")
        registerButton.set(text: "登録")
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
            GuideText(text: "このクエリパラメータの値の$nameには以下の値が設定されていました。\n$name = urlencode(\"1' onclick='alert(\"クレジットカード情報が流出しました\")\");", programingLanguages: [.php]),
            GuideText(text: "つまり攻撃者の意図としては、GETリクエストで受け取った値を「'」で囲み、htmlspecialcharsの第2引数を省略して出力し、属性値を設定している要素に対して新たにonclick属性を埋め込もうとしています。", programingLanguages: [.html]),
            GuideText(text: "しかし、今回はhtmlspecialcharsの第2引数にENT_QUOTESを指定して、しっかりと「'」のエスケープを行なっているのでこの攻撃は成立しません。")
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
        body.append(element: nameLabel)
        body.append(element: nameInput)
        body.appendBreak()
        body.appendBreak()
        body.append(element: ageLabel)
        body.append(element: ageInput)
        body.appendBreak()
        body.appendBreak()
        body.append(element: registerButton)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが攻撃先のWebページです。")
            ])
        appendGuideSection([
            GuideText(text: "今回攻撃を受けたのは、この赤枠で囲まれた<input>要素です。\n今回は攻撃に対する対策をしっかりと行なっているため新たな属性が追加されることはなく、攻撃者が設定した値がそのままvalue属性の属性値となり、この<input>要素のテキストとして表示されています。", programingLanguages: [.html]),
            GuideText(text: "以下に攻撃者が渡した値をvalue属性に設定した後のこの<input>要素のコードを示します。\n<input type='text' name='name' value='1&#039; onclick=&#039;alert(&quot;クレジットカード情報が流出しました&quot;)'>", programingLanguages: [.html]),
            GuideText(text: "多少見づらいかもしれませんが、攻撃者が渡した値が全て1つの属性値としてvalue属性に設定されているのが分かります。\nこれで新たな属性を追加されることはなくなりました。", programingLanguages: [.html]),
            GuideText(text: "もちろんこの<input>要素をタップしてもアラートが表示されることはありませんので、実際にタップして確認してみてください。", programingLanguages: [.html]),
            ], onEnter: { completion in
                self.focus(on: self.nameInput) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.nameInput) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "このようにhtmlspecialcharsの第2引数をENT_QUOTESに指定するだけで攻撃を防ぐことができるので、htmlspecialcharsの使用するときは必ず第2引数にこの値を設定するようにしましょう。"),
            GuideText(text: "もちろん、属性値を囲む引用符として「\"」を使用している場合には、第2引数を省略しても結果は同じですが、もしなんらかの理由で属性値を「'」で囲むことになった場合、htmlspecialcharsの第2引数を省略する習慣が付いていると脆弱性を作り込んでしまうことになるので、必ず指定することをお勧めします。"),
            GuideText(text: "それでは今回の説明はこれで以上です。\n他にも様々なレッスンを用意していますのでそちらも参考にしてみてください。\nお疲れ様でした。")
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
