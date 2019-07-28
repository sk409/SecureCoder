import UIKit


class Input: WebElementTextFieldView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        margin = .zero
        display = .inline
        frame.size = CGSize(width: 280, height: 44)
    }
    
    
}
