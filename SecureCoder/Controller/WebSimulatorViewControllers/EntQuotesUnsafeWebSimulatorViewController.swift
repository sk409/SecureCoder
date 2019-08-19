import UIKit

class EntQuotesUnsafeWebSimulatorViewController: WebSimulatorViewController {
    
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
        trapA.set(code: "<a href=\"http://www.unsafe.co.jp/welcome.php?name=<?php echo $name; ?>\">このサイト本当に面白い!!</a>", language: .php, force: false)
        trapA.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
        welcomeH1.set(text: "ようこそ脆弱株式会社へ")
        nameLabel.set(text: "名前: ")
        nameInput.textField.text = "1"
        nameInput.set(code: "<input type='text' name='name' value='<?php echo htmlspecialchars($_GET[\"name\"]); ?>'>", language: .php, force: false)
        nameInput.textField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNameInputTapGestureRecognizer(_:))))
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
            GuideText(text: "この赤枠で囲まれたリンクをタップすると攻撃を仕掛ける値とともに脆弱なWebページに遷移します。\nリンクの下に示されたコードと見比べてみましょう。"),
            GuideText(text: "このクエリパラメータの値の$nameには以下の値が設定されていました。\n$name = urlencode(\"1' onclick='alert(\"クレジットカード情報が流出しました\")\");", programingLanguages: [.php]),
            GuideText(text: "つまり攻撃者の意図としては、GETリクエストで受け取った値を「'」で囲み、htmlspecialcharsの第2引数を省略して出力し、属性値を設定している要素に対して新たにonclick属性を埋め込もうとしています。", programingLanguages: [.html]),
            GuideText(text: "そして、今回はこの条件を満たしているため攻撃が成立してしまいます。")
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
            GuideText(text: "これが最初に見た脆弱なWebページです。")
            ])
        appendGuideSection([
            GuideText(text: "今回攻撃を受けたのは、この赤枠で囲まれた<input>要素です。\n先ほど見た条件を満たしているため、攻撃ページで渡された値によって攻撃が成立してしまっています。\n初めから表示されている「1」というテキストもこの攻撃の結果です。", programingLanguages: [.html]),
            GuideText(text: "以下に攻撃が成立した後のこの<input>要素のコードを示します。\n<input type='text' name='name' value='1' onclick='alert(\"クレジットカード情報が流出しました\")'>", programingLanguages: [.html]),
            GuideText(text: "このように攻撃を受けた結果、value属性に「1」が設定され、タップまたはクリックされた時にアラートを表示するようになってしまっています。\n実際にタップしてアラートが表示されることを確認しておきましょう。", programingLanguages: [.html]),
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
    private func handleNameInputTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "", message: "クレジットカード情報が流出しました", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
}
