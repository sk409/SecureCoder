import UIKit

struct JavaScriptSyntaxHighlighter: SyntaxHighlighterDelegate {
    
    func syntaxhighlight(_ mutableAttributedString: NSMutableAttributedString, range: NSRange) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        let globalVariables = ["document"]
        let globalVariableRegex = try! NSRegularExpression(pattern: globalVariables.joined(separator: "|"))
        let globalVariableMatches = globalVariableRegex.matches(in: text, range: range)
        for globalVariableMatch in globalVariableMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: JavaScript.variableColor, range: globalVariableMatch.range)
        }
        let dotChainRegex = try! NSRegularExpression(pattern: "\\.[a-zA-Z0-9_]+")
        let dotChainMatches = dotChainRegex.matches(in: text, range: range)
        for dotChainMatch in dotChainMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: JavaScript.variableColor, range: NSRange(location: dotChainMatch.range.location + 1, length: dotChainMatch.range.length - 1))
        }
        let functionRegex = try! NSRegularExpression(pattern: "\\.?[a-zA-Z0-9_]+\\(")
        let functionMatches = functionRegex.matches(in: text, range: range)
        for functionMatch in functionMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: JavaScript.functionColor, range: NSRange(location: functionMatch.range.location + 1, length: functionMatch.range.length - 2))
        }
        let reservedWords = ["var"]
        let reservedWordRegex = try! NSRegularExpression(pattern: reservedWords.joined(separator: "|"))
        let reservedWordMatches = reservedWordRegex.matches(in: text, range: range)
        for reservedWordMatch in reservedWordMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: JavaScript.reservedWordColor, range: reservedWordMatch.range)
        }
        let stringRegex = try! NSRegularExpression(pattern: "\".*?\"")
        let stringMatches = stringRegex.matches(in: text, range: range)
        for stringMatch in stringMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: JavaScript.stringColor, range: stringMatch.range)
        }
        return mutableAttributedString
    }
    
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        let fullRange = NSRange(location: 0, length: (text as NSString).length)
        return syntaxhighlight(mutableAttributedString, range: fullRange)
    }
    
}
