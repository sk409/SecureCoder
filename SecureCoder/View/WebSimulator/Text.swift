import UIKit

class Text: WebElementLabelView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        frame.size.height = 44
        margin = .zero
        display = .inline
        set(font: .systemFont(ofSize: 16))
    }
    
}
