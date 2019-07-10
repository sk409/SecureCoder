import UIKit

struct JavaScriptSyntaxHighlighter: SyntaxHighlighterDelegate {
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        let fullRange = NSRange(location: 0, length: (text as NSString).length)
//        let variableRegex = try! NSRegularExpression(pattern: "var [a-zA-Z0-9_]+")
//        let variableMatches = variableRegex.matches(in: text, range: fullRange)
//        for variableMatch in variableMatches {
//            mutableAttributedString.addAttribute(.foregroundColor, value: JavaScript.variableColor, range: NSRange(location: variableMatch.range.location + 4, length: variableMatch.range.length - 4))
//        }
//        mutableAttributedString.addAttribute(.foregroundColor, value: JavaScript.variableColor, range: fullRange)
//        let dotChainRegex1 = try! NSRegularExpression(pattern: "[a-zA-Z0-9_]+\\.")
//        let dotChainMatches1 = dotChainRegex1.matches(in: text, range: fullRange)
//        for dotChainMatch in dotChainMatches1 {
//            mutableAttributedString.addAttribute(.foregroundColor, value: JavaScript.variableColor, range: NSRange(location: dotChainMatch.range.location, length: dotChainMatch.range.length - 1))
//        }
        let globalVariables = ["document"]
        let globalVariableRegex = try! NSRegularExpression(pattern: globalVariables.joined(separator: "|"))
        let globalVariableMatches = globalVariableRegex.matches(in: text, range: fullRange)
        for globalVariableMatch in globalVariableMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: JavaScript.variableColor, range: globalVariableMatch.range)
        }
        let dotChainRegex = try! NSRegularExpression(pattern: "\\.[a-zA-Z0-9_]+")
        let dotChainMatches = dotChainRegex.matches(in: text, range: fullRange)
        for dotChainMatch in dotChainMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: JavaScript.variableColor, range: NSRange(location: dotChainMatch.range.location + 1, length: dotChainMatch.range.length - 1))
        }
        let functionRegex = try! NSRegularExpression(pattern: "\\.?[a-zA-Z0-9_]+\\(")
        let functionMatches = functionRegex.matches(in: text, range: fullRange)
        for functionMatch in functionMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: JavaScript.functionColor, range: NSRange(location: functionMatch.range.location + 1, length: functionMatch.range.length - 2))
        }
        let reservedWords = ["var"]
        let reservedWordRegex = try! NSRegularExpression(pattern: reservedWords.joined(separator: "|"))
        let reservedWordMatches = reservedWordRegex.matches(in: text, range: fullRange)
        for reservedWordMatch in reservedWordMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: JavaScript.reservedWordColor, range: reservedWordMatch.range)
        }
        let numberRegex = try! NSRegularExpression(pattern: "[0-9]")
        let numberMatches = numberRegex.matches(in: text, range: fullRange)
        for numbermatch in numberMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: JavaScript.numberColor, range: numbermatch.range)
        }
//        let planeRegex = try! NSRegularExpression(pattern: "[.={}(),+\\-*/;:]")
//        let planeMatches = planeRegex.matches(in: text, range: fullRange)
//        for planeMatch in planeMatches {
//            mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.white, range: planeMatch.range)
//        }
        let stringRegex = try! NSRegularExpression(pattern: "\".*?\"")
        let stringMatches = stringRegex.matches(in: text, range: fullRange)
        for stringMatch in stringMatches {
            mutableAttributedString.addAttribute(.foregroundColor, value: JavaScript.stringColor, range: stringMatch.range)
        }
        return mutableAttributedString
    }
    
}
