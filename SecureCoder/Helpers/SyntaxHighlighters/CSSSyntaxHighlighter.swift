import UIKit

struct CSSSyntaxHighlighter: SyntaxHighlighterDelegate {
    
    func syntaxhighlight(_ mutableAttributedString: NSMutableAttributedString, range: NSRange) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        guard let commentRegex = try? NSRegularExpression(pattern: "/\\*.*\\*/", options: NSRegularExpression.Options()) else {
            return NSMutableAttributedString()
        }
        let commentMatches = commentRegex.matches(in: text, options: NSRegularExpression.MatchingOptions(), range: range)
        commentMatches.forEach { mutableAttributedString.addAttributes([.foregroundColor: UIColor.forestGreen], range: $0.range)}
        guard let selectorRegex = try? NSRegularExpression(pattern: ".*\\{") else {
            return NSMutableAttributedString()
        }
        let selectorMatches = selectorRegex.matches(in: text, range: range)
        selectorMatches.forEach {mutableAttributedString.addAttributes([.foregroundColor: UIColor.turquoiseBlue], range: NSRange(location: $0.range.location, length: $0.range.length - 1)) }
        guard let propertyRegex = try? NSRegularExpression(pattern: ".*:") else {
            return NSMutableAttributedString()
        }
        let propertyMatches = propertyRegex.matches(in: text, range: range)
        propertyMatches.forEach {mutableAttributedString.addAttributes([.foregroundColor: UIColor.cobaltBlue], range: NSRange(location: $0.range.location, length: $0.range.length - 1)) }
        guard let valueRegex = try? NSRegularExpression(pattern: ":.*;") else {
            return NSMutableAttributedString()
        }
        let valueMatches = valueRegex.matches(in: text, range: range)
        valueMatches.forEach {mutableAttributedString.addAttributes([.foregroundColor: UIColor.mintGreen], range: NSRange(location: $0.range.location + 1, length: $0.range.length - 2)) }
        return mutableAttributedString
    }
    
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        let fullRange = NSRange(location: 0, length: (text as NSString).length)
        return syntaxhighlight(mutableAttributedString, range: fullRange)
    }
    
}
