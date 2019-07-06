import UIKit

struct CSSSyntaxHighlighter: SyntaxHighlighterDelegate {
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString, tintColor: UIColor, font: UIFont, lineSpacing: CGFloat?) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        guard let commentRegex = try? NSRegularExpression(pattern: "/\\*.*\\*/", options: NSRegularExpression.Options()) else {
            return NSMutableAttributedString()
        }
        let commentMatches = commentRegex.matches(in: text, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: (text as NSString).length))
        commentMatches.forEach { mutableAttributedString.addAttributes([.font: font, .foregroundColor: UIColor.forestGreen], range: $0.range)}
        guard let selectorRegex = try? NSRegularExpression(pattern: ".*\\{") else {
            return NSMutableAttributedString()
        }
        let selectorMatches = selectorRegex.matches(in: text, range: NSRange(location: 0, length: (text as NSString).length))
        selectorMatches.forEach {mutableAttributedString.addAttributes([.font: font, .foregroundColor: UIColor.turquoiseBlue], range: NSRange(location: $0.range.location, length: $0.range.length - 1)) }
        guard let propertyRegex = try? NSRegularExpression(pattern: ".*:") else {
            return NSMutableAttributedString()
        }
        let propertyMatches = propertyRegex.matches(in: text, range: NSRange(location: 0, length: (text as NSString).length))
        propertyMatches.forEach {mutableAttributedString.addAttributes([.font: font, .foregroundColor: UIColor.cobaltBlue], range: NSRange(location: $0.range.location, length: $0.range.length - 1)) }
        guard let valueRegex = try? NSRegularExpression(pattern: ":.*;") else {
            return NSMutableAttributedString()
        }
        let valueMatches = valueRegex.matches(in: text, range: NSRange(location: 0, length: (text as NSString).length))
        valueMatches.forEach {mutableAttributedString.addAttributes([.font: font, .foregroundColor: UIColor.mintGreen], range: NSRange(location: $0.range.location + 1, length: $0.range.length - 2)) }
        return mutableAttributedString
    }
    
}
