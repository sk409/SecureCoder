import UIKit

struct JavaScriptSyntaxHighlighter {
    
    private var tintColor: UIColor?
    private var font: UIFont?
    
    init(tintColor: UIColor, font: UIFont) {
        self.tintColor = tintColor
        self.font = font
    }
    
    func syntaxHighlight(_ text: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text)
    }
    
}
