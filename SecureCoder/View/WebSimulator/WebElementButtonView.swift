import UIKit

class WebElementButtonView: WebElementView {
    
    let button = UIButton()
    
    override var fitSize: CGSize {
        return button.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func set(text: String) {
        button.setTitle(text, for: .normal)
        frame.size.width = button.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity)).width
    }
    
    func set(attributedText: NSAttributedString) {
        button.setAttributedTitle(attributedText, for: .normal)
        frame.size.width = button.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity)).width
    }
    
    func set(font: UIFont) {
        button.titleLabel?.font = font
    }
    
    private func setupViews() {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            button.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
}
