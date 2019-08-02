import UIKit

struct HTMLSyntaxHighlighter: SyntaxHighlighterDelegate {
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        let fullRange = NSRange(location: 0, length: (text as NSString).length)
        let openTags = ["<p", "<h1", "<body", "<a", "<script", "<iframe", "<form", "<input", "<br"]
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
        let attributes = ["href", "src", "method", "action", "type", "name", "value", "style", "id", "onclick"]
        let attributeRegex = try! NSRegularExpression(pattern: attributes.joined(separator: "|"))
        let attributeMatches = attributeRegex.matches(in: text, range: fullRange)
        for attributeMatch in attributeMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.attributeColor, range: attributeMatch.range)
        }
        let tagRegex = try! NSRegularExpression(pattern: (openTags.map { $0 + ".*>"}).joined(separator: "|")
            , options: .dotMatchesLineSeparators)
        let tagMatches = tagRegex.matches(in: text, range: fullRange)
        for tagMatch in tagMatches {
            let valueRegex = try! NSRegularExpression(pattern: "=[^ >]+", options: .dotMatchesLineSeparators)
            let valueMatches = valueRegex.matches(in: text, range: tagMatch.range)
            for valueMatch in valueMatches {
                let gtRegex = try! NSRegularExpression(pattern: "&gt;")
                let gtMathces = gtRegex.matches(in: text, range: valueMatch.range)
                if gtMathces.isEmpty {
                    mutableAttributedString.addAttribute(.foregroundColor, value: PHP.valueColor, range: NSRange(location: valueMatch.range.location + 1, length: valueMatch.range.length - 1))
                } else {
                    let gtMatch = gtMathces.first!
                    mutableAttributedString.addAttribute(.foregroundColor, value: PHP.valueColor, range: NSRange(location: valueMatch.range.location + 1, length: gtMatch.range.location - valueMatch.range.location + 1))
                }
            }
        }
        let escapeRegex = try! NSRegularExpression(pattern: "&[a-zA-Z0-9]+;")
        let escapeMathces = escapeRegex.matches(in: text, range: fullRange)
        for escapeMatch in escapeMathces {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.escapeColor, range: escapeMatch.range)
        }
        /*******************************/
        // "で囲ってある文字列の中にスペースがある場合、うまくシンタックスハイライトされないため無理やり
        let stringRegex = try! NSRegularExpression(pattern: "\".*?\"|'.*?'", options: .dotMatchesLineSeparators)
        let stringMatches = stringRegex.matches(in: text, range: fullRange)
        for stringMatch in stringMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.valueColor, range: stringMatch.range)
        }
        /*******************************/
        let commentRegex = try! NSRegularExpression(pattern: "<!--.*?-->", options: .dotMatchesLineSeparators)
        let commentMatches = commentRegex.matches(in: text, range: fullRange)
        for commentMatch in commentMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.commentColor, range: commentMatch.range)
        }
        let commentRegex2 = try! NSRegularExpression(pattern: "(?!.*-->)<!--.*\\z", options: .dotMatchesLineSeparators)
        let commentMatches2 = commentRegex2.matches(in: text, range: fullRange)
        for commentMatch in commentMatches2 {
            /*******************************************/
            // ダブルクォーテーションの中にシングルクォーテーションが入っている場合を考慮していないため多少手抜き
            let singleQuotesCount = text[0..<commentMatch.range.location].filter { $0 == "'"}.count
            guard singleQuotesCount.isMultiple(of: 2) else {
                continue
            }
            let doubleQuotesCount = text[0..<commentMatch.range.location].filter { $0 == "\"" }.count
            guard doubleQuotesCount.isMultiple(of: 2) else {
                continue
            }
            /*******************************************/
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.commentColor, range: commentMatch.range)
        }
        return mutableAttributedString
    }
    
}
