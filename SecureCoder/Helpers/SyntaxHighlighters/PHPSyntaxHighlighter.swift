import Foundation
import UIKit

struct PHPSyntaxHighlighter: SyntaxHighlighterDelegate {
    
    var force = false
    
    func syntaxhighlight(_ mutableAttributedString: NSMutableAttributedString, range: NSRange) -> NSMutableAttributedString {
        var htmlSyntaxHighlighter = SyntaxHighlighter()
        htmlSyntaxHighlighter.programingLanguage = .html
        let mutableAttributedString = htmlSyntaxHighlighter.syntaxHighlight(mutableAttributedString)
        let text = mutableAttributedString.string
        let phpRegex = try! NSRegularExpression(pattern: "<\\?php.*?\\?>", options: .dotMatchesLineSeparators)
        let phpMatches = phpRegex.matches(in: text, range: range)
        for phpMatch in phpMatches {
            /************************************************/
            // TODO: UIColor.whiteを修正する必要があるかも
            mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.white, range: phpMatch.range)
            /************************************************/
            mutableAttributedString.addAttributes([.foregroundColor: PHP.tagColor], range: NSRange(location: phpMatch.range.location, length: 5))
            mutableAttributedString.addAttributes([.foregroundColor: PHP.tagColor], range: NSRange(location: phpMatch.range.location + phpMatch.range.length - 2, length: 2))
        }
        if force {
            execute(mutableAttributedString, range: range)
        } else {
            for phpMatch in phpMatches {
                execute(mutableAttributedString, range: phpMatch.range)
            }
        }
        return mutableAttributedString
    }
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        let range = NSRange(location: 0, length: (text as NSString).length)
        return syntaxhighlight(mutableAttributedString, range: range)
    }
    
    private func execute(_ mutableAttributedString: NSMutableAttributedString, range: NSRange) {
        let text = mutableAttributedString.string
        let reservedWordRegex = try! NSRegularExpression(pattern: PHP.reservedWords.map({ "[^a-zA-Z0-9_]" + $0 + "[^a-zA-Z0-9_]"}).joined(separator: "|"))
        let reservedWordMatches = reservedWordRegex.matches(in: text, range: range)
        for reservedWordMatch in reservedWordMatches {
            mutableAttributedString.addAttributes([.foregroundColor: PHP.reservedWordColor], range: NSRange(location: reservedWordMatch.range.location + 1, length: reservedWordMatch.range.length - 2))
        }
        let reservedWordRegex2 = try! NSRegularExpression(pattern: PHP.reservedWords.map({"^" + $0 + "[^a-zA-Z0-9_]"}).joined(separator: "|"), options: .anchorsMatchLines)
        let reservedWordMatches2 = reservedWordRegex2.matches(in: text, range: range)
        for reservedWordMatch in reservedWordMatches2 {
            mutableAttributedString.addAttributes([.foregroundColor: PHP.reservedWordColor], range: NSRange(location: reservedWordMatch.range.location, length: reservedWordMatch.range.length - 1))
        }
        let reservedWordRegex3 = try! NSRegularExpression(pattern: PHP.reservedWords.map({"[^a-zA-Z0-9_]" + $0 + "$"}).joined(separator: "|"), options: .anchorsMatchLines)
        let reservedWordMatches3 = reservedWordRegex3.matches(in: text, range: range)
        for reservedWordMatch in reservedWordMatches3 {
            mutableAttributedString.addAttributes([.foregroundColor: PHP.reservedWordColor], range: NSRange(location: reservedWordMatch.range.location + 1, length: reservedWordMatch.range.length - 1))
        }
        let functionRegex = try! NSRegularExpression(pattern: "[a-zA-Z0-9_]+\\(")
        let functionMatches = functionRegex.matches(in: text, range: range)
        for functionMatch in functionMatches {
            mutableAttributedString.addAttributes([.foregroundColor: PHP.functionColor], range: NSRange(location: functionMatch.range.location, length: functionMatch.range.length - 1))
        }
        let classRegex = try! NSRegularExpression(pattern: "new [a-zA-Z0-9_]+\\(")
        let classMatches = classRegex.matches(in: text, range: range)
        for classMatch in classMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.classColor, range: NSRange(location: classMatch.range.location + 4, length: classMatch.range.length - 5))
        }
        let classRegex2 = try! NSRegularExpression(pattern: "[a-zA-Z0-9_]+::")
        let classMatches2 = classRegex2.matches(in: text, range: range)
        for classMatch2 in classMatches2 {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.classColor, range: NSRange(location: classMatch2.range.location, length: classMatch2.range.length - 2))
        }
        let stringRegex = try! NSRegularExpression(pattern: "\".*\"")
        let stringMatches = stringRegex.matches(in: text, range: range)
        for stringMatch in stringMatches {
            mutableAttributedString.addAttributes([.foregroundColor: PHP.valueColor], range: stringMatch.range)
//            let string = (text as NSString).substring(with: stringMatch.range)
            _ = SQLSyntaxhighlighter().syntaxhighlight(mutableAttributedString, range: NSRange(location: stringMatch.range.location + 1, length: stringMatch.range.length - 2))
//            for sqlCrud in SQL.crud {
//                let count = sqlCrud.count
//                if string.count < (count + 1) {
//                    continue
//                }
//                let prefix = string[1...count]
//                if prefix.lowercased() == sqlCrud.lowercased() {
//                    _ = SQLSyntaxhighlighter().syntaxhighlight(mutableAttributedString, range: NSRange(location: stringMatch.range.location + 1, length: stringMatch.range.length - 2))
//                }
//            }
        }
        let variableRegex = try! NSRegularExpression(pattern: "\\$[a-zA-Z0-9_]+")
        let variableMatches = variableRegex.matches(in: text, range: range)
        for variableMatch in variableMatches {
            mutableAttributedString.addAttributes([.foregroundColor: PHP.variableColor], range: variableMatch.range)
        }
        let singleLineCommentRegex = try! NSRegularExpression(pattern: "[^:]//.*$", options: .anchorsMatchLines)
        let singleLineCommentMatches = singleLineCommentRegex.matches(in: text, range: range)
        for singleLineCommentMatch in singleLineCommentMatches {
            let prefix = text[..<singleLineCommentMatch.range.location]
            let doubleQuotationCount = prefix.filter { $0 == "\"" }.count
            guard doubleQuotationCount.isMultiple(of: 2) else {
                continue
            }
            let singleQuotationCount = prefix.filter { $0 == "'" }.count
            guard singleQuotationCount.isMultiple(of: 2) else {
                continue
            }
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.commentColor, range: singleLineCommentMatch.range)
        }
    }
    
}
