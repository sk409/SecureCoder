import Foundation
import UIKit

struct PHPSyntaxHighlighter: SyntaxHighlighterDelegate {
    
    var force = false
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        let phpRegex = try! NSRegularExpression(pattern: "<\\?php.*?\\?>", options: .dotMatchesLineSeparators)
        let phpMatches = phpRegex.matches(in: text, range: NSRange(location: 0, length: (text as NSString).length))
        for phpMatch in phpMatches {
            mutableAttributedString.addAttributes([.foregroundColor: PHP.tagColor], range: NSRange(location: phpMatch.range.location, length: 5))
            mutableAttributedString.addAttributes([.foregroundColor: PHP.tagColor], range: NSRange(location: phpMatch.range.location + phpMatch.range.length - 2, length: 2))
        }
        if force {
            let fullRange = NSRange(location: 0, length: (text as NSString).length)
            execute(mutableAttributedString, range: fullRange)
        } else {
            for phpMatch in phpMatches {
                execute(mutableAttributedString, range: phpMatch.range)
            }
        }
        return mutableAttributedString
    }
    
    func syntaxHighlight(_ text: String, tintColor: UIColor, font: UIFont, lineSpacing: CGFloat?) -> NSMutableAttributedString {
        var htmlSyntaxHighlighter = SyntaxHighlighter(tintColor: tintColor, font: font, lineSpacing: lineSpacing)
        htmlSyntaxHighlighter.programingLanguage = .html
        let mutableAttributedString = htmlSyntaxHighlighter.syntaxHighlight(text)
        return syntaxHighlight(mutableAttributedString)
    }
    
    private func execute(_ mutableAttributedString: NSMutableAttributedString, range: NSRange) {
        let text = mutableAttributedString.string
        let reservedWordRegex = try! NSRegularExpression(pattern: PHP.reservedWords.joined(separator: "|"))
        let reservedWordMatches = reservedWordRegex.matches(in: text, range: range)
        for reservedWordMatch in reservedWordMatches {
            mutableAttributedString.addAttributes([.foregroundColor: PHP.reservedWordColor], range: reservedWordMatch.range)
        }
        let functionRegex = try! NSRegularExpression(pattern: "[a-zA-Z0-9_]+\\(")
        let functionMatches = functionRegex.matches(in: text, range: range)
        for functionMatch in functionMatches {
            mutableAttributedString.addAttributes([.foregroundColor: PHP.functionColor], range: NSRange(location: functionMatch.range.location, length: functionMatch.range.length - 1))
        }
        let variableRegex = try! NSRegularExpression(pattern: "\\$[a-zA-Z0-9_]+")
        let variableMatches = variableRegex.matches(in: text, range: range)
        for variableMatch in variableMatches {
            mutableAttributedString.addAttributes([.foregroundColor: PHP.variableColor], range: variableMatch.range)
        }
        let stringRegex = try! NSRegularExpression(pattern: "\".*\"")
        let stringMatches = stringRegex.matches(in: text, range: range)
        for stringMatch in stringMatches {
            mutableAttributedString.addAttributes([.foregroundColor: PHP.valueColor], range: stringMatch.range)
        }
        let singleLineCommentRegex = try! NSRegularExpression(pattern: "[^:]//.*$", options: .anchorsMatchLines)
        let singleLineCommentMatches = singleLineCommentRegex.matches(in: text, range: range)
        for singleLineCommentMatch in singleLineCommentMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: PHP.commentColor, range: singleLineCommentMatch.range)
        }
    }
    
}
