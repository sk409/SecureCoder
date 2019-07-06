import UIKit

struct HTMLSyntaxHighlighter: SyntaxHighlighterDelegate {
    
    func syntaxHighlight(_ mutableAttributedString: NSMutableAttributedString, tintColor: UIColor, font: UIFont, lineSpacing: CGFloat?) -> NSMutableAttributedString {
        let text = mutableAttributedString.string
        var index = 0
        var isComment = false
        var isTag = false
        var isInTag = false
        var isInString = false
        let addColorAttribute: (Int, UIColor) -> Void = { index, color in
            let range = NSRange(location: index, length: 1)
            mutableAttributedString.addAttribute(.foregroundColor, value: color, range: range)
        }
        while index <= (text.count - 1) {
            let character = text[index]
            if character != ">" && isComment {
                addColorAttribute(index, PHP.commentColor)
            } else {
                if character == "<" && !isInString {
                    if index <= (text.count - 4) && text[index + 1] == "!" && text[index + 2] == "-" && text[index + 3] == "-" {
                        addColorAttribute(index, PHP.commentColor)
                        isComment = true
                    } else {
                        addColorAttribute(index, tintColor)
                        isTag = true
                    }
                } else if character == ">" && !isInString {
                    let stringCount = mutableAttributedString.string.count
                    if 2 <= stringCount && mutableAttributedString.string[stringCount - 2] == "-" && mutableAttributedString.string[stringCount - 1] == "-" {
                        addColorAttribute(index, PHP.commentColor)
                        isComment = false
                    } else {
                        addColorAttribute(index, tintColor)
                        isTag = false
                        isInTag = false
                    }
                } else if character == "\"" {
                    addColorAttribute(index, PHP.stringColor)
                    isInString = !isInString
                } else {
                    if isInString {
                        addColorAttribute(index, PHP.stringColor)
                    }
                    else if isTag {
                        if character == " " {
                            isTag = false
                            isInTag = true
                        } else {
                            addColorAttribute(index, PHP.tagColor)
                        }
                    } else if isInTag {
                        addColorAttribute(index, PHP.attributeColor)
                    }
                }
            }
            index += 1
        }
        return mutableAttributedString
    }
    
}
