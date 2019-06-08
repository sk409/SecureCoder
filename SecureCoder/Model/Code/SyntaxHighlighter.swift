import Foundation
import UIKit

struct SyntaxHighlighter {
    
    static func decorate(_ text: String?, defaultColor: UIColor, font: UIFont, language: ProgramingLanguage) -> NSMutableAttributedString {
        guard let text = text else {
            return NSMutableAttributedString(string: "")
        }
        switch language {
        case .html:
            return HTMLSyntaxHighlighter(defaultColor: defaultColor, font: font).syntaxHighlight(text)
//        case .css:
//            return HTMLSyntaxHighlighter(defaultColor: defaultColor, font: font).syntaxHighlight(text)
        case .javaScript:
            return PHPSyntaxHighlighter(defaultColor: defaultColor, font: font).syntaxHighlight(text)
        case .php:
            return PHPSyntaxHighlighter(defaultColor: defaultColor, font: font).syntaxHighlight(text)
        }
    }
    
}
