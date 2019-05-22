import UIKit

struct HTMLSyntaxHighlighter: CodeSyntaxHighlighter {
    
    let defaultColor: UIColor
    
    let font: UIFont
    
    init(defaultColor: UIColor, font: UIFont) {
        self.defaultColor = defaultColor
        self.font = font
    }
    
    func syntaxHighlight(_ text: String) -> NSMutableAttributedString {
        let highlighted = NSMutableAttributedString()
        var index = 0
        var isComment = false
        var isTag = false
        var isInTag = false
        var isInString = false
        let appendCharacter: (Character, UIColor) -> Void = { character, color in
            highlighted.append(NSAttributedString(string: String(character), attributes: [.foregroundColor: color, .font: self.font]))
        }
        while index <= (text.count - 1) {
            let character = text[index]
            if character != ">" && isComment {
                appendCharacter(character, PHP.commentColor)
            } else {
                if character == "<" {
                    if index <= (text.count - 4) && text[index + 1] == "!" && text[index + 2] == "-" && text[index + 3] == "-" {
                        appendCharacter(character, PHP.commentColor)
                        isComment = true
                    } else {
                        appendCharacter(character, defaultColor)
                        isTag = true
                    }
                } else if character == ">" {
                    let stringCount = highlighted.string.count
                    if 2 <= stringCount && highlighted.string[stringCount - 2] == "-" && highlighted.string[stringCount - 1] == "-" {
                        appendCharacter(character, PHP.commentColor)
                        isComment = false
                    } else {
                        appendCharacter(character, defaultColor)
                        isInTag = false
                    }
                } else if character == "\"" {
                    appendCharacter(character, PHP.stringColor)
                    isInString = !isInString
                } else {
                    if isInString {
                        appendCharacter(character, PHP.stringColor)
                    }
                    else if isTag {
                        if character == " " {
                            isTag = false
                            isInTag = true
                            appendCharacter(character, defaultColor)
                        } else if character == "/" {
                            appendCharacter(character, defaultColor)
                        } else {
                            appendCharacter(character, PHP.tagColor)
                        }
                    } else if isInTag {
                        if character == "=" {
                            appendCharacter(character, defaultColor)
                        } else {
                            appendCharacter(character, PHP.attributeColor)
                        }
                    } else {
                        appendCharacter(character, defaultColor)
                    }
                }
            }
            index += 1
        }
        return highlighted
    }
    
}
