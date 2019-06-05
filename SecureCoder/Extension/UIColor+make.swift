import UIKit

extension UIColor {
    
    static func make(from aHex: String) -> UIColor? {
        var hex = aHex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hex.hasPrefix("#") {
            hex.removeFirst()
        }
        guard hex.count == 6 else {
            return nil
        }
        var rgb: UInt32 = 0
        Scanner(string: hex).scanHexInt32(&rgb)
        return UIColor(red: CGFloat(((rgb & 0xFF0000) >> 16)) / 255,
                       green: CGFloat(((rgb & 0x00FF00) >> 8)) / 255,
                       blue: CGFloat((rgb & 0x0000FF)) / 255,
                       alpha: 1)
    }
    
}
