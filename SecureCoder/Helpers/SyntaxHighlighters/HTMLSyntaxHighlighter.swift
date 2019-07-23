import UIKit

struct HTMLSyntaxHighlighter: SyntaxHighlighterDelegate {
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        let fullRange = NSRange(location: 0, length: (text as NSString).length)
        let openTags = ["<p", "<h1", "<body", "<a", "<script", "<iframe"]
        let openTagRegex = try! NSRegularExpression(pattern: openTags.joined(separator: "|"))
        let openTagMatches = openTagRegex.matches(in: text, range: fullRange)
        for openTagMatch in openTagMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.tagColor, range: NSRange(location: openTagMatch.range.location + 1, length: openTagMatch.range.length - 1))
        }
        let closeTags = openTags.map { String($0[0]) + "/" + $0[1...] }
        let closeTagRegex = try! NSRegularExpression(pattern: closeTags.joined(separator: "|"))
        let closeTagMatches = closeTagRegex.matches(in: text, range: fullRange)
        for closeTagMatch in closeTagMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.tagColor, range: NSRange(location: closeTagMatch.range.location + 1, length: closeTagMatch.range.length - 1))
        }
        let attributes = ["href", "src"]
        let attributeRegex = try! NSRegularExpression(pattern: attributes.joined(separator: "|"))
        let attributeMatches = attributeRegex.matches(in: text, range: fullRange)
        for attributeMatch in attributeMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.attributeColor, range: attributeMatch.range)
        }
        let valueRegex = try! NSRegularExpression(pattern: "=[^ >)]+")
        let valueMatches = valueRegex.matches(in: text, range: fullRange)
        for valueMatch in valueMatches {
            //let back = text[valueMatch.range.location + valueMatch.range.length - 1] == ">" ? 1 : 0
            let escapeRegex = try! NSRegularExpression(pattern: "&[a-zA-Z0-9]+;")
            let escapeMathces = escapeRegex.matches(in: text, range: valueMatch.range)
            if escapeMathces.isEmpty {
                mutableAttributedString.addAttribute(.foregroundColor, value: PHP.valueColor, range: NSRange(location: valueMatch.range.location + 1, length: valueMatch.range.length - 1))
            } else {
                let escapeMatch = escapeMathces.first!
                mutableAttributedString.addAttribute(.foregroundColor, value: PHP.valueColor, range: NSRange(location: valueMatch.range.location + 1, length: escapeMatch.range.location - valueMatch.range.location + 1))
            }
        }
        let escapeRegex = try! NSRegularExpression(pattern: "&[a-zA-Z0-9]+;")
        let escapeMathces = escapeRegex.matches(in: text, range: fullRange)
        for escapeMatch in escapeMathces {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.escapeColor, range: escapeMatch.range)
        }
        let stringRegex = try! NSRegularExpression(pattern: "\".*?\"")
        let stringMatches = stringRegex.matches(in: text, range: fullRange)
        for stringMatch in stringMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.valueColor, range: stringMatch.range)
        }
        return mutableAttributedString
    }
    
}
