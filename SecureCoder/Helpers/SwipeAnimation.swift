import UIKit

struct SwipeAnimation {
    
    let imageView = UIImageView(image: UIImage(named: "swipe-icon"))
    
    func start(on view: UIView) {
        guard imageView.superview == nil else {
            return
        }
        view.addSubview(imageView)
        let iconSize = view.bounds.width * 0.08
        imageView.frame.size = CGSize(width: iconSize, height: iconSize)
        imageView.frame.origin.x = view.safeAreaLayoutGuide.layoutFrame.width - imageView.bounds.width
        imageView.frame.origin.y = view.safeAreaLayoutGuide.layoutFrame.height - imageView.bounds.height
        imageView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat], animations: {
                self.imageView.frame.origin.x -= view.bounds.width * 0.25
            }, completion: nil)
        }
    }
    
    func stop() {
        guard imageView.superview != nil else {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0
        }) {_ in
            self.imageView.removeFromSuperview()
        }
    }
    
}
