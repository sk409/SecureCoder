import UIKit

class DetailViewController: UIViewController {
    
    enum CourseType: String {
        case xss = "XSS"
        case sqlInjection = "SQLインジェクション"
        case csrf = "CSRF"
    }
    
    private struct Detail {
        let title: String
        let content: String
    }
    
    var courseType: CourseType? {
        didSet {
            guard let courseType = courseType else {
                return
            }
            switch courseType {
            case .xss:
                detail = Detail(
                    title: courseType.rawValue,
                    content: """
XSSとは「クロスサイトスクリプティング」の略称です。
XSSは、ユーザのアクセス時に表示内容が生成される動的なWebページにある脆弱性を利用してスクリプトの埋め込みやHTMLの改ざんを行う攻撃です。
この攻撃が成立してしまうとユーザ環境でスクリプトが実行されてしまうため個人情報が流出してしまったり、HTMLの改ざんによって機密情報を入力して攻撃者に送信してしまうなどの被害をもたらします。
""")
            case .sqlInjection:
                detail = Detail(
                    title: courseType.rawValue,
                    content: """
SQLインジェクションとはデータベースを操作できる言語であるSQLを動的に生成しているWebページの脆弱性を狙い、SQL文内に不正な命令を注入してデータベースの改ざんやデータベース内の情報の取得を行います。
SQLインジェクション攻撃は比較的対策しやすいですが、もしこの脆弱性を作り込んでしまうと取り返しのつかないような非常に大きな被害をもたらしますので、しっかりと対策を行いましょう。
""")
            case .csrf:
                detail = Detail(
                    title: courseType.rawValue,
                    content: """
CSRFとは「クロスサイトリクエストフォージェリ」の略称です。
CSRFは本来拒否すべき他サイトからのリクエストを受信してしまい、ログイン状態の乗っ取りやSNSへの投稿などを行う攻撃です。
あるページから遷移して来ることを想定しているWebページで遷移元が本当に想定している遷移元なのかを確認していないと、このCSRF脆弱性となってしまいます。
""")
            }
        }
    }
    
    private var detail: Detail? {
        didSet {
            guard let detail = detail else {
                return
            }
            titleLabel.text = detail.title
            contentTextView.text = detail.content
        }
    }
    
    private let titleLabel = UILabel()
    private let contentTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        let headerView = UIView()
        let backButton = UIButton()
        let separatorView = UIView()
        let bodyView = UIView()
        view.addSubview(headerView)
        view.addSubview(bodyView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(backButton)
        view.addSubview(separatorView)
        bodyView.addSubview(contentTextView)
        
        headerView.backgroundColor = .systemBlue
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            ])
        
        bodyView.backgroundColor = .white
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            bodyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            ])
        
        backButton.setBackgroundImage(UIImage(named: "cross-icon"), for: .normal)
        backButton.addTarget(self, action: #selector(handleBackButton(_:)), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.trailingAnchor.constraint(equalTo: contentTextView.trailingAnchor),
            backButton.centerYAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor)
            ])
        
        separatorView.backgroundColor = .lightGray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            ])
        
        contentTextView.font = .systemFont(ofSize: 18)
        contentTextView.textColor = .black
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentTextView.centerXAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.centerXAnchor),
            contentTextView.centerYAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.centerYAnchor),
            contentTextView.widthAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            contentTextView.heightAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
            ])
        
    }
    
    @objc
    private func handleBackButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
