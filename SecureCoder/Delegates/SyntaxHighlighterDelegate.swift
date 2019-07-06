import UIKit

protocol SyntaxHighlighterDelegate {
    
    func syntaxHighlight(_ text: String, tintColor: UIColor, font: UIFont, lineSpacing: CGFloat?) -> NSMutableAttributedString
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString, tintColor: UIColor, font: UIFont, lineSpacing: CGFloat?) -> NSMutableAttributedString
    
}

extension SyntaxHighlighterDelegate {
    
    func syntaxHighlight(_ text: String, tintColor: UIColor, font: UIFont, lineSpacing: CGFloat?) -> NSMutableAttributedString {
        var attributes = [NSAttributedString.Key.foregroundColor: tintColor, .font: font]
        if let lineSpacing = lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            attributes[.paragraphStyle] = paragraphStyle
        }
        let mutableAttributedString = NSMutableAttributedString(string: text, attributes: attributes)
        return syntaxHighlight(mutableAttributedString, tintColor: tintColor, font: font, lineSpacing: lineSpacing)
    }
    
}
