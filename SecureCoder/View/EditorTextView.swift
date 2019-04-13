import UIKit

class EditorTextView: UITextView {
    
    static let scrollIndicatorWidth: CGFloat = 15
    
    var maxLineWidth: CGFloat {
        guard let text = self.text else {
            return 0
        }
        guard let font = self.font else {
            return 0
        }
        var line = ""
        var maxLineWidth: CGFloat = 0
        for character in text {
            if character == "\n" {
                let lineWidth = line.size(withAttributes: [NSAttributedString.Key.font: font]).width
                if maxLineWidth < lineWidth {
                    maxLineWidth = lineWidth
                }
                line.removeAll()
            } else {
                line.append(character)
            }
        }
        if maxLineWidth == 0 {
            maxLineWidth = line.size(withAttributes: [NSAttributedString.Key.font: font]).width
        }
        return maxLineWidth + EditorTextView.scrollIndicatorWidth
    }
    
    func lineWidth(location: Int) -> CGFloat {
        guard let text = self.text else {
            return 0
        }
        guard let font = self.font else {
            return 0
        }
        var line = ""
        for index in 0...location {
            let character = text[index]
            if character == "\n" {
                line.removeAll()
            } else {
                line.append(character)
            }
        }
        let lineWidth = line.size(withAttributes: [NSAttributedString.Key.font: font]).width
        return lineWidth + EditorTextView.scrollIndicatorWidth
    }
    
}
