import UIKit

struct HTMLSyntaxHighlighter {
    
    let tintColor: UIColor
    
    let font: UIFont
    
    init(tintColor: UIColor, font: UIFont) {
        self.tintColor = tintColor
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
                        appendCharacter(character, tintColor)
                        isTag = true
                    }
                } else if character == ">" {
                    let stringCount = highlighted.string.count
                    if 2 <= stringCount && highlighted.string[stringCount - 2] == "-" && highlighted.string[stringCount - 1] == "-" {
                        appendCharacter(character, PHP.commentColor)
                        isComment = false
                    } else {
                        appendCharacter(character, tintColor)
                        isTag = false
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
                            appendCharacter(character, tintColor)
                        } else if character == "/" {
                            appendCharacter(character, tintColor)
                        } else {
                            appendCharacter(character, PHP.tagColor)
                        }
                    } else if isInTag {
                        if character == "=" {
                            appendCharacter(character, tintColor)
                        } else {
                            appendCharacter(character, PHP.attributeColor)
                        }
                    } else {
                        appendCharacter(character, tintColor)
                    }
                }
            }
            index += 1
        }
        return highlighted
    }
    
}
