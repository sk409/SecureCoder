import UIKit

class CaretView: UIView {
    
    var animationTimeInterval: TimeInterval = 0.7
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        Timer.scheduledTimer(timeInterval: animationTimeInterval, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
    }
    
    @objc
    private func animate() {
        isHidden = !isHidden
    }
    
}
