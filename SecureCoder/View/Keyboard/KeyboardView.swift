import UIKit

class KeyboardView: UIView {
    
    var buttons = [KeyboardButton]()
    
    func makeButton() -> KeyboardButton {
        return KeyboardButton(type: .system)
    }
    
    func alignButtons(groups: [KeyboardButton]...) {
        guard !groups.isEmpty else {
            return
        }
        for group in groups {
            for button in group {
                addSubview(button)
                buttons.append(button)
                button.frame.size = button.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
                button.frame.size.width = max(44, button.frame.size.width)
                button.frame.size.height = max(44, button.frame.size.height)
            }
        }
        groups.forEach { $0.forEach { $0.frame.size = $0.sizeThatFits(CGSize(width: CGFloat.infinity, height: CGFloat.infinity))}}
        let spacing: CGFloat = 12
        let groupWidths = groups.map { $0.reduce(0, {$0 + $1.bounds.size.width}) + (spacing * CGFloat($0.count - 1))}
        let maxGroupWidth = groupWidths.max()!
        var y: CGFloat = 8
        var maxX: CGFloat = 0
        var maxY: CGFloat = 0
        for group in groups {
            _ = group.reduce(spacing) { offset, button in
                button.frame.origin = CGPoint(x: offset, y: y)
                maxX = max(maxX, button.frame.maxX)
                maxY = max(maxY, button.frame.maxY)
                return offset + button.frame.size.width + spacing
            }
            y = maxY
            y += spacing
        }
        frame.size = CGSize(width: maxX, height: maxY + spacing)
        for (groupIndex, group) in groups.enumerated() {
            for button in group {
                button.frame.origin.x += (bounds.size.width - groupWidths[groupIndex]) / 2
            }
        }
        frame.size.width += (bounds.size.width - maxGroupWidth) / 2 + spacing
    }
    
}
