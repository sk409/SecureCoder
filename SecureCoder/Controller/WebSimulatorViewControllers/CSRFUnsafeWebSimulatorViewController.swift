import UIKit

class CSRFUnsafeWebSimulatorViewController: WebSimulatorViewController {
    
    let idText = Text()
    let idInput = Input()
    let passwordText = Text()
    let passwordInput = Input()
    let loginButton = Button()
    let pageText = Text()
    let newPasswordText = Text()
    let newPasswordInput = Input()
    let changeButton = Button()
    let changedText = Text()
    let featuredItemsH1 = H1()
    let itemAP = P()
    let itemBP = P()
    let feedbackIFrame = IFrame()
    
    let feedbackView = Body()
    let feedbackChangedText = Text()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLogin()
    }
    
    private func setupViews() {
        idText.set(text: "ID: ")
        idInput.textField.text = "id"
        idInput.set(code: """
<input type="text" name="id">
""", language: .html)
        passwordText.set(text: "パスワード: ")
        passwordInput.textField.isSecureTextEntry = true
        passwordInput.textField.text = "password"
        passwordInput.set(code: """
<input type="password" name="password">
""", language: .html)
        loginButton.set(text: "ログイン")
        loginButton.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
        newPasswordText.set(text: "新しいパスワード: ")
        newPasswordInput.textField.isSecureTextEntry = true
        newPasswordInput.textField.text = "new_password"
        newPasswordInput.set(code: """
<input type="password" name="new_password">
""", language: .html)
        changeButton.set(text: "変更する")
        changeButton.button.addTarget(self, action: #selector(handleDisabledButton(_:)), for: .touchUpInside)
        changedText.set(code: """
echo $id, "さんのパスワードを", $newPassword, "に変更しました。";
""", language: .php)
        featuredItemsH1.set(text: "おすすめの商品紹介")
        itemAP.set(text: "商品A")
        itemBP.set(text: "商品B")
        feedbackIFrame.set(code: """
<iframe src="apply.html"></iframe>
""", language: .html)
        feedbackChangedText.set(code: """
echo $id, "さんのパスワードを", $newPassword, "に変更しました。";
""", language: .php)
    }
    
    private func showLogin() {
        body.clear()
        body.append(element: idText)
        body.append(element: idInput)
        body.appendBreak()
        body.appendBreak()
        body.append(element: passwordText)
        body.append(element: passwordInput)
        body.appendBreak()
        body.appendBreak()
        body.append(element: loginButton)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが最初に見たログインページです。\nまずは正規のパスワード変更の流れを見ていきます。")])
        appendGuideSection([
            GuideText(text: "これがユーザのIDを入力するための<input>要素です。\n今回はあらかじめidと入力しておきましたが、好きな値を入力しても構いません。", programingLanguages: [.html])],
                           onEnter: { completion in
                            self.focus(on: self.idInput) {
                                completion?()
                            }
        }, onExit: { completion in
            self.unfocus(elementView: self.idInput) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "これがユーザのパスワードを入力するための<input>要素です。\n今回はあらかじめpasswordと入力しておきましたが、好きな値を入力しても構いません。", programingLanguages: [.html])],
                           onEnter: { completion in
                            self.focus(on: self.passwordInput) {
                                completion?()
                            }
        }, onExit: { completion in
            self.unfocus(elementView: self.passwordInput) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "それでは実際にログインボタンを押して、home.phpに遷移してみましょう。")
            ], onEnter: { completion in
                self.loginButton.button.removeTarget(self, action: #selector(self.handleDisabledButton(_:)), for: .touchUpInside)
                self.loginButton.button.addTarget(self, action: #selector(self.handleLoginButton(_:)), for: .touchUpInside)
                completion?()
        })
        removeCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
    private func showHome() {
        if let id = idInput.textField.text {
            pageText.set(text: id + "さんのページ")
        }
        body.clear()
        body.append(element: pageText)
        body.appendBreak()
        body.append(element: newPasswordText)
        body.append(element: newPasswordInput)
        body.appendBreak()
        body.appendBreak()
        body.append(element: changeButton)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これがログイン後に表示されるhome.phpです。\n今回は必ず認証に成功するようにしていたのでログインに失敗することはありません。"),
            GuideText(text: "これ以降このユーザのIDは$_SESSIONに保存されるので、このWebサイトからはいつでもこのユーザのIDにアクセスすることができます", programingLanguages: [.php])])
        appendGuideSection([
            GuideText(text: "これが新しいパスワードを入力するための<input>要素です。\n今回はあらかじめnew_passwordと入力しておきましたが、好きな値を入力しても構いません。", programingLanguages: [.html])],
                           onEnter: { completion in
                            self.focus(on: self.newPasswordInput) {
                                completion?()
                            }
        }, onExit: { completion in
            self.unfocus(elementView: self.newPasswordInput) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "それでは実際に変更するボタンを押して、change_password.phpに遷移してみましょう。")
            ], onEnter: { completion in
                self.changeButton.button.removeTarget(self, action: #selector(self.handleDisabledButton(_:)), for: .touchUpInside)
                self.changeButton.button.addTarget(self, action: #selector(self.handleChangeButton(_:)), for: .touchUpInside)
                completion?()
        })
        removeCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
    private func showChangePassword() {
        if let id = idInput.textField.text, let newPassword = newPasswordInput.textField.text {
            changedText.set(text: id + "さんのパスワードを" + newPassword + "に変更しました。")
        }
        body.clear()
        body.append(element: changedText)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これがパスワードを変更した後に表示されるchange_password.phpです。")])
        appendGuideSection([
            GuideText(text: "ここにパスワード変更の結果がchange関数によって表示されています。", programingLanguages: [.html]),
            GuideText(text: "このchange関数に渡すユーザのIDは先ほどログインした段階で$_SESSIONに保存されたユーザIDを使用しています。\nこのユーザIDに対応したパスワードを変更した結果がここに表示されているものです。", programingLanguages: [.php])],
                           onEnter: { completion in
                            self.focus(on: self.changedText) {
                                completion?()
                            }
        }, onExit: { completion in
            self.unfocus(elementView: self.changedText) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "これが正規のパスワード変更の流れになります。\nそれでは次に罠ページに誘導されてしまった場合の攻撃の流れを見ていきましょう。")
            ], onEnter: { completion in
                self.changeButton.button.removeTarget(self, action: #selector(self.handleDisabledButton(_:)), for: .touchUpInside)
                self.changeButton.button.addTarget(self, action: #selector(self.handleChangeButton(_:)), for: .touchUpInside)
                completion?()
        })
        closeButtonTitle = "罠ページに移動する"
        closeButtonHandler = { button in
            self.closeButtonTitle = nil
            self.closeButtonHandler = nil
            self.hideGuideMessageCollectionView() {
                self.unfocusAll() {
                    self.showTrap()
                }
            }
        }
        addCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
    private func showTrap() {
        if let id = idInput.textField.text {
            feedbackChangedText.set(text: id + "さんのパスワードをcrackedに変更しました。")
        }
        feedbackView.append(element: feedbackChangedText)
        feedbackIFrame.webElementContainerView = feedbackView
        body.clear()
        body.append(element: featuredItemsH1)
        body.append(element: itemAP)
        body.append(element: itemBP)
        body.append(element: feedbackIFrame)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが攻撃者が用意した罠ページです。")])
        appendGuideSection([
            GuideText(text: "もし、先ほど見た脆弱なWebサイトにログインしている状態でこの罠サイトを閲覧してしまうと、攻撃が発動しパスワードがcrackedに変更されてしまいます。"),
            GuideText(text: "これは先ほどみたchange_password.phpがユーザがログインした後にアクセスすることを想定しているのと、正規のルートからアクセスされているかを確認していないのが原因です。")],
                           onEnter: { completion in
                            self.focus(on: self.feedbackChangedText) {
                                completion?()
                            }
        }, onExit:  { completion in
            self.unfocus(elementView: self.feedbackChangedText) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "このユーザの意図していないパスワードの変更を実行したのが赤枠で囲まれている<iframe>要素に埋め込まれている攻撃者が用意したapply.htmlです。", programingLanguages: [.html]),
            GuideText(text: "本来であれば、攻撃者が用意した「http://www.trap.co.jp/apply.html」から「http://www.unsafe.co.jp/change_password.php」へのアクセスは想定しているものではないのでこのアクセスを拒否しなければなりません。"),
            GuideText(text: "しかし、今回はこの処理を怠っていたためこのような攻撃を受けてしまいました。"),
            GuideText(text: "なお、本来であれば攻撃者はこの<iframe>要素をcssなどによって隠します。", programingLanguages: [.html]),
            ], onEnter: { completion in
                self.focus(on: self.feedbackIFrame) {
                    completion?()
                }
        }, onExit: { completion in
            self.unfocus(elementView: self.feedbackIFrame) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "このようにCSRF脆弱性があるとユーザのパスワードを変更するような攻撃が可能になってしまいます。"),
            GuideText(text: "この攻撃が成立してしまうと、攻撃者にこの攻撃を受けたユーザのパスワードを知られている状態になるので非常に危険です。\n対策編でしっかりと対策を学習しましょう。"),
            GuideText(text: "今回のレッスンは以上で終了です。\nお疲れ様でした。")])
        addCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
    @objc
    private func handleLoginButton(_ sender: UIButton) {
        hideGuideMessageCollectionView() {
            self.unfocusAll() {
                self.showHome()
            }
        }
    }
    
    @objc
    private func handleChangeButton(_ sender: UIButton) {
        hideGuideMessageCollectionView() {
            self.unfocusAll() {
                self.showChangePassword()
            }
        }
    }
    
}
