import UIKit

class Text: WebElementView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        frame.size.height = 17
        font = .systemFont(ofSize: 16)
        margin = .zero
        display = .inline
    }
    
}
