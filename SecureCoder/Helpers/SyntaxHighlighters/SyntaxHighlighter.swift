import Foundation
import UIKit

struct SyntaxHighlighter {
    
    var tintColor: UIColor?
    var font: UIFont?
    var lineSpacing: CGFloat?
    
    var programingLanguage: ProgramingLanguage? {
        didSet {
            guard let programingLanguage = programingLanguage else {
                return
            }
            switch programingLanguage {
            case .html:
                delegate = HTMLSyntaxHighlighter()
            case .css:
                delegate = CSSSyntaxHighlighter()
            case .javaScript:
                delegate = JavaScriptSyntaxHighlighter()
            case .php:
                delegate = PHPSyntaxHighlighter()
            }
        }
    }
    
    var delegate: SyntaxHighlighterDelegate?
    
    init() {
        
    }
    
    init(tintColor: UIColor, font: UIFont) {
        self.tintColor = tintColor
        self.font = font
    }
    
    init(tintColor: UIColor, font: UIFont, lineSpacing: CGFloat?) {
        self.tintColor = tintColor
        self.font = font
        self.lineSpacing = lineSpacing
    }
    
    func syntaxHighlight(_ text: String) -> NSMutableAttributedString {
//        var attributes = [NSMutableAttributedString.Key.foregroundColor: tintColor, .font: font]
//        if let lineSpacing = lineSpacing {
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = lineSpacing
//            attributes[.paragraphStyle] = paragraphStyle
//        }
//        return syntaxHighlight(NSMutableAttributedString(string: text, attributes: attributes))
//        guard let tintColor = tintColor, let font = font else {
//            return NSMutableAttributedString()
//        }
//        return delegate?.syntaxHighlight(text, tintColor: tintColor, font: font, lineSpacing: lineSpacing) ?? NSMutableAttributedString(string: "")
        var attributes = [NSMutableAttributedString.Key.foregroundColor: tintColor, .font: font]
        if let lineSpacing = lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            attributes[.paragraphStyle] = paragraphStyle
        }
        return delegate?.syntaxHighlight(NSMutableAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])) ?? NSMutableAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
    }
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        guard let delegate = delegate else {
            return NSMutableAttributedString()
        }
        return delegate.syntaxHighlight(mutableAttributedString)
    }
    
}
