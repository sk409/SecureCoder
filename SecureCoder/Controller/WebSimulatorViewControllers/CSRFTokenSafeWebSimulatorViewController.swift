import UIKit

class CSRFTokenSafeWebSimulatorViewController: WebSimulatorViewController {
    
    let featuredItemsH1 = H1()
    let itemAP = P()
    let itemBP = P()
    let feedbackIFrame = IFrame()
    
    let feedbackView = Body()
    let feedbackText = Text()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showTrap()
    }
    
    private func setupViews() {
        featuredItemsH1.set(text: "おすすめの商品紹介")
        itemAP.set(text: "商品A")
        itemBP.set(text: "商品B")
        feedbackIFrame.set(code: """
<iframe src="apply.html"></iframe>
""", language: .html)
        feedbackText.set(text: "正規の画面からご利用ください。")
        feedbackText.set(code: """
die("正規の画面からご利用ください。");
""", language: .php)
    }
    
    private func showTrap() {
        feedbackView.append(element: feedbackText)
        feedbackIFrame.webElementContainerView = feedbackView
        body.clear()
        body.append(element: featuredItemsH1)
        body.append(element: itemAP)
        body.append(element: itemBP)
        body.append(element: feedbackIFrame)
        clearGuideSections()
        appendGuideSection([
            GuideText(text: "これが攻撃者が用意した罠ページです。"),
            GuideText(text: "正規のパスワード変更手順は体験編で見た内容と同じなので今回はこの罠ページから解説を始めていきます。"),
            ])
        appendGuideSection([
            GuideText(text: "今回は体験編とは違い、「正規の画面からご利用ください。」と表示されています。\nこれはchange_password.phpで正規のルートからのアクセスではないと判定されたからです。"),
            GuideText(text: """
体験編で見たように攻撃者が用意した攻撃用の<form>要素は以下でした。
<form method="post" action="http://www.safe.co.jp/change_password.php">
    <input type="hidden" name="new_password" value="cracked">
</form>
""", programingLanguages: [.html]),
            GuideText(text: "つまり攻撃者はPOSTリクエストでトークンの値を送信していません。"),
            GuideText(text: "ユーザがWebサイトにログインしている場合には、先ほどコーディングした次の部分で正規のルートからのアクセスではないと判定されます。"),
            GuideText(text: """
$token !== $_SESSION["token"]
""", programingLanguages: [.php]),
            GuideText(text: """
$tokenは以下のようにして取得されていたことを思い出してください。
$token = $_POST["token"]
""", programingLanguages: [.php]),
            GuideText(text: "もし、攻撃者がPOSTリクエストでトークンの値を送信しようとしてもユーザの$_SESSIONに保存されているトークンを知ることができないので、CSRF攻撃を仕掛けることはできません。", programingLanguages: [.php]),
            GuideText(text: "以上のようにユーザがログインしている場合には攻撃が無効化されますが、ユーザがログインしていない場合にはそもそもこの攻撃は成立しません。"),
            GuideText(text: "ユーザのパスワードを変更しているchange関数は$_SESSIONに格納されているユーザIDから、どのユーザのパスワードを変更するかを判断していたからです。", programingLanguages: [.php])
            ],
                           onEnter: { completion in
                            self.focus(on: self.feedbackText) {
                                completion?()
                            }
        }, onExit:  { completion in
            self.unfocus(elementView: self.feedbackText) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "これで、CSRF攻撃への対策を行うことができました。"),
            GuideText(text: "今回はトークンを用いて対策を行なってきました。\nトークンを用いた対策はあらゆる場面で使用されています。"),
            GuideText(text: "この他のCSRFのレッスンでは他の対策法も紹介していますが、そのレッスンで解説しているような状況でなければこのトークンによる対策を行ってください。"),
            GuideText(text: "今回のレッスンは以上で終了です。\nこの他にも様々なレッスンを用意していますので、そちらも参考にしてみてください。"),
            GuideText(text: "お疲れ様でした。")])
        addCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
}
