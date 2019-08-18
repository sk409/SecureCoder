import UIKit

class NoQuotesSafeWebSimulatorViewController: WebSimulatorViewController {
    
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
        nameInput.textField.text = "1 onclick=alert('クレジットカード情報が流出しました')"
        nameInput.set(code: """
<input type="text" name="name" value="<?php echo htmlspecialchars($_GET[\"name\"], ENT_QUOTES); ?>">
""", language: .php, force: false)
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
            GuideText(text: "このクエリパラメータの値の$nameには以下の値が設定されていました。\n$name = urlencode(\"1 onclick=alert('クレジットカード情報が流出しました')\");", programingLanguages: [.php]),
            GuideText(text: "つまり攻撃者の意図としては、GETリクエストで受け取った値を引用符を用いずに出力して属性値に設定している要素にonclickイベントを設定しようとしています。", programingLanguages: [.php]),
            GuideText(text: "体験編では属性値を引用符で囲っていなかったためにこの攻撃が成立してしまいましたが、今回はしっかりと属性値を引用符で囲っているため攻撃を防ぐことができます。")
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
            GuideText(text: "これが最初に見た攻撃先のWebページです。")
            ])
        appendGuideSection([
            GuideText(text: "今回狙われたのはこの<input>要素です。", programingLanguages: [.html]),
            GuideText(text: "最初から設定されているテキストを見ると、\n1 onclick=alert('クレジットカード情報が流出しました')\nとなっています。"),
            GuideText(text: "これは攻撃者が埋め込もうとしていた値そのものです。"),
            GuideText(text: """
以下にvalue属性が設定された後のこの<input>要素のコードを示します。
<input type="text" name="name" value="1 onclick=alert('クレジットカード情報が流出しました')">
""", programingLanguages: [.html]),
            GuideText(text: "このようにしっかりと属性値を引用符で囲っているため、区切り文字として「\"」が使用されます。\nよって今回はvalue属性にスペースを含む値が設定されましたが、そのスペースも含めて1つの属性値として解釈されています。", programingLanguages: [.html]),
            GuideText(text: "もちろん、この<input>要素をタップしてもアラートが表示されることはないので試してみてください。", programingLanguages: [.html]),
            GuideText(text: "ここで、もし仮に攻撃者がスペースではなく「\"」を用いて攻撃を仕掛けようとしていた場合はどうなるのかと思われるかもしれません。"),
            GuideText(text: "具体的にはvalue属性に次の値を設定しようとしていた場合です。", programingLanguages: [.html]),
            GuideText(text: "1\" onclick=\"alert('クレジットカード情報が流出しました')"),
            GuideText(text: """
もしこの攻撃が成立した場合にはこの<input>要素は以下のようになります。
<input type="text" name="name" value="1" onclick="alert('クレジットカード情報が流出しました')">
""", programingLanguages: [.html]),
            GuideText(text: "しかし、この攻撃は成立しません。\nその理由は今回はhtmlspecialcharsを用いてしっかりと特殊文字のエスケープを行っているためです。"),
            GuideText(text: "詳しくは「<iframe>による攻撃ページの埋め込みと隠蔽」というレッスンか「フォームの改ざん」というレッスンを参照してください。")
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
            GuideText(text: "これまで見てきたように属性値を引用符で囲まない場合は、スペースによってその属性値を強制的に終了させることができ、さらにコードを埋め込むことができてしまうので非常に危険です。"),
            GuideText(text: "属性値を記述する場合には必ず引用符で囲むようにし、脆弱性を作り込んでしまう可能性のある「'」ではなく「\"」を使用するようにしましょう。"),
            GuideText(text: "それでは今回の説明はこれで以上です。"),
            GuideText(text: "他にも様々なレッスンを用意していますので、そちらも参考にしてみてください。\nお疲れ様でした。")
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
