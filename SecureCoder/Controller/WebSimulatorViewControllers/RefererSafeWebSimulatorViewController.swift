import UIKit

class RefererSafeWebSimulatorViewController: WebSimulatorViewController {
    
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
            GuideText(text: "攻撃者はこの<iframe>要素に埋め込んだapply.htmlからhttp://www.co.jp/change_password.phpにアクセスしていました。", programingLanguages: [.html]),
            GuideText(text: "つまり、http://www.co.jp/change_password.phpでrefererを確認するとhttp://www.trap.co.jp/apply.htmlとなります。"),
            GuideText(text: """
よって先ほどコーディングを行なった以下の文で正規の遷移元ではないと判定され、処理が中断されます。
なお、見切れている場合はスクロールすることで最後まで確認することができます。
if ($_SERVER["HTTP_REFERER"] !== "http://www.safe.co.jp/home.php") {
    die("正規の画面からご利用ください。");
}
""", programingLanguages: [.php])],
                           onEnter: { completion in
                            self.focus(on: self.feedbackIFrame) {
                                completion?()
                            }
        }, onExit: { completion in
            self.unfocus(elementView: self.feedbackIFrame) {
                completion?()
            }
        })
        appendGuideSection([
            GuideText(text: "これで、CSRF攻撃への対策を行うことができました。"),
            GuideText(text: "今回はrefererを確認することで対策を行なってきました。"),
            GuideText(text: "refererによる対策はCSRF対策を施したいページにのみコードを追加すれば良いため、工数を少なく抑えることができます"),
            GuideText(text: "しかし、refererはファイアウォールやブラウザで送信しないように設定することができるため、そういった設定を行っているユーザをサポートできません。"),
            GuideText(text: "さらに、今回はurlを直接条件として使用しましたが、正規表現を用いてあるドメインからのアクセスを許可するなど、条件が複雑になってくると、バグを作り込みやすくセキュリティホールになってしまう可能性があります。"),
            GuideText(text: "よって、refererによる対策は社内向けアプリなど、利用者の環境を限定できる場合で工数を少なく抑えたい場合に検討することをお勧めします。"),
            GuideText(text: "今回のレッスンは以上で終了です。\nこの他にも様々なレッスンを用意していますので、そちらも参考にしてみてください。"),
            GuideText(text: "お疲れ様でした。")])
        addCloseButton()
        guideMessageCollectionView.reloadData()
        guideMessageCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        showGuideMessageCollectionView()
    }
    
}
