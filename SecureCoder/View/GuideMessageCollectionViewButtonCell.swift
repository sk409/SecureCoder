import UIKit

class GuideMessageCollectionViewButtonCell: UICollectionViewCell {
    
    let button = UIButton(type: .system)
    
    var buttonTitle: String? {
        didSet {
            button.setTitle(buttonTitle, for: .normal)
            let buttonSize = button.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
            buttonWidthConstraint?.constant = buttonSize.width + 8
        }
    }
    
    private var buttonWidthConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(button)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .forestGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonWidthConstraint = button.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            buttonWidthConstraint!,
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            ])
    }
    
}

