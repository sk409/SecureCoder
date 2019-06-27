import Foundation
import UIKit

struct PHPSyntaxHighlighter {
    
    private(set) var tintColor: UIColor
    private(set) var font: UIFont
    
    init(tintColor: UIColor, font: UIFont) {
        self.tintColor = tintColor
        self.font = font
    }
    
    func syntaxHighlight(_ text: String) -> NSMutableAttributedString {
        let attributedString = HTMLSyntaxHighlighter(tintColor: tintColor, font: font).syntaxHighlight(text)
        if let phpRegex = try? NSRegularExpression(pattern: "<\\?php.*?\\?>", options: .dotMatchesLineSeparators) {
            let matches = phpRegex.matches(in: text, range: NSRange(location: 0, length: (text as NSString).length))
            for match in matches {
                attributedString.addAttributes([.foregroundColor: PHP.tagColor], range: NSRange(location: match.range.location, length: 5))
                attributedString.addAttributes([.foregroundColor: PHP.tagColor], range: NSRange(location: match.range.location + match.range.length - 2, length: 2))
                let a = PHP.reservedWords.flatMap { "((/\\*.*?\\*/)| )\($0)((/\\*.*?\\*/)| )" + "|" }
                var reservedWordPattern = String(a)
                reservedWordPattern.removeLast()
                reservedWordPattern = "(" + reservedWordPattern
                reservedWordPattern += ")"
                if let reservedWordRegex = try? NSRegularExpression(pattern: reservedWordPattern) {
                    let reservedWordMatches = reservedWordRegex.matches(in: text, range: match.range)
                    for reservedWordMatch in reservedWordMatches {
                        attributedString.addAttributes([.foregroundColor: PHP.reservedWordColor], range: reservedWordMatch.range)
                    }
                }
                if let stringRegex = try? NSRegularExpression(pattern: "\".*\"") {
                    let stringMatches = stringRegex.matches(in: text, range: match.range)
                    for stringMatch in stringMatches {
                        attributedString.addAttributes([.foregroundColor: PHP.stringColor], range: stringMatch.range)
                    }
                }
                if let functionRegex = try? NSRegularExpression(pattern: "((/\\*.*?\\*/)| )[a-zA-Z_][a-zA-Z0-9_]*\\(\\)") {
                    let functionMatches = functionRegex.matches(in: text, range: match.range)
                    for functionMatch in functionMatches {
                        //print((text as NSString).substring(with: functionMatch.range))
                        attributedString.addAttributes([.foregroundColor: PHP.functionColor], range: NSRange(location: functionMatch.range.location, length: functionMatch.range.length - 2))
                    }
                }
                if let variableRegex = try? NSRegularExpression(pattern: "((/\\*.*?\\*/)| )\\$[a-zA-Z_][a-zA-Z0-9_]*((/\\*.*?\\*/)| )") {
                    let variableMatches = variableRegex.matches(in: text, range: match.range)
                    for variableMatch in variableMatches {
                        attributedString.addAttributes([.foregroundColor: PHP.variableColor], range: variableMatch.range)
                    }
                }
//                if let classRegex = try? NSRegularExpression(pattern: "(new +[a-zA-Z_][a-zA-Z0-9_]*\\(\\)") {
//                    let classMatches = classRegex.matches(in: text, range: match.range)
//                    for classMatch in classMatches {
//                        print((text as NSString).substring(with: classMatch.range))
//                        attributedString.addAttributes([.foregroundColor: PHP.classColor], range: classMatch.range)
//                    }
//                }
            }
        }
        return attributedString
//        let tagColor = UIColor.turquoiseBlue
//        let reservedWordColor = UIColor.rosePink
//        let classColor = UIColor.turquoiseBlue
//        let functionColor = UIColor.mintGreen
//        let commentColor = UIColor.forestGreen
//        let variableColor = UIColor.cobaltBlue
//        let stringColor = UIColor.signalRed
//        let attributeColor = UIColor.cobaltBlue
//        let decoratedString = NSMutableAttributedString()
//        var isInTag = false
//        var index = 0
//        while index <= (text.count - 1) {
//            let character = text[index]
//            if (index <= text.count - 5) && (text[index...(index + 4)] == "<?php") {
//                if (index <= text.count - 5) && (text[index...(index + 4)] == "<?php") {
//                    appendAttributedString(decoratedString, string: String(text[index...(index + 4)]), color: tagColor)
//                    index += 5
//                }
//                var cache = ""
//                while index != text.count {
//                    if PHP.reservedWords.contains(cache) {
//                        if index <= text.count - 3 && text[index] == "e" && text[index + 1] == "a" && text[index + 2] == "c" && text[index + 3] == "h" {
//                            cache.append(text[index])
//                            cache.append(text[index + 1])
//                            cache.append(text[index + 2])
//                            cache.append(text[index + 3])
//                            index += 4
//                        }
//                        if text[index].isWhitespace || (["require", "require_once", "include"].contains(cache) && text[index] == "(") {
//                            appendAttributedString(decoratedString, string: cache, color: reservedWordColor)
//                            let isNew = cache == "new"
//                            cache.removeAll()
//                            if isNew {
//                                while true {
//                                    cache.append(text[index])
//                                    index += 1
//                                    if index == text.count || text[index] == "(" {
//                                        break
//                                    }
//                                }
//                                appendAttributedString(decoratedString, string: cache, color: classColor)
//                                cache.removeAll()
//                            }
//                        }
//                    } else if cache == "//" {
//                        while true {
//                            cache.append(text[index])
//                            index += 1
//                            if index == text.count || text[index] == "\n" {
//                                break
//                            }
//                        }
//                        appendAttributedString(decoratedString, string: cache, color: commentColor)
//                        cache.removeAll()
//                    } else if (2 <= cache.count) && cache[cache.count - 1] == ":" && cache[cache.count - 2] == ":" {
//                        for i in 3...cache.count {
//                            if !cache[cache.count - i].isAlphaNumeric() && cache[cache.count - i] != "_" {
//                                appendAttributedString(decoratedString,
//                                                       string: String(cache[0...(cache.count - i)]),
//                                                       color: defaultColor)
//                                appendAttributedString(decoratedString,
//                                                       string: String(cache[(cache.count - i + 1)...(cache.count - 3)]),
//                                                       color: classColor)
//                                appendAttributedString(decoratedString,
//                                                       string: String(cache[(cache.count - 2)...]),
//                                                       color: defaultColor)
//                                break
//                            }
//                            if i == cache.count {
//                                appendAttributedString(decoratedString,
//                                                       string: String(cache[...(cache.count - 3)]),
//                                                       color: classColor)
//                                appendAttributedString(decoratedString,
//                                                       string: String(cache[(cache.count - 2)...]),
//                                                       color: defaultColor)
//                            }
//                        }
//                        cache.removeAll()
//                    } else if cache == "?>" {
//                        appendAttributedString(decoratedString, string: cache, color: tagColor)
//                        cache.removeAll()
//                        break
//                    }
//                    if index < text.count {
//                        if text[index] == "$" {
//                            appendAttributedString(decoratedString, string: cache, color: defaultColor)
//                            cache.removeAll()
//                            while true {
//                                cache.append(text[index])
//                                index += 1
//                                if index == text.count || !text[index].isAlphaNumeric() && text[index] != "_" {
//                                    break
//                                }
//                            }
//                            appendAttributedString(decoratedString, string: cache, color: variableColor)
//                            cache.removeAll()
//                        } else if text[index] == "(" && !cache.isEmpty {
//                            for i in 1...cache.count {
//                                if !cache[cache.count - i].isVariableAllowed() {
//                                    appendAttributedString(decoratedString,
//                                                           string: String(cache[...(cache.count - i)]),
//                                                           color: defaultColor)
//                                    appendAttributedString(decoratedString,
//                                                           string: String(cache[(cache.count - i + 1)...]),
//                                                           color: functionColor)
//                                    cache.removeAll()
//                                    break
//                                }
//                                else if i == cache.count {
//                                    appendAttributedString(decoratedString,
//                                                           string: cache,
//                                                           color: functionColor)
//                                    cache.removeAll()
//                                }
//                            }
//                        } else if text[index] == "\"" {
//                            appendAttributedString(decoratedString, string: cache, color: defaultColor)
//                            cache.removeAll()
//                            while true {
//                                cache.append(text[index])
//                                index += 1
//                                if index == text.count {
//                                    break
//                                }
//                                if text[index] == "\"" {
//                                    cache.append(text[index])
//                                    index += 1
//                                    break
//                                }
//                            }
//                            appendAttributedString(decoratedString, string: cache, color: stringColor)
//                            cache.removeAll()
//                        } else if text[index] == " " || text[index] == "\n" {
//                            cache.append(text[index])
//                            appendAttributedString(decoratedString, string: cache, color: defaultColor)
//                            cache.removeAll()
//                            index += 1
//                        } else {
//                            cache.append(text[index])
//                            index += 1
//                        }
//                    }
//                }
//                if !cache.isEmpty {
//                    appendAttributedString(decoratedString, string: cache, color: defaultColor)
//                }
//            } else if character == "<" {
//                if index <= (text.count - 4) && (text[index + 1] == "!") && (text[index + 2] == "-") && (text[index + 3] == "-") {
//                    var cache = ""
//                    while index != text.count && !((cache.count >= 3) && (cache[cache.count - 3] == "-") && (cache[cache.count - 2] == "-") && (cache[cache.count - 1] == ">")) {
//                        cache.append(text[index])
//                        index += 1
//                    }
//                    appendAttributedString(decoratedString, string: cache, color: commentColor)
//                } else {
//                    appendAttributedString(decoratedString, string: String(character), color: isInTag ? UIColor.turquoiseBlue : defaultColor)
//                    isInTag = true
//                    index += 1
//                    if index != text.count && text[index] == "/" {
//                        appendAttributedString(decoratedString, string: String(text[index]), color: defaultColor)
//                        index += 1
//                    }
//                    while (index != text.count) && (text[index] != " ") && (text[index] != ">") {
//                        appendAttributedString(decoratedString, string: String(text[index]), color: tagColor)
//                        index += 1
//                    }
//                }
//            } else if character == ">" {
//                isInTag = false
//                appendAttributedString(decoratedString, string: String(character), color: defaultColor)
//                index += 1
//            } else if character == "\"" {
//                repeat {
//                    appendAttributedString(decoratedString, string: String(text[index]), color: stringColor)
//                    index += 1
//                } while (index <= text.count - 1) && (text[index] != "\"")
//                if index <= text.count - 1 {
//                    appendAttributedString(decoratedString, string: String(text[index]), color: stringColor)
//                }
//                index += 1
//            } else {
//                let decorationColor = isInTag ? attributeColor : defaultColor
//                appendAttributedString(decoratedString, string: String(character), color: decorationColor)
//                index += 1
//            }
//        }
//        return decoratedString
    }
    
    private func makeAttributedString(text: String) -> NSAttributedString {
        if text.isPHPVariableAllowed() {
            return NSAttributedString(string: text, attributes: [.foregroundColor: PHP.variableColor, .font: font])
        } else if PHP.reservedWords.contains(text) {
            return NSAttributedString(string: text, attributes: [.foregroundColor: PHP.reservedWordColor, .font: font])
        } else if text.hasPrefix("\"") {
            return NSAttributedString(string: text, attributes: [.foregroundColor: PHP.stringColor, .font: font])
        } else if text.isNumber() {
            return NSAttributedString(string: text, attributes: [.foregroundColor: PHP.numberColor, .font: font])
        }
        return NSAttributedString(string: text, attributes: [.foregroundColor: tintColor, .font: font])
    }
    
}
