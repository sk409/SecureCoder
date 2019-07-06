import UIKit

struct NotificationMessage {
    
    static func send(text: String, origin: CGPoint, font: UIFont, textColor: UIColor, backgroundColor: UIColor) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let label = UILabel()
        window.addSubview(label)
        label.frame.origin = origin
        label.text = text
        label.font = font
        label.backgroundColor = backgroundColor
        label.textColor = textColor
        label.textAlignment = .center
        let size = label.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
        label.frame.size = CGSize(width: size.width * 2, height: size.height * 1.3)
        UIView.animate(withDuration: 1, animations: {
            label.alpha = 0
        }) { _ in
            label.removeFromSuperview()
        }
    }
    
}
