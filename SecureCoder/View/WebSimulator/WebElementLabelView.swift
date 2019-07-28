import UIKit

class WebElementLabelView: WebElementView {
    
    let label = UILabel()
    
    override var fitSize: CGSize {
        return label.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
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
        label.text = text
        if display == .inline {
            frame.size.width = label.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity)).width
        }
    }
    
    func set(font: UIFont) {
        label.font = font
    }
    
    private func setupViews() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
}
