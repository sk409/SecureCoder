import UIKit

class Button: WebElementButtonView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        margin = .zero
        display = .inline
        frame.size.height = 44
        layer.cornerRadius = frame.size.height * 0.1
        layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        layer.borderWidth = 1
        button.setTitleColor(.black, for: .normal)
    }
    
}
