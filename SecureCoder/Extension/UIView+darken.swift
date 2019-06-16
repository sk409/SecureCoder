import UIKit

extension UIView {
    
    func darken(coeff: CGFloat) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        if backgroundColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) ?? false {
            backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness * coeff, alpha: alpha)
        }
    }
    
}
