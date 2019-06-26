import UIKit

struct SlidesLauncher {
    
    let slidesView = SlidesView()
    
    func show(slides: [Slide]) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        window.addSubview(slidesView)
        slidesView.slides = slides
        slidesView.hideFunction = hideSlides
        slidesView.frame = CGRect(x: 0, y: window.frame.origin.y + window.bounds.width, width: window.bounds.width, height: window.bounds.height)
        UIView.animate(withDuration: 0.5) {
            self.slidesView.frame.origin.y = 0
        }
    }
    
    func hideSlides() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.slidesView.frame.origin.y = window.frame.origin.y + window.bounds.height
        }) { _ in
            self.slidesView.removeFromSuperview()
        }
    }
    
}
