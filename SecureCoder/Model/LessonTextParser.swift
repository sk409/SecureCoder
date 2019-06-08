
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
                cache.removeAll()
            } else if cache == " " && !cache.hasPrefix("@[@") && !cache.hasPrefix("?[?") && !cache.hasPrefix("#[#") {
                text += " "
                delegate?.lessonTextParser(self, token: .space, text: " ", language: language)
                cache.removeAll()
            } else if cache.hasPrefix("@[@") && cache.hasSuffix("@]@") {
                language = ProgramingLanguage(rawValue: String(cache[3...(cache.count - 4)]))
                cache.removeAll()
            } else if cache.hasPrefix("?[?") && cache.hasSuffix("?]?") {
                let answer = String(cache[3...(cache.count - 4)])
                text += "<!--" + String(answerIndex) + "-->"
                text += "<!--" + String(answerIndex) + "-->"
                answerIndex += 1
                delegate?.lessonTextParser(self, token: .question, text: answer, language: language)
                cache.removeAll()
            } else if cache.hasPrefix("#[#") && cache.hasSuffix("#]#") {
                let template = String(cache[3...(cache.count - 4)])
                text += template
                delegate?.lessonTextParser(self, token: .template, text: template, language: language)
                cache.removeAll()
            }
            lessonTextIndex += 1
        }
        return text
    }
    
}
