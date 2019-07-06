import UIKit

struct JavaScriptSyntaxHighlighter: SyntaxHighlighterDelegate {
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString, tintColor: UIColor, font: UIFont, lineSpacing: CGFloat?) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        return NSMutableAttributedString(string: text)
    }
    
}
