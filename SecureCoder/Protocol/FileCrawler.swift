//protocol FileCrawler {
//    
//    var text: String { get }
//    var endIndex: Int { get }
//    
//    func skip(to character: Character, index: Int) -> Int?
//    func skip(before character: Character, index: Int) -> Int?
//    func skip(after character: Character, index: Int) -> Int?
//    func skip(to characters: [Character], index: Int) -> Int?
//    func skip(before characters: [Character], index: Int) -> Int?
//    func skip(after characters: [Character], index: Int) -> Int?
//    func skip(to word: String, index: Int) -> Int?
//    func skip(before word: String, index: Int) -> Int?
//    func skip(after word: String, index: Int) -> Int?
//    func skip(to words: [String], index: Int) -> Int?
//    func skip(before words: [String], index: Int) -> Int?
//    func skip(after words: [String], index: Int) -> Int?
//    func skip(to condition: (Character) -> Bool, index: Int) -> Int?
//    func skip(before condition: (Character) -> Bool, index: Int) -> Int?
//    func skip(after condition: (Character) -> Bool, index: Int) -> Int?
//    func skipBlock(index: Int) -> Int?
//    
//}
//
//extension FileCrawler {
//    
//    func skip(to character: Character, index: Int) -> Int? {
//        guard index <= (endIndex - 1) else {
//            return nil
//        }
//        for i in index...(endIndex - 1) {
//            if text[i] == character {
//                return i
//            }
//        }
//        return nil
//    }
//    
//    func skip(before character: Character, index: Int) -> Int? {
//        guard let i = skip(to: character, index: index) else {
//            return nil
//        }
//        return i - 1
//    }
//    
//    func skip(after character: Character, index: Int) -> Int? {
//        guard let i = skip(to: character, index: index) else {
//            return nil
//        }
//        return i + 1
//    }
//    
//    func skip(to characters: [Character], index: Int) -> Int? {
//        guard index <= (endIndex - 1) else {
//            return nil
//        }
//        for i in index...(endIndex - 1) {
//            if characters.contains(text[i]) {
//                return i
//            }
//        }
//        return nil
//    }
//    
//    func skip(before characters: [Character], index: Int) -> Int? {
//        guard let i = skip(to: characters, index: index) else {
//            return nil
//        }
//        return i - 1
//    }
//    
//    func skip(after characters: [Character], index: Int) -> Int? {
//        guard let i = skip(to: characters, index: index) else {
//            return nil
//        }
//        return i + 1
//    }
//    
//    func skip(to word: String, index: Int) -> Int? {
//        guard index <= (endIndex - 1) else {
//            return nil
//        }
//        var cache = ""
//        for i in index...(endIndex - 1) {
//            if cache == word {
//                return i
//            }
//            let character = text[i]
//            if character.isWhitespace || character.isNewline {
//                cache.removeAll()
//            } else {
//                cache.append(character)
//            }
//        }
//        return nil
//    }
//    
//    func skip(before word: String, index: Int) -> Int? {
//        guard let i = skip(to: word, index: index) else {
//            return nil
//        }
//        return i - 1
//    }
//    
//    func skip(after word: String, index: Int) -> Int? {
//        guard let i = skip(to: word, index: index) else {
//            return nil
//        }
//        return i + 1
//    }
//    
//    func skip(to words: [String], index: Int) -> Int? {
//        guard index <= (endIndex - 1) else {
//            return nil
//        }
//        var cache = ""
//        for i in index...(endIndex - 1) {
//            if words.contains(cache) {
//                return i
//            }
//            let character = text[i]
//            if character.isWhitespace || character.isNewline {
//                cache.removeAll()
//            } else {
//                cache.append(character)
//            }
//        }
//        return nil
//    }
//    
//    func skip(before words: [String], index: Int) -> Int? {
//        guard let i = skip(to: words, index: index) else {
//            return nil
//        }
//        return i - 1
//    }
//    
//    func skip(after words: [String], index: Int) -> Int? {
//        guard let i = skip(to: words, index: index) else {
//            return nil
//        }
//        return i + 1
//    }
//    
//    func skip(to condition: (Character) -> Bool, index: Int) -> Int? {
//        guard index <= (endIndex - 1) else {
//            return nil
//        }
//        for i in index...(endIndex - 1) {
//            if condition(text[i]) {
//                return i
//            }
//        }
//        return nil
//    }
//    
//    func skip(before condition: (Character) -> Bool, index: Int) -> Int? {
//        guard let i = skip(to: condition, index: index) else {
//            return nil
//        }
//        return i - 1
//    }
//    
//    func skip(after condition: (Character) -> Bool, index: Int) -> Int? {
//        guard let i = skip(to: condition, index: index) else {
//            return nil
//        }
//        return i + 1
//    }
//    
//    func skipBlock(index: Int) -> Int? {
//        guard var i = skip(after: "{", index: index) else {
//            return nil
//        }
//        var value = 1
//        while i <= (endIndex - 1) {
//            let character = text[i]
//            if character == "{" {
//                value += 1
//            }
//            if character == "}" {
//                value -= 1
//            }
//            if value == 0 {
//                break
//            }
//            i += 1
//        }
//        return (value == 0) ? i : nil
//    }
//    
//}
