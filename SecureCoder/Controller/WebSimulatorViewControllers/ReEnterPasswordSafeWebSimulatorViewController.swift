import UIKit

class ReEnterPasswordSafeWebSimulatorViewController: WebSimulatorViewController {
    
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
        feedbackText.set(text: "ログインしていないかパスワードが正しくありません。")
        feedbackText.set(code: """
die("ログインしていないかパスワードが正しくありません。");
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
            GuideText(text: "なお、ユーザはこの罠ページを閲覧する前に正規のWebサイトにログインしているとします。"),
            ])
        appendGuideSection([
            GuideText(text: "今回は体験編とは違い、「ログインしていないかパスワードが正しくありません。」と表示されています。"),
            GuideText(text: "今ユーザはログインしているので、change_password.phpで現在のパスワードが正しくないと判定されたことが分かります。"),
            GuideText(text: """
体験編で見たように攻撃者が用意した攻撃用の<form>要素は以下でした。
<form method="post" action="http://www.safe.co.jp/change_password.php">
    <input type="hidden" name="new_password" value="cracked">
</form>
""", programingLanguages: [.html]),
            GuideText(text: "つまり攻撃者はPOSTリクエストで現在のパスワードの値を送信していません。"),
            GuideText(text: "これによって、auth.phpで定義していたisExists関数による認証に失敗します。"),
            GuideText(text: "もし、攻撃者がPOSTリクエストで現在のパスワードの値を送信しようとしてもユーザの現在のパスワードを知ることができないので、CSRF攻撃を仕掛けることはできません。", programingLanguages: [.php]),
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
            GuideText(text: "今回はパスワードの再入力を用いて対策を行なってきました。\nパスワードの再入力による対策は非常に強力ですが煩雑になるというデメリットもあります。"),
            GuideText(text: "パスワードの再入力による対策は重要な処理を行うために本人であることを保証したい場合や、同じ端末を複数人で使う可能性がある場合に導入を検討することをお勧めします。"),
            GuideText(text: "今回のレッスンは以上で終了です。\nこの他にも様々なレッスンを用意していますので、そちらも参考にしてみてください。"),
            GuideText(text: "お疲れ様でした。")])
        addCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
}
