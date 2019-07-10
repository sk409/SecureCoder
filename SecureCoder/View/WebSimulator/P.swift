import UIKit

class P: WebElementView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        frame.size.height = 30
        font = .systemFont(ofSize: 16)
        margin = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        display = .block
    }
    
}
