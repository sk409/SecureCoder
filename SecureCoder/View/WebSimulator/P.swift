import UIKit

class P: WebElementLabelView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        frame.size.height = 58
        margin = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        display = .block
        set(font: .systemFont(ofSize: 16))
    }
    
}
