import UIKit

class A: WebElementView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func set(text: String) {
        attributedText = NSMutableAttributedString(
            string: text,
            attributes: [.foregroundColor: UIColor.linkColor, .underlineColor: UIColor.linkColor, .underlineStyle: NSUnderlineStyle.single.rawValue]
        )
    }
    
    private func setup() {
        frame.size.height = 44
        font = .systemFont(ofSize: 16)
        margin = .zero
        display = .inline
    }
    
}
