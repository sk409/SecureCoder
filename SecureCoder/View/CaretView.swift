import UIKit

class CaretView: UIView {
    
    var animationTimeInterval: TimeInterval = 0.7
    var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func startAnimation() {
        alpha = 1
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: animationTimeInterval, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
    }
    
    func stopAnimation() {
        alpha = 0
        timer?.invalidate()
    }
    
    private func setupViews() {
        alpha = 0
    }
    
    @objc
    private func animate() {
        isHidden = !isHidden
    }
    
}
