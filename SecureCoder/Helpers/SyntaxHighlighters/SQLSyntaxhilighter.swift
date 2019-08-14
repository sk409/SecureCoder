import Foundation

struct SQLSyntaxhighlighter: SyntaxHighlighterDelegate {
    
    func syntaxhighlight(_ mutableAttributedString: NSMutableAttributedString, range: NSRange) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        let keywords = ["select", "from", "where", "oder by", "desc", "asc", "delete", "union", "and"]
        let keywordRegex = try! NSRegularExpression(pattern: keywords.joined(separator: "|"), options: .caseInsensitive)
        let keywordMatches = keywordRegex.matches(in: text, range: range)
        for keywordMatch in keywordMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: SQL.keywordColor, range: keywordMatch.range)
        }
//        let stringRegex = try! NSRegularExpression(pattern: "'.*?'")
//        let stringMatches = stringRegex.matches(in: text, range: range)
//        for stringMatch in stringMatches {
//            mutableAttributedString.addAttribute(.foregroundColor, value: SQL.stringColor, range: stringMatch.range)
//        }
//        let commentRegex = try! NSRegularExpression(pattern: "--.*$", options: .anchorsMatchLines)
//        let commentMatches = commentRegex.matches(in: text, range: range)
//        for commentMatche in commentMatches {
//            mutableAttributedString.addAttribute(.foregroundColor, value: SQL.commentColor, range: commentMatche.range)
//        }
        return mutableAttributedString
    }
    
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        let fullRange = NSRange(location: 0, length: (text as NSString).length)
        return syntaxhighlight(mutableAttributedString, range: fullRange)
    }
    
}
