import UIKit

struct NotificationMessage {
    
    enum AxisX {
        case left
        case right
        case center
    }
    
    enum AxisY {
        case top
        case bottom
        case center
    }
    
    static func send(text: String, axisX: AxisX, axisY: AxisY, size: CGSize?, font: UIFont, textColor: UIColor, backgroundColor: UIColor, lifeSeconds: TimeInterval) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let label = UILabel()
        window.addSubview(label)
        label.text = text
        label.font = font
        if let size = size {
            label.frame.size = size
        } else {
            let size = label.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
            label.frame.size = size
        }
        switch axisX {
        case .left:
            label.frame.origin.x = window.safeAreaInsets.left
        case .right:
            label.frame.origin.x = window.safeAreaLayoutGuide.layoutFrame.maxX - label.bounds.size.width
        case .center:
            label.frame.origin.x = (window.bounds.width - window.safeAreaInsets.left - window.safeAreaInsets.right) / 2 - (label.bounds.size.width / 2)
        }
        switch axisY {
        case .top:
            label.frame.origin.y = window.safeAreaInsets.top
        case .bottom:
            label.frame.origin.y = window.safeAreaLayoutGuide.layoutFrame.maxY - label.bounds.height
        case .center:
            label.frame.origin.y = (window.bounds.height - window.safeAreaInsets.top - window.safeAreaInsets.bottom) / 2 - (label.bounds.height / 2)
        }
        label.backgroundColor = backgroundColor
        label.textColor = textColor
        label.textAlignment = .center
        UIView.animate(withDuration: lifeSeconds, animations: {
            label.alpha = 0
        }) { _ in
            label.removeFromSuperview()
        }
    }
    
}
