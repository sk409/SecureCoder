import UIKit

class H1: WebElementLabelView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        frame.size.height = 60
        margin = UIEdgeInsets(top: 10, left: 0, bottom: 16, right: 0)
        display = .block
        set(font: .boldSystemFont(ofSize: 32))
    }
    
}
