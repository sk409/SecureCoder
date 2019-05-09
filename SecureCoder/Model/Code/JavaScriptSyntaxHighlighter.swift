//import Foundation
//import UIKit
//
//struct JavaScriptSyntaxHighlighter: CodeSyntaxHighlighter {
//    
//    private(set) var defaultColor: UIColor
//    private(set) var font: UIFont
//    
//    init(defaultColor: UIColor, font: UIFont) {
//        self.defaultColor = defaultColor
//        self.font = font
//    }
//    
//    func syntaxHighlight(text: String, insertedLocation: Int, replacedCount: Int) -> NSMutableAttributedString {
//        return NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: defaultColor, NSAttributedString.Key.font: font])
//    }
//    
//}
