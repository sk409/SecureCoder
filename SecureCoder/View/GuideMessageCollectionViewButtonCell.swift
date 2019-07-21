import UIKit

class GuideMessageCollectionViewButtonCell: UICollectionViewCell {
    
    let button = UIButton(type: .system)
    
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
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            ])
    }
    
}

