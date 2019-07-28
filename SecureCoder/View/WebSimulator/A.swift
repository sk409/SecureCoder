import UIKit

class A: WebElementButtonView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func set(text: String) {
        set(attributedText: NSAttributedString(string: text, attributes: [.foregroundColor: UIColor.linkColor, .underlineColor: UIColor.linkColor, .underlineStyle: NSUnderlineStyle.single.rawValue]))
    }
    
    private func setup() {
        frame.size.height = 44
        margin = .zero
        display = .inline
        set(font: .systemFont(ofSize: 16))
    }
    
}
