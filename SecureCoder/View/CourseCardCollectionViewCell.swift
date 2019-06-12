import UIKit

class CourseCardCollectionViewCell: UICollectionViewCell {
    
    var course: Course? {
        didSet {
            guard let course = course else {
                return
            }
            headView.backgroundColor = course.language.themeColor
            iconImageView.image = course.language.iconImage
            checkMarkIconImageView1.image = course.language.checkMarkIconImage
            checkMarkIconImageView2.image = course.language.checkMarkIconImage
            bubbleImageView.image = course.language.bubbleImage
            numberOfSectionsLabel.text = "全" + String(course.sections.count) + "セクション"
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var content1: String? {
        didSet {
            contentLabel1.text = content1
        }
    }
    var content2: String? {
        didSet {
            contentLabel2.text = content2
        }
    }
    
    private let headView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let numberOfSectionsLabel = UILabel()
    private let checkMarkIconImageView1 = UIImageView()
    private let contentLabel1 = UILabel()
    private let checkMarkIconImageView2 = UIImageView()
    private let contentLabel2 = UILabel()
    private let bubbleImageView = UIImageView()
    
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
        
        addSubview(headView)
        headView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            headView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            headView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.333)
            ])
        headView.addSubview(iconImageView)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.1),
            ])
        headView.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            ])
        headView.addSubview(numberOfSectionsLabel)
        numberOfSectionsLabel.font = .systemFont(ofSize: 16)
        numberOfSectionsLabel.textColor = .black
        numberOfSectionsLabel.textAlignment = .right
        numberOfSectionsLabel.numberOfLines = 0
        numberOfSectionsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberOfSectionsLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            numberOfSectionsLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            numberOfSectionsLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            ])
        let bodyView = UIView()
        addSubview(bodyView)
        bodyView.backgroundColor = .clear
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.bottomAnchor),
            bodyView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -44),
            ])
        bodyView.addSubview(checkMarkIconImageView1)
        checkMarkIconImageView1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkMarkIconImageView1.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            checkMarkIconImageView1.topAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.topAnchor, constant: 16),
            checkMarkIconImageView1.widthAnchor.constraint(equalToConstant: 40),
            checkMarkIconImageView1.heightAnchor.constraint(equalTo: checkMarkIconImageView1.widthAnchor),
            ])
        bodyView.addSubview(contentLabel1)
        contentLabel1.font = .systemFont(ofSize: 18)
        contentLabel1.textColor = .black
        contentLabel1.textAlignment = .left
        contentLabel1.numberOfLines = 0
        contentLabel1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel1.leadingAnchor.constraint(equalTo: checkMarkIconImageView1.trailingAnchor, constant: 12),
            contentLabel1.trailingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.trailingAnchor),
            contentLabel1.centerYAnchor.constraint(equalTo: checkMarkIconImageView1.safeAreaLayoutGuide.centerYAnchor),
            ])
        bodyView.addSubview(checkMarkIconImageView2)
        checkMarkIconImageView2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkMarkIconImageView2.leadingAnchor.constraint(equalTo: checkMarkIconImageView1.leadingAnchor),
            checkMarkIconImageView2.topAnchor.constraint(equalTo: checkMarkIconImageView1.bottomAnchor, constant: 12),
            checkMarkIconImageView2.widthAnchor.constraint(equalTo: checkMarkIconImageView1.widthAnchor),
            checkMarkIconImageView2.heightAnchor.constraint(equalTo: checkMarkIconImageView2.widthAnchor),
            ])
        bodyView.addSubview(contentLabel2)
        contentLabel2.font = contentLabel1.font
        contentLabel2.textColor = contentLabel1.textColor
        contentLabel2.textAlignment = contentLabel1.textAlignment
        contentLabel2.numberOfLines = contentLabel1.numberOfLines
        contentLabel2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel2.leadingAnchor.constraint(equalTo: contentLabel1.leadingAnchor),
            contentLabel2.trailingAnchor.constraint(equalTo: contentLabel1.trailingAnchor),
            contentLabel2.centerYAnchor.constraint(equalTo: checkMarkIconImageView2.safeAreaLayoutGuide.centerYAnchor),
            ])
        let footView = UIView()
        addSubview(footView)
        footView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            footView.topAnchor.constraint(equalTo: bodyView.bottomAnchor),
            footView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            footView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            ])
        footView.addSubview(bubbleImageView)
        let dummyView = UIView()
        footView.addSubview(dummyView)
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dummyView.leadingAnchor.constraint(equalTo: footView.safeAreaLayoutGuide.leadingAnchor),
            dummyView.topAnchor.constraint(equalTo: footView.safeAreaLayoutGuide.topAnchor),
            dummyView.bottomAnchor.constraint(equalTo: footView.safeAreaLayoutGuide.bottomAnchor),
            dummyView.widthAnchor.constraint(equalToConstant: 64),
            ])
        bubbleImageView.contentMode = .scaleAspectFit
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bubbleImageView.leadingAnchor.constraint(equalTo: dummyView.trailingAnchor, constant: 8),
            bubbleImageView.topAnchor.constraint(equalTo: footView.safeAreaLayoutGuide.topAnchor),
            bubbleImageView.bottomAnchor.constraint(equalTo: footView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            ])
        
    }
    
}
