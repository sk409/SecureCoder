import UIKit

class SectionCardTableViewCell: UITableViewCell {
    
    var section: Section? {
        didSet {
            titleLabel.text = section?.title
            contentTextView.text = section?.content
            section?.skills.forEach { skill in
                let skillLabel = UILabel()
                skillLabel.text = skill
                skillLabel.textColor = .black
                skillLabel.textAlignment = .center
                skillLabel.font = .systemFont(ofSize: 16)
                skillsStackView.addArrangedSubview(skillLabel)
            }
        }
    }
    
    var language: ProgramingLanguage? {
        didSet {
            headView.backgroundColor = language?.themeColor
            skillsContainerView.backgroundColor = language?.themeColor
            transitionToCodeViewControllerButton.setTitleColor(language?.tintColor, for: .normal)
        }
    }
    
    let transitionToLessonsViewControllerButton = SectionButton()
    let transitionToCodeViewControllerButton = SectionButton()
    private let headView = UIView()
    private let titleLabel = UILabel()
    private let contentTextView = UITextView()
    private let skillsContainerView = UIView()
    private let skillsStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        clipsToBounds = true
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 10
        
        addSubview(headView)
        headView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            headView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            headView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            ])
        
        headView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.centerYAnchor),
            ])
        
        let bodyView = UIView()
        addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: headView.bottomAnchor),
            bodyView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            bodyView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.6)
            ])
        
        bodyView.addSubview(contentTextView)
        contentTextView.font = .systemFont(ofSize: 18)
        contentTextView.isEditable = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentTextView.centerXAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.centerXAnchor),
            contentTextView.topAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.topAnchor, constant: 8),
            contentTextView.widthAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            contentTextView.heightAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3),
            ])
        
        bodyView.addSubview(skillsContainerView)
        skillsContainerView.layer.cornerRadius = 10
        skillsContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skillsContainerView.centerXAnchor.constraint(equalTo: contentTextView.centerXAnchor),
            skillsContainerView.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 8),
            skillsContainerView.bottomAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.bottomAnchor),
            skillsContainerView.widthAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6)
            ])
        
        let skillsTitleLabel = UILabel()
        skillsTitleLabel.text = "身につくスキル"
        skillsTitleLabel.textColor = .black
        skillsTitleLabel.textAlignment = .center
        skillsTitleLabel.font = .boldSystemFont(ofSize: 18)
        skillsStackView.addArrangedSubview(skillsTitleLabel)
        skillsContainerView.addSubview(skillsStackView)
        skillsStackView.axis = .vertical
        skillsStackView.distribution = .fillEqually
        skillsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skillsStackView.leadingAnchor.constraint(equalTo: skillsContainerView.safeAreaLayoutGuide.leadingAnchor),
            skillsStackView.trailingAnchor.constraint(equalTo: skillsContainerView.safeAreaLayoutGuide.trailingAnchor),
            skillsStackView.topAnchor.constraint(equalTo: skillsContainerView.safeAreaLayoutGuide.topAnchor),
            skillsStackView.bottomAnchor.constraint(equalTo: skillsContainerView.safeAreaLayoutGuide.bottomAnchor),
            ])
        
        let footView = UIView()
        addSubview(footView)
        footView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            footView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            footView.topAnchor.constraint(equalTo: bodyView.bottomAnchor),
            footView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
        
        
        transitionToLessonsViewControllerButton.setTitle("詳細を確認する", for: .normal)
        transitionToLessonsViewControllerButton.setTitleColor(.lightGray, for: .normal)
        transitionToLessonsViewControllerButton.titleLabel?.font = .systemFont(ofSize: 14)
        transitionToCodeViewControllerButton.setTitle("続きから学習する", for: .normal)
        transitionToCodeViewControllerButton.titleLabel?.font = .systemFont(ofSize: 14)
        transitionToCodeViewControllerButton.layer.cornerRadius = 12
        
        let buttonsStackView = UIStackView(arrangedSubviews: [transitionToLessonsViewControllerButton, transitionToCodeViewControllerButton])
        footView.addSubview(buttonsStackView)
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: footView.safeAreaLayoutGuide.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: footView.safeAreaLayoutGuide.trailingAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: footView.safeAreaLayoutGuide.topAnchor, constant: 16),
            buttonsStackView.bottomAnchor.constraint(equalTo: footView.safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
}
