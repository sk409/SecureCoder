import UIKit

struct HTMLSyntaxHighlighter {
    
    let tintColor: UIColor
    
    let font: UIFont
    
    init(tintColor: UIColor, font: UIFont) {
        self.tintColor = tintColor
        self.font = font
    }
    
    func syntaxHighlight(_ text: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text, attributes: [.foregroundColor: tintColor, .font: font])
        if let openTagRegex = try? NSRegularExpression(pattern: "<(?!!--)(?!\\?php)[^/].+?>", options: .dotMatchesLineSeparators) {
            let matches = openTagRegex.matches(in: text, range: NSRange(location: 0, length: (text as NSString).length))
            for match in matches {
                if let tagNameRegex = try? NSRegularExpression(pattern: "<[^ ]+") {
                    if let tagNameMatch = tagNameRegex.matches(in: text, range: match.range).first {
                        attributedString.addAttributes([.foregroundColor: PHP.tagColor], range: NSRange(location: tagNameMatch.range.location + 1, length: tagNameMatch.range.length - 1))
                    }
                }
                if let attributeRegex = try? NSRegularExpression(pattern: " [^ =>]+") {
                    let attributeMatches = attributeRegex.matches(in: text, range: match.range)
                    for attributeMatch in attributeMatches {
                        attributedString.addAttributes([.foregroundColor: PHP.attributeColor], range: attributeMatch.range)
                    }
                }
                if let equalRegex = try? NSRegularExpression(pattern: "=") {
                    let equalMatches = equalRegex.matches(in: text, range: match.range)
                    for equalMatch in equalMatches {
                        attributedString.addAttributes([.foregroundColor: tintColor], range: equalMatch.range)
                    }
                }
                if let stringRegex = try? NSRegularExpression(pattern: "\".*\"") {
                    let stringMatches = stringRegex.matches(in: text, range: match.range)
                    for stringMatch in stringMatches {
                        attributedString.addAttributes([.foregroundColor: PHP.stringColor], range: stringMatch.range)
                    }
                }
            }
        }
        if let closeTagRegex = try? NSRegularExpression(pattern: "</.*?>") {
            let matches = closeTagRegex.matches(in: text, range: NSRange(location: 0, length: (text as NSString).length))
            for match in matches {
                attributedString.addAttributes([.foregroundColor: PHP.tagColor], range: NSRange(location: match.range.location + 2, length: match.range.length - 3))
            }
        }
        if let commentRegex = try? NSRegularExpression(pattern: "<!--.*?-->") {
            let commentMatches = commentRegex.matches(in: text, range: NSRange(location: 0, length: (text as NSString).length))
            for commentMatch in commentMatches {
                attributedString.addAttributes([.foregroundColor: PHP.commentColor], range: commentMatch.range)
            }
        }
        return attributedString
//        let highlighted = NSMutableAttributedString()
//        var index = 0
//        var isComment = false
//        var isTag = false
//        var isInTag = false
//        var isInString = false
//        let appendCharacter: (Character, UIColor) -> Void = { character, color in
//            highlighted.append(NSAttributedString(string: String(character), attributes: [.foregroundColor: color, .font: self.font]))
//        }
//        while index <= (text.count - 1) {
//            let character = text[index]
//            if character != ">" && isComment {
//                appendCharacter(character, PHP.commentColor)
//            } else {
//                if character == "<" {
//                    if index <= (text.count - 4) && text[index + 1] == "!" && text[index + 2] == "-" && text[index + 3] == "-" {
//                        appendCharacter(character, PHP.commentColor)
//                        isComment = true
//                    } else {
//                        appendCharacter(character, tintColor)
//                        isTag = true
//                    }
//                } else if character == ">" {
//                    let stringCount = highlighted.string.count
//                    if 2 <= stringCount && highlighted.string[stringCount - 2] == "-" && highlighted.string[stringCount - 1] == "-" {
//                        appendCharacter(character, PHP.commentColor)
//                        isComment = false
//                    } else {
//                        appendCharacter(character, tintColor)
//                        isTag = false
//                        isInTag = false
//                    }
//                } else if character == "\"" {
//                    appendCharacter(character, PHP.stringColor)
//                    isInString = !isInString
//                } else {
//                    if isInString {
//                        appendCharacter(character, PHP.stringColor)
//                    }
//                    else if isTag {
//                        if character == " " {
//                            isTag = false
//                            isInTag = true
//                            appendCharacter(character, tintColor)
//                        } else if character == "/" {
//                            appendCharacter(character, tintColor)
//                        } else {
//                            appendCharacter(character, PHP.tagColor)
//                        }
//                    } else if isInTag {
//                        if character == "=" {
//                            appendCharacter(character, tintColor)
//                        } else {
//                            appendCharacter(character, PHP.attributeColor)
//                        }
//                    } else {
//                        appendCharacter(character, tintColor)
//                    }
//                }
//            }
//            index += 1
//        }
//        return highlighted
    }
    
}
