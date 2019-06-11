import UIKit

class CaretView: UIView {
    
    var animationTimeInterval: TimeInterval = 0.7
    var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        startAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        startAnimation()
    }
    
    func startAnimation() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: animationTimeInterval, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
    }
    
    func stopAnimation() {
        timer?.invalidate()
    }
    
    @objc
    private func animate() {
        isHidden = !isHidden
    }
    
}
