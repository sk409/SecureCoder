import UIKit

struct HTMLSyntaxHighlighter: SyntaxHighlighterDelegate {
    
    func syntaxhighlight(_ mutableAttributedString: NSMutableAttributedString, range: NSRange) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        let tags = ["p", "h1", "body", "a", "script", "iframe", "form", "input", "br", "table", "tr", "th", "td", "html", "head", "meta", "!DOCTYPE html"]
        let openTagRegex = try! NSRegularExpression(pattern: tags.map { "<" + $0 }.joined(separator: "|") + "|" + tags.map{"&lt;" + $0}.joined(separator: "|"))
        let openTagMatches = openTagRegex.matches(in: text, range: range)
        for openTagMatch in openTagMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.tagColor, range: NSRange(location: openTagMatch.range.location + 1, length: openTagMatch.range.length - 1))
        }
        //let closeTags = tags.map { "</" + $0 } + tags
        let closeTagRegex = try! NSRegularExpression(pattern: tags.map{"</" + $0}.joined(separator: "|") + "|" + tags.map{"&lt;/" + $0}.joined(separator: "|"))
        let closeTagMatches = closeTagRegex.matches(in: text, range: range)
        for closeTagMatch in closeTagMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.tagColor, range: NSRange(location: closeTagMatch.range.location + 1, length: closeTagMatch.range.length - 1))
        }
        let attributes = ["href", "src", "method", "action", "type", "name", "value", "style", "id", "onclick", "onload", "charset"]
        let attributeRegex = try! NSRegularExpression(pattern: attributes.joined(separator: "|"))
        let attributeMatches = attributeRegex.matches(in: text, range: range)
        for attributeMatch in attributeMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.attributeColor, range: attributeMatch.range)
        }
        let a = (tags.map { "<" + $0 + ".*?>"}).joined(separator: "|") + "|"
        let b = (tags.map { "&lt;" + $0 + ".*?&gt;"}).joined(separator: "|")
        let tagPattern = a + b
        let tagRegex = try! NSRegularExpression(pattern: tagPattern, options: .dotMatchesLineSeparators)
        let tagMatches = tagRegex.matches(in: text, range: range)
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
        let escapeRegex = try! NSRegularExpression(pattern: "&[a-zA-Z0-9#]+;")
        let escapeMathces = escapeRegex.matches(in: text, range: range)
        for escapeMatch in escapeMathces {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.escapeColor, range: escapeMatch.range)
        }
        /*******************************/
        // "で囲ってある文字列の中にスペースがある場合、うまくシンタックスハイライトされないため無理やり
        let stringRegex = try! NSRegularExpression(pattern: "\".*?\"|'.*?'", options: .dotMatchesLineSeparators)
        let stringMatches = stringRegex.matches(in: text, range: range)
        for stringMatch in stringMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.valueColor, range: stringMatch.range)
        }
        /*******************************/
        let commentRegex = try! NSRegularExpression(pattern: "<!--.*?-->", options: .dotMatchesLineSeparators)
        let commentMatches = commentRegex.matches(in: text, range: range)
        for commentMatch in commentMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.commentColor, range: commentMatch.range)
        }
        let commentRegex2 = try! NSRegularExpression(pattern: "(?!.*-->)<!--.*\\z", options: .dotMatchesLineSeparators)
        let commentMatches2 = commentRegex2.matches(in: text, range: range)
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
    
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        let fullRange = NSRange(location: 0, length: (text as NSString).length)
        return syntaxhighlight(mutableAttributedString, range: fullRange)
    }
    
}
