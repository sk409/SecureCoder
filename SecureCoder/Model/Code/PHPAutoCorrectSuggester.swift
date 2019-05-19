import Foundation

// ターゲットを意識して開発する
// TypeTalk 1週間の振り返り書く
// 北海道までに締め切り２つ

/*
 北海道回までにやること
 ユーザに抵抗感を感じさせないデザインにする
 シンタックスハイライト、自動補間、予測変換の機能を完成させる
 正解判定のアルゴリズムをユーザフレンドリにする
 HTML/CSS, PHPの基本のレッスンを追加する
 //横画面にして使いやすいキーボードにするかも?
 */

struct PHPAutoCorrectSuggester {
    
    private struct ExternalFileCrawler: FileCrawler {
        
        var externalFileNames: [String]
        let fileName: String
        let text: String
        let endIndex: Int
        
        init(fileName: String, text: String, endIndex: Int) {
            externalFileNames = []
            self.fileName = fileName
            self.text = text
            self.endIndex = endIndex
        }
        
        private init(fileName: String, text: String, endIndex: Int, externalFileNames: [String]) {
            self.externalFileNames = externalFileNames
            self.fileName = fileName
            self.text = text
            self.endIndex = endIndex
        }
        
        mutating func crawl() -> [String] {
            guard let lesson = Lesson.active else {
                return []
            }
            var index = 0
            while index <= (endIndex - 1) {
                guard let i = skip(to: ["require", "require_once", "include"], index: index) else {
                    break
                }
                index = i
                guard let start = skip(after: Character("\""), index: index) else {
                    break
                }
                guard let bound = skip(before: Character("\""), index: start + 1) else {
                    break
                }
                let externalFileName = String(text[start...bound])
                if externalFileName != fileName && !externalFileNames.contains(externalFileName) {
                    externalFileNames.append(externalFileName)
                    guard let externalFile = lesson.find(by: externalFileName) else {
                        continue
                    }
                    var externalFileCrawler = ExternalFileCrawler(fileName: fileName, text: externalFile.text, endIndex: externalFile.text.count, externalFileNames: externalFileNames)
                    externalFileNames = externalFileCrawler.crawl()
                }
                index = bound
            }
            return externalFileNames
        }
        
        
    }
    
    private struct VariableCrawler: FileCrawler {
        
        private enum Scope: String {
            case global
            case `class`
            case interface
            case trait
            case function
        }
        
        let fileName: String
        let text: String
        let endIndex: Int
        
        
        init(fileName: String, text: String, endIndex: Int) {
            self.fileName = fileName
            self.text = text
            self.endIndex = endIndex
        }
        
        mutating func crawl(externalGlobalVariables: [String]) -> [String] {
            var globalVariables = [String]()
            var visibleVariables = [String]()
            var cache = ""
            var scope = Scope.global
            var global = false
            var index = 0
            while index <= (endIndex - 1) {
                let character = text[index]
                if character.isPHPVariableAllowed() {
                    cache.append(character)
                } else {
                    if cache.isPHPVariableAllowed() && [Scope.global, .function].contains(scope) {
                        if scope == .function && global && (globalVariables.contains(cache) || externalGlobalVariables.contains(cache)) {
                            visibleVariables.append(cache)
                        } else if scope == .function && !global {
                            visibleVariables.append(cache)
                        } else if scope == .global {
                            globalVariables.append(cache)
                        }
                    }
                    if global && character == ";" {
                        global = false
                    }
                    cache.removeAll()
                }
                if cache == "function" {
                    if let i = skipBlock(index: index) {
                        index = i
                    } else {
                        scope = .function
                    }
                } else if cache == "global" && scope == .function {
                    global = true
                } else if ["class", "interface", "trait"].contains(cache) {
                    if let i = skipBlock(index: index) {
                        index = i
                    } else {
                        scope = Scope(rawValue: cache) ?? .global
                    }
                }
                index += 1
            }
            return scope == .global ? (globalVariables + externalGlobalVariables) : visibleVariables
        }
        
        mutating func crawlGlobalVariables() -> [String] {
            var variables = [String]()
            var index = 0;
            var cache = ""
            while index <= (endIndex - 1) {
                let character = text[index]
                if character.isPrintable() {
                    cache.append(character)
                } else {
                    if cache.isPHPVariableAllowed() {
                        variables.append(cache)
                    } else if ["class", "interface", "trait", "function"].contains(cache) {
                        guard let i = skipBlock(index: index) else {
                            break
                        }
                        index = i
                        cache.removeAll()
                    } else {
                        cache.removeAll()
                    }
                }
                index += 1
            }
            return variables
        }
        
    }
    
    private struct FunctionCrawler: FileCrawler {
        
        var crawled: [String]
        var fileName: String
        var text: String
        var endIndex: Int
        
        init(fileName: String, text: String, endIndex: Int) {
            self.crawled = []
            self.fileName = fileName
            self.text = text
            self.endIndex = endIndex
        }
        
        init(fileName: String, text: String, endIndex: Int, crawled: [String]) {
            self.crawled = crawled
            self.fileName = fileName
            self.text = text
            self.endIndex = endIndex
        }
        
        func crawl() -> [String] {
            var functionNames = [String]()
            var cache = ""
            var index = 0
            while index <= (endIndex - 1) {
                if cache == "function" {
                    guard let start = skip(to: { $0.isVariableAllowed() }, index: index) else {
                        break
                    }
                    guard let bound = skip(before: Character("("), index: start + 1) else {
                        break
                    }
                    functionNames.append(String(text[start...bound]))
                    index = bound + 1
                } else if ["class", "interface", "trait"].contains(cache) {
                    if let i = skipBlock(index: index) {
                        index = i
                    }
                }
                let character = text[index]
                if !character.isPrintable() {
                    cache.removeAll()
                } else {
                    cache.append(character)
                }
                index += 1
            }
            return functionNames
        }
        
        
    }
    
    struct TypeCrawler: FileCrawler {
        
        enum Key: String {
            case `class` = "class"
            case interface = "interface"
            case trait = "trait"
        }
        
        var text: String
        var endIndex: Int
        var key: Key
        
        init(text: String, endIndex: Int, key: Key) {
            self.text = text
            self.endIndex = endIndex
            self.key = key
        }
        
        func crawl() -> [String] {
            var classes = [String]()
            var isType = false
            var index = 0
            var cache = ""
            while index <= (endIndex - 1) {
                let character = text[index]
                if character.isPrintable() {
                    cache.append(character)
                } else {
                    if isType {
                        classes.append(cache)
                        isType = false
                    }
                    if cache == key.rawValue {
                        isType = true
                    }
                    cache.removeAll()
                }
                index += 1
            }
            return classes
        }
        
        
    }
    
    mutating func suggest(token: PHP.Token, file: File, caretLocation: Int) -> [AutoCorrectSuggestion.Literal] {
        guard let lesson = Lesson.active else {
            return []
        }
        var externalFileCrawer = ExternalFileCrawler(fileName: file.name, text: file.text, endIndex: caretLocation)
        let externalFiles = externalFileCrawer.crawl().map { lesson.find(by: $0) }.compactMap { $0 }
        var suggestion = [AutoCorrectSuggestion]()
        if token.isTag {
            let replacementWords = HTML.tags.filter { $0.hasPrefix(token.text) }
            suggestion.append(AutoCorrectSuggestion(
                words: replacementWords.map { String($0[1...]) },
                replacementWords: replacementWords,
                color: PHP.tagColor
            ))
        }
        if token.isTagAttribute {
            if let attributes = HTML.attributes[token.tag] {
                let words = (attributes + ["class", "id"]).filter { $0.hasPrefix(token.text) }
                suggestion.append(AutoCorrectSuggestion(words: words, color: PHP.attributeColor))
            }
        }
        if token.isVariable {
            if token.isGlobal {
                var globalVariables = [String]()
                for targetFile in [file] + externalFiles {
                    var endIndex = 0
                    if targetFile.name == file.name {
                        endIndex = token.isVariable ? (caretLocation - token.text.count) : caretLocation
                    } else {
                        endIndex = targetFile.text.count
                    }
                    var variableCrawler = VariableCrawler(fileName: targetFile.name, text: targetFile.text, endIndex: endIndex)
                    globalVariables += variableCrawler.crawlGlobalVariables()
                }
                let variables = NSOrderedSet(array: globalVariables).array as! [String]
                let words = variables.filter { $0.hasPrefix(token.text) }
                suggestion.append(AutoCorrectSuggestion(words: words, color: PHP.variableColor))
            } else {
                var externalGlobalVariables = [String]()
                for externalFile in externalFiles {
                    var variableCrawler = VariableCrawler(fileName: externalFile.name, text: externalFile.text, endIndex: externalFile.text.count)
                    externalGlobalVariables += variableCrawler.crawlGlobalVariables()
                }
                let endIndex = token.isVariable ? (caretLocation - token.text.count) : caretLocation
                var variableCrawler = VariableCrawler(fileName: file.name, text: file.text, endIndex: endIndex)
                let userDefinedVariables = variableCrawler.crawl(externalGlobalVariables: externalGlobalVariables)
                let variables = NSOrderedSet(array: (PHP.standardVariables + userDefinedVariables)).array as! [String]
                let words = variables.filter { $0.hasPrefix(token.text) }
                suggestion.append(AutoCorrectSuggestion(words: words, color: PHP.variableColor))
            }
        }
        if token.isConstant {
            let words = PHP.standardConstants.filter { $0.hasPrefix(token.text) }
            suggestion.append(AutoCorrectSuggestion(words: words, color: PHP.constantColor))
        }
        if token.isFunction {
            var userDefinedFunctions = [String]()
            for targetFile in [file] + externalFiles {
                let functionCrawler = FunctionCrawler(fileName: targetFile.name, text: targetFile.text, endIndex: targetFile.text.count)
                userDefinedFunctions += functionCrawler.crawl()
            }
            let functions = NSOrderedSet(array: (PHP.standardFunctions + userDefinedFunctions)).array as! [String]
            let words = functions.filter { $0.hasPrefix(token.text) }
            suggestion.append(AutoCorrectSuggestion(words: words, color: PHP.functionColor))
        }
        if token.isClass {
            var userDefinedClasses = [String]()
            for targetFile in [file] + externalFiles {
                let endIndex = (targetFile.name == file.name) ? caretLocation : targetFile.text.count
                let classCrawler = TypeCrawler(text: targetFile.text, endIndex: endIndex, key: .class)
                userDefinedClasses += classCrawler.crawl()
            }
            let words = (PHP.standardClasses + userDefinedClasses).filter { $0.hasPrefix(token.text) }
            suggestion.append(AutoCorrectSuggestion(words: words, color: PHP.classColor))
        }
        if token.isInterface {
            var userDefinedInterfaces = [String]()
            for targetFile in [file] + externalFiles {
                let endIndex = (targetFile.name == file.name) ? caretLocation : targetFile.text.count
                let interfaceCrawler = TypeCrawler(text: targetFile.text, endIndex: endIndex, key: .interface)
                userDefinedInterfaces += interfaceCrawler.crawl()
            }
            let words = (PHP.standardInterfaces + userDefinedInterfaces).filter { $0.hasPrefix(token.text) }
            suggestion.append(AutoCorrectSuggestion(words: words, color: PHP.interfaceColor))
        }
        if token.isTrait {
            var userDefinedTraits = [String]()
            for targetFile in [file] + externalFiles {
                let endIndex = (targetFile.name == file.name) ? caretLocation : targetFile.text.count
                let traitCrawler = TypeCrawler(text: targetFile.text, endIndex: endIndex, key: .trait)
                userDefinedTraits += traitCrawler.crawl()
            }
            let words = (PHP.standardTraits + userDefinedTraits).filter { $0.hasPrefix(token.text) }
            suggestion.append(AutoCorrectSuggestion(words: words, color: PHP.traitColor))
        }
        if token.isReservedWords {
            let words = PHP.reservedWords.filter { $0.hasPrefix(token.text) }
            suggestion.append(AutoCorrectSuggestion(words: words, color: PHP.reservedWordColor))
        }
        return suggestion.flatMap { $0.flatten() }.sorted(by: <)
    }
    
}
