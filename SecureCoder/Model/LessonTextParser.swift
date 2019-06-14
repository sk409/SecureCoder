
protocol LessonTextParserDelegate {
    
    func lessonTextParser(_ lessonTextParser: LessonTextParser, token: LessonTextParser.Token, text: String, language: ProgramingLanguage?)
    
}

struct LessonTextParser {
    
    enum Token {
        case space
        case newLine
        case template
        case question
    }
    
    var delegate: LessonTextParserDelegate?
    var newLineHandler: (() -> Void)?
    var spaceHandler: (() -> Void)?
    var questionHandler: ((Int, String, ProgramingLanguage) -> Void)?
    var templateHandler: ((String, ProgramingLanguage) -> Void)?
    
    func parse(_ lessonText: String) -> String {
        var text = ""
        var cache = ""
        var lessonTextIndex = 0
        var answerIndex = 0
        var language: ProgramingLanguage?
        while lessonTextIndex <= (lessonText.count - 1) {
            let character = lessonText[lessonTextIndex]
            cache.append(character)
            if cache == "\n" {
                text += "\n"
                delegate?.lessonTextParser(self, token: .newLine, text: "\n", language: language)
                newLineHandler?()
                cache.removeAll()
            } else if cache == " " && !cache.hasPrefix("@[@") && !cache.hasPrefix("?[?") && !cache.hasPrefix("#[#") {
                text += " "
                delegate?.lessonTextParser(self, token: .space, text: " ", language: language)
                spaceHandler?()
                cache.removeAll()
            } else if cache.hasPrefix("@[@") && cache.hasSuffix("@]@") {
                language = ProgramingLanguage(rawValue: String(cache[3...(cache.count - 4)]))
                cache.removeAll()
            } else if cache.hasPrefix("?[?") && cache.hasSuffix("?]?") {
                let answer = String(cache[3...(cache.count - 4)])
                text += "<!--" + String(answerIndex) + "-->"
                text += "<!--" + String(answerIndex) + "-->"
                delegate?.lessonTextParser(self, token: .question, text: answer, language: language)
                if language != nil {
                    questionHandler?(answerIndex, answer, language!)
                }
                cache.removeAll()
                answerIndex += 1
            } else if cache.hasPrefix("#[#") && cache.hasSuffix("#]#") {
                let template = String(cache[3...(cache.count - 4)])
                text += template
                delegate?.lessonTextParser(self, token: .template, text: template, language: language)
                if language != nil {
                    templateHandler?(template, language!)
                }
                cache.removeAll()
            }
            lessonTextIndex += 1
        }
        return text
    }
    
}
