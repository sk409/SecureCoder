import UIKit

class CourseCardView: UIView {
    
    var course: Course? {
        didSet {
            headerView.backgroundColor = course?.language.themeColor
            headerImageView.image = course?.language.iconImage
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var content: String? {
        didSet {
            contentLabel.text = content
        }
    }
    
    private let headerView = UIView()
    private let headerImageView = UIImageView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.1
        
        addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.4)
            ])
        headerView.addSubview(headerImageView)
        headerImageView.contentMode = .scaleAspectFit
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerImageView.centerXAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerXAnchor),
            headerImageView.centerYAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerYAnchor),
//            headerImageView.widthAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            headerImageView.heightAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6),
            ])
        let bodyView = UIView()
        addSubview(bodyView)
        bodyView.backgroundColor = .clear
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.bottomAnchor),
            bodyView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
        bodyView.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.topAnchor, constant: 16),
            ])
        bodyView.addSubview(contentLabel)
        contentLabel.font = .systemFont(ofSize: 14)
        contentLabel.textColor = .black
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor, constant: 8),
            ])
    }
    
}
