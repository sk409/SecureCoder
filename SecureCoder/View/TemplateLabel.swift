import UIKit

class TemplateLabel: UILabel, Focusable {
    
    var range: NSRange?
    var line = 0
    var cache = [String: Any]()
    
    func focus(with duration: TimeInterval, borderWidth: CGFloat, borderColor: CGColor, backgroundColor: UIColor) {
        cache["backgroundColor"] = self.backgroundColor
        cache["layer.borderWidth"] = layer.borderWidth
        cache["layer.borderColor"] = layer.borderColor
        self.backgroundColor = backgroundColor
        layer.removeAllAnimations()
        let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderWidthAnimation.toValue = borderWidth
        borderWidthAnimation.duration = duration
        borderWidthAnimation.isRemovedOnCompletion = false
        borderWidthAnimation.fillMode = .forwards
        layer.add(borderWidthAnimation, forKey: "borderWidthAnimation")
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.toValue = borderColor
        borderColorAnimation.duration = duration
        borderColorAnimation.isRemovedOnCompletion = false
        borderColorAnimation.fillMode = .forwards
        layer.add(borderColorAnimation, forKey: "borderColorAnimation")
    }
    
    func unfocus(with duration: TimeInterval) {
        guard let backgroundColor = cache["backgroundColor"] as? UIColor,
            let borderWidth = cache["layer.borderWidth"],
            let borderColor = cache["layer.borderColor"]
            else {
                return
        }
        layer.removeAllAnimations()
        self.backgroundColor = backgroundColor
        let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderWidthAnimation.toValue = borderWidth
        borderWidthAnimation.duration = duration
        borderWidthAnimation.isRemovedOnCompletion = false
        borderWidthAnimation.fillMode = .forwards
        layer.add(borderWidthAnimation, forKey: "borderWidthAnimation")
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.toValue = borderColor
        borderColorAnimation.duration = duration
        borderColorAnimation.isRemovedOnCompletion = false
        borderColorAnimation.fillMode = .forwards
        layer.add(borderColorAnimation, forKey: "borderColorAnimation")
    }
    
}
