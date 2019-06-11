import UIKit

struct CSSSyntaxHighlighter {
    
    let tintColor: UIColor
    let font: UIFont
    
    func syntaxHighlight(_ text: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: font, .foregroundColor: tintColor])
        guard let selectorRegex = try? NSRegularExpression(pattern: ".*\\{") else {
            return NSMutableAttributedString()
        }
        let selectorMatches = selectorRegex.matches(in: text, range: NSRange(location: 0, length: (text as NSString).length))
        selectorMatches.forEach {attributedString.addAttributes([.font: font, .foregroundColor: UIColor.turquoiseBlue], range: NSRange(location: $0.range.location, length: $0.range.length - 1)) }
        guard let propertyRegex = try? NSRegularExpression(pattern: ".*:") else {
            return NSMutableAttributedString()
        }
        let propertyMatches = propertyRegex.matches(in: text, range: NSRange(location: 0, length: (text as NSString).length))
        propertyMatches.forEach {attributedString.addAttributes([.font: font, .foregroundColor: UIColor.cobaltBlue], range: NSRange(location: $0.range.location, length: $0.range.length - 1)) }
        guard let valueRegex = try? NSRegularExpression(pattern: ":.*;") else {
            return NSMutableAttributedString()
        }
        let valueMatches = valueRegex.matches(in: text, range: NSRange(location: 0, length: (text as NSString).length))
        valueMatches.forEach {attributedString.addAttributes([.font: font, .foregroundColor: UIColor.mintGreen], range: NSRange(location: $0.range.location + 1, length: $0.range.length - 2)) }
        guard let commentRegex = try? NSRegularExpression(pattern: "/\\*.*\\*/", options: NSRegularExpression.Options()) else {
            return NSMutableAttributedString()
        }
        let commentMatches = commentRegex.matches(in: text, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: (text as NSString).length))
        commentMatches.forEach { attributedString.addAttributes([.font: font, .foregroundColor: UIColor.forestGreen], range: $0.range)}
        return attributedString
    }
    
}
