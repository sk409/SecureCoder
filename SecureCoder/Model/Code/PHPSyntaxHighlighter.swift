import Foundation
import UIKit

struct PHPSyntaxHighlighter: CodeSyntaxHighlighter {
    
    private(set) var defaultColor: UIColor
    private(set) var font: UIFont
    
    init(defaultColor: UIColor, font: UIFont) {
        self.defaultColor = defaultColor
        self.font = font
    }
    
    func syntaxHighlight(_ text: String) -> NSMutableAttributedString {
        let highlighted = NSMutableAttributedString()
        var cache = ""
        var index = 0
        while index <= (text.count - 1) {
            let character = text[index]
            if character.isPrintable() && character != ";" {
                cache.append(character)
            } else {
                highlighted.append(makeAttributedString(text: cache))
                highlighted.append(NSAttributedString(string: String(character), attributes: [.foregroundColor: defaultColor, .font: font]))
                cache.removeAll()
            }
            index += 1
        }
        highlighted.append(makeAttributedString(text: cache))
        return highlighted
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
        return NSAttributedString(string: text, attributes: [.foregroundColor: defaultColor, .font: font])
    }
    
}
