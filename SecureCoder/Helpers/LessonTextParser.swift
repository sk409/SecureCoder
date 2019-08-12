import Foundation

protocol LessonTextParserDelegate {
    
    func lessonTextParserHandleNewLine(_ lessonTextParser: LessonTextParser)
    func lessonTextParserHandleSpace(_ lessonTextParser: LessonTextParser)
    func lessonTextParser(_ lessonTextParser: LessonTextParser, handleQuestionAt index: Int, answer: String)
    func lessonTextParser(_ lessonTextParser: LessonTextParser, handleTemplateIn range: NSRange, template: String)
    func lessonTextParser(_ lessonTextParser: LessonTextParser, finishedParsing planeText: String)
    
}

struct LessonTextParser {
    
    var delegate: LessonTextParserDelegate?
    
    mutating func parse(_ lessonText: String, language: ProgramingLanguage) -> String {
        var text = ""
        var cache = ""
        var lessonTextIndex = 0
        var questionIndex = 0
        var templateRange = NSRange(location: 0, length: 0)
        while lessonTextIndex <= (lessonText.count - 1) {
            let character = lessonText[lessonTextIndex]
            cache.append(character)
            if cache == "\n" {
                text += "\n"
                templateRange.location += 1
                delegate?.lessonTextParserHandleNewLine(self)
                cache.removeAll()
            } else if cache == " " && !cache.hasPrefix("@[@") && !cache.hasPrefix("?[?") && !cache.hasPrefix("#[#") {
                text += " "
                templateRange.location += 1
                delegate?.lessonTextParserHandleSpace(self)
                cache.removeAll()
            }
            else if cache.hasPrefix("?[?") && cache.hasSuffix("?]?") {
                let answer = String(cache[3...(cache.count - 4)])
                delegate?.lessonTextParser(self, handleQuestionAt: questionIndex, answer: answer)
                cache.removeAll()
                questionIndex += 1
            } else if cache.hasPrefix("#[#") && cache.hasSuffix("#]#") {
                let template = String(cache[3...(cache.count - 4)])
                text += template
                templateRange.length = template.count
                delegate?.lessonTextParser(self, handleTemplateIn: templateRange, template: template)
                templateRange.location += templateRange.length
                cache.removeAll()
            }
            lessonTextIndex += 1
        }
        delegate?.lessonTextParser(self, finishedParsing: text)
        return text
    }
    
}
