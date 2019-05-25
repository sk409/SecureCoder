//import Foundation
//import UIKit
//
//struct PHPAutoCompleter: CodeAutoCompleter {
//    
//    private static let indentWidth = 4
//    
//    private static func isEmptyElementTag(tagName: String) -> Bool {
//        let ignoreTags = (HTML.emptyTags + ["<?php"]).map { $0.lowercased() }
//        return ignoreTags.contains(("<" + tagName).lowercased())
//    }
//    
//    private static func isCloseTag(tagName: String) -> Bool {
//        return !tagName.isEmpty && tagName[0] == "/"
//    }
//    
//    private static func isComment(tagName: String) -> Bool {
//        return tagName.hasPrefix("!--")
//    }
//    
//    private static func noCompletion(_ text: String, caretLocation: Int) -> CodeCompletionResult {
//        return CodeCompletionResult(insertionText: "", insertionLocation: 0, caretLocation: caretLocation)
//    }
//    
//    private static func completeCloseTag(_ text: String, selectedLocation: Int) -> CodeCompletionResult {
//        guard let tagName = getTagName(text, closeTagLocation: selectedLocation - 1) else {
//            return noCompletion(text, caretLocation: selectedLocation)
//        }
//        guard !isEmptyElementTag(tagName: tagName) else {
//            return noCompletion(text, caretLocation: selectedLocation)
//        }
//        let closeTag = "</" + tagName + ">"
//        return CodeCompletionResult(insertionText: closeTag, insertionLocation: selectedLocation, caretLocation: selectedLocation)
//    }
//    
//    static private func completeEnterKey(_ text: String, selectedLocation: Int) -> CodeCompletionResult {
//        let indent = getIndent(text, selectedLocation: selectedLocation)
//        guard indent != 0 else {
//            return noCompletion(text, caretLocation: selectedLocation)
//        }
//        let isOnlyIndent = !((selectedLocation <= (text.count - 1)) && (text[selectedLocation] == "<"))
//        let insertionText = isOnlyIndent ? String(repeating: " ", count: indent) : String(repeating: " ", count: indent) + "\n" + String(repeating: " ", count: indent - indentWidth)
//        return CodeCompletionResult(insertionText: insertionText, insertionLocation: selectedLocation, caretLocation: selectedLocation + indent)
//    }
//    
//    static private func completeDoubleQuatation(_ text: String, selectedLocation: Int) -> CodeCompletionResult {
//        return CodeCompletionResult(insertionText: "\"", insertionLocation: selectedLocation, caretLocation: selectedLocation)
//    }
//    
//    static private func getIndent(_ text: String, selectedLocation: Int) -> Int {
//        var indent = 0
//        for index in 0..<selectedLocation {
//            let endOfTag = text[index] == ">"
//            if endOfTag {
//                guard let tagName = getTagName(text, closeTagLocation: index) else {
//                    continue
//                }
//                if !isEmptyElementTag(tagName: tagName) && !isCloseTag(tagName: tagName) && !isComment(tagName: tagName) {
//                    indent += indentWidth
//                }
//            }
//            let beginingOfCloseTag = (index != selectedLocation - 1 && text[index] == "<" && text[index + 1] == "/")
//            if beginingOfCloseTag {
//                indent -= indentWidth
//            }
//        }
//        return indent
//    }
//    
//    static private func getTagName(_ text: String, closeTagLocation: Int) -> String? {
//        var startIndex = 0
//        for index in (0..<closeTagLocation).reversed() {
//            if text[index] != "<" {
//                continue
//            }
//            startIndex = index + 1
//            break
//        }
//        var endIndex = 0
//        for index in startIndex..<text.count {
//            if text[index] != " " && text[index] != ">" && text[index] != "\n" {
//                continue
//            }
//            endIndex = index - 1
//            break
//        }
//        if endIndex < startIndex {
//            return nil
//        }
//        return String(text[startIndex...endIndex])
//    }
//    
//    func complete(_ text: String, selectedLocation: Int) -> CodeCompletionResult {
//        guard !text.isEmpty else {
//            return PHPAutoCompleter.noCompletion(text, caretLocation: selectedLocation)
//        }
//        let keywords = [">", "\n", "\""]
//        guard keywords.contains(String(text[selectedLocation - 1])) else {
//            return PHPAutoCompleter.noCompletion(text, caretLocation: selectedLocation)
//        }
//        var cache = ""
//        var isPHP = false
//        for index in 0..<selectedLocation {
//            cache.append(text[index])
//            if text[index] == " " || text[index] == "\n" {
//                cache.removeAll()
//            }
//            if cache == "<?php" {
//                isPHP = true
//            } else if cache == "?>" {
//                isPHP = false
//            }
//        }
//        if isPHP {
//            
//        } else {
//            let insertedCharacter = text[selectedLocation - 1]
//            if insertedCharacter == ">" {
//                return PHPAutoCompleter.completeCloseTag(text, selectedLocation: selectedLocation)
//            } else if insertedCharacter == "\n" {
//                return PHPAutoCompleter.completeEnterKey(text, selectedLocation: selectedLocation)
//            } else if insertedCharacter == "\"" {
//                return PHPAutoCompleter.completeDoubleQuatation(text, selectedLocation: selectedLocation)
//            }
//        }
//        return PHPAutoCompleter.noCompletion(text, caretLocation: selectedLocation)
//    }
//    
//}
