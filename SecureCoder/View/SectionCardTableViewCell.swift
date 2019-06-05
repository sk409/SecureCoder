import UIKit

class SectionCardTableViewCell: UITableViewCell {
    
    var section: Section? {
        didSet {
            titleLabel.text = section?.title
        }
    }
    
    var language: ProgramingLanguage? {
        didSet {
            transitionToCodeViewControllerButton.backgroundColor = language?.themeColor
            transitionToCodeViewControllerButton.setTitleColor(language?.tintColor, for: .normal)
        }
    }
    
    var transitionToCodeViewController: ((Lesson) -> Void)?
    
    private let titleLabel = UILabel()
    private let transitionToLessonsViewControllerButton = UIButton()
    private let transitionToCodeViewControllerButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 8
        
        let container = UIView()
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            container.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            container.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.9),
            ])
        
        container.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor),
            ])
        transitionToLessonsViewControllerButton.setTitle("詳細を確認する", for: .normal)
        transitionToLessonsViewControllerButton.setTitleColor(.lightGray, for: .normal)
        transitionToLessonsViewControllerButton.titleLabel?.font = .systemFont(ofSize: 14)
        transitionToCodeViewControllerButton.setTitle("続きから学習する", for: .normal)
        transitionToCodeViewControllerButton.titleLabel?.font = .systemFont(ofSize: 14)
        transitionToCodeViewControllerButton.layer.cornerRadius = 12
        transitionToCodeViewControllerButton.addTarget(self, action: #selector(handleTransitionToCodeViewControllerButton(_:)), for: .touchUpInside)
        
        let buttonsStackView = UIStackView(arrangedSubviews: [transitionToLessonsViewControllerButton, transitionToCodeViewControllerButton])
        container.addSubview(buttonsStackView)
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            buttonsStackView.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
    @objc
    private func handleTransitionToCodeViewControllerButton(_ sender: UIButton) {
        ///////////////////////////////////
        // TODO: とりあえず
        let lesson = section!.lessons.first!
        ///////////////////////////////////
        transitionToCodeViewController?(lesson)
    }
    
}
