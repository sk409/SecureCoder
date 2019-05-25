//import UIKit
//
//struct AutoCorrectSuggestion {
//    
//    struct Literal {
//        
//        static func <(lhs: Literal, rhs: Literal) -> Bool {
//            return lhs.word < rhs.word
//        }
//        
//        let word: String
//        let replacementWord: String
//        let color: UIColor
//        
//        init(word: String, replacementWord: String, color: UIColor) {
//            self.word = word
//            self.color = color
//            self.replacementWord = replacementWord
//        }
//        
//    }
//    
//    let words: [String]
//    let replacementWords: [String]
//    let color: UIColor
//    
//    init(words: [String], color: UIColor) {
//        self.words = words
//        self.color = color
//        replacementWords = words
//    }
//    
//    init(words: [String], replacementWords: [String], color: UIColor) {
//        self.words = words
//        self.replacementWords = replacementWords
//        self.color = color
//    }
//    
//    func flatten() -> [Literal] {
//        var literals = [Literal]()
//        for (index, word) in words.enumerated() {
//            literals.append(Literal(word: word, replacementWord: replacementWords[index], color: color))
//        }
//        return literals
//    }
//    
//}
