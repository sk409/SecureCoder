import Foundation
import UIKit

struct PHPSyntaxHighlighter: SyntaxHighlighterDelegate {
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString, tintColor: UIColor, font: UIFont, lineSpacing: CGFloat?) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        if let phpRegex = try? NSRegularExpression(pattern: "<\\?php.*?\\?>", options: .dotMatchesLineSeparators) {
            let matches = phpRegex.matches(in: text, range: NSRange(location: 0, length: (text as NSString).length))
            for match in matches {
                mutableAttributedString.addAttributes([.foregroundColor: PHP.tagColor], range: NSRange(location: match.range.location, length: 5))
                mutableAttributedString.addAttributes([.foregroundColor: PHP.tagColor], range: NSRange(location: match.range.location + match.range.length - 2, length: 2))
                let a = PHP.reservedWords.flatMap { "((/\\*.*?\\*/)| )\($0)((/\\*.*?\\*/)| )" + "|" }
                var reservedWordPattern = String(a)
                reservedWordPattern.removeLast()
                reservedWordPattern = "(" + reservedWordPattern
                reservedWordPattern += ")"
                if let reservedWordRegex = try? NSRegularExpression(pattern: reservedWordPattern) {
                    let reservedWordMatches = reservedWordRegex.matches(in: text, range: match.range)
                    for reservedWordMatch in reservedWordMatches {
                        mutableAttributedString.addAttributes([.foregroundColor: PHP.reservedWordColor], range: reservedWordMatch.range)
                    }
                }
                if let stringRegex = try? NSRegularExpression(pattern: "\".*\"") {
                    let stringMatches = stringRegex.matches(in: text, range: match.range)
                    for stringMatch in stringMatches {
                        mutableAttributedString.addAttributes([.foregroundColor: PHP.stringColor], range: stringMatch.range)
                    }
                }
                if let functionRegex = try? NSRegularExpression(pattern: "((/\\*.*?\\*/)| )[a-zA-Z_][a-zA-Z0-9_]*\\(\\)") {
                    let functionMatches = functionRegex.matches(in: text, range: match.range)
                    for functionMatch in functionMatches {
                        //print((text as NSString).substring(with: functionMatch.range))
                        mutableAttributedString.addAttributes([.foregroundColor: PHP.functionColor], range: NSRange(location: functionMatch.range.location, length: functionMatch.range.length - 2))
                    }
                }
                if let variableRegex = try? NSRegularExpression(pattern: "((/\\*.*?\\*/)| )\\$[a-zA-Z_][a-zA-Z0-9_]*((/\\*.*?\\*/)| )") {
                    let variableMatches = variableRegex.matches(in: text, range: match.range)
                    for variableMatch in variableMatches {
                        mutableAttributedString.addAttributes([.foregroundColor: PHP.variableColor], range: variableMatch.range)
                    }
                }
                //                if let classRegex = try? NSRegularExpression(pattern: "(new +[a-zA-Z_][a-zA-Z0-9_]*\\(\\)") {
                //                    let classMatches = classRegex.matches(in: text, range: match.range)
                //                    for classMatch in classMatches {
                //                        print((text as NSString).substring(with: classMatch.range))
                //                        attributedString.addAttributes([.foregroundColor: PHP.classColor], range: classMatch.range)
                //                    }
                //                }
            }
        }
        return mutableAttributedString
    }
    
    
    func syntaxHighlight(_ text: String, tintColor: UIColor, font: UIFont, lineSpacing: CGFloat?) -> NSMutableAttributedString {
        var htmlSyntaxHighlighter = SyntaxHighlighter(tintColor: tintColor, font: font, lineSpacing: lineSpacing)
        htmlSyntaxHighlighter.programingLanguage = .html
        let mutableAttributedString = htmlSyntaxHighlighter.syntaxHighlight(text)
        return syntaxHighlight(mutableAttributedString, tintColor: tintColor, font: font, lineSpacing: lineSpacing)
    }
    
}
