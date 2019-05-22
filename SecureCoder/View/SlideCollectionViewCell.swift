import UIKit

class SlideCollectionViewCell: UICollectionViewCell {
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var content: String? {
        didSet {
            contentTextView.text = content
        }
    }
    
    var imageName: String? {
        didSet {
            guard let imageName = imageName else {
                return
            }
            imageView.image = UIImage(named: imageName)
        }
    }
    
    private let titleLabel = UILabel()
    private let contentTextView = UITextView()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        let headView = UIView()
        addSubview(headView)
        headView.translatesAutoresizingMaskIntoConstraints = false
        headView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        headView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        headView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        headView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.5).isActive = true
        headView.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.heightAnchor, multiplier: 1 / 3).isActive = true
        headView.addSubview(contentTextView)
        contentTextView.isEditable = false
        contentTextView.backgroundColor = .clear
        contentTextView.font = .systemFont(ofSize: 16)
        contentTextView.textColor = .black
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.leadingAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        contentTextView.trailingAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        contentTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        contentTextView.heightAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.heightAnchor, multiplier: 2 / 3).isActive = true
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 3).isActive = true

    }
    
}
