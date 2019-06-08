import UIKit

struct Animator {
    
    func flashAnimation(on viewController: UIViewController, view: UIView, duration: TimeInterval, repeatCount: Int) {
        viewController.view.addSubview(view)
        
    }
    
}
