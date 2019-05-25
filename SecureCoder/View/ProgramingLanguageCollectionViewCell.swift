import UIKit

class ProgramingLanguageCollectionViewCell: UICollectionViewCell {
    
    var headerColor: UIColor? {
        didSet {
            headerView.backgroundColor = headerColor
        }
    }
    
    var headerImage: UIImage? {
        didSet {
            headerImageView.image = headerImage
        }
    }
    
    var title: String? {
        didSet {
            titleTextView.text = title
        }
    }
    
    var subtitle: String? {
        didSet {
            subtitleTextView.text = subtitle
        }
    }
    
    private let headerView = UIView()
    private let headerImageView = UIImageView()
    private let titleTextView = UITextView()
    private let subtitleTextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        let containerView = UIView()
        addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
            ])
        containerView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4)
            ])
        headerView.addSubview(headerImageView)
        let headerImageViewSize: CGFloat = 80
        headerImageView.backgroundColor = .black
        headerImageView.layer.cornerRadius = headerImageViewSize * 0.5
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerImageView.centerXAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerXAnchor),
            headerImageView.centerYAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerYAnchor),
            headerImageView.widthAnchor.constraint(equalToConstant: headerImageViewSize),
            headerImageView.heightAnchor.constraint(equalToConstant: headerImageViewSize),
            ])
        let bodyView = UIView()
        containerView.addSubview(bodyView)
        bodyView.backgroundColor = .clear
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyView.centerXAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.centerXAnchor),
            bodyView.topAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.bottomAnchor, constant: 8),
            bodyView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
            bodyView.widthAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9)
            ])
        bodyView.addSubview(titleTextView)
        titleTextView.isEditable = false
        titleTextView.isScrollEnabled = false
        titleTextView.font = .boldSystemFont(ofSize: 22)
        titleTextView.textColor = .black
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextView.leadingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.trailingAnchor),
            titleTextView.topAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.topAnchor),
            titleTextView.heightAnchor.constraint(equalToConstant: 34),
            ])
        bodyView.addSubview(subtitleTextView)
        subtitleTextView.isEditable = false
        subtitleTextView.isScrollEnabled = false
        subtitleTextView.font = .systemFont(ofSize: 18)
        subtitleTextView.textColor = .black
        subtitleTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleTextView.leadingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.leadingAnchor),
            subtitleTextView.trailingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.trailingAnchor),
            subtitleTextView.topAnchor.constraint(equalTo: titleTextView.safeAreaLayoutGuide.bottomAnchor, constant: 8),
            subtitleTextView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
}
