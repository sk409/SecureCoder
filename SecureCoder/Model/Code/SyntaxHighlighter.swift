import Foundation
import UIKit

struct SyntaxHighlighter {
    
    static func decorate(_ text: String?, tintColor: UIColor, font: UIFont, language: ProgramingLanguage) -> NSMutableAttributedString {
        guard let text = text else {
            return NSMutableAttributedString(string: "")
        }
        switch language {
        case .html:
            return HTMLSyntaxHighlighter(tintColor: tintColor, font: font).syntaxHighlight(text)
        case .css:
            return CSSSyntaxHighlighter(tintColor: tintColor, font: font).syntaxHighlight(text)
        case .javaScript:
            return JavaScriptSyntaxHighlighter(tintColor: tintColor, font: font).syntaxHighlight(text)
        case .php:
            return PHPSyntaxHighlighter(tintColor: tintColor, font: font).syntaxHighlight(text)
        }
    }
    
}
