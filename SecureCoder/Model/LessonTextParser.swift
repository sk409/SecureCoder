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
//    var newLineHandler: (() -> Void)?
//    var spaceHandler: (() -> Void)?
//    var questionHandler: ((Int, String, ProgramingLanguage) -> Void)?
//    var templateHandler: ((NSRange, String, ProgramingLanguage) -> Void)?
    
    mutating func parse(_ lessonText: String) -> String {
        var text = ""
        var cache = ""
        var lessonTextIndex = 0
        var questionIndex = 0
        var templateRange = NSRange(location: 0, length: 0)
        //var language: ProgramingLanguage?
        while lessonTextIndex <= (lessonText.count - 1) {
            let character = lessonText[lessonTextIndex]
            cache.append(character)
            if cache == "\n" {
                text += "\n"
                templateRange.location += 1
                delegate?.lessonTextParserHandleNewLine(self)
                //newLineHandler?()
                cache.removeAll()
            } else if cache == " " && !cache.hasPrefix("@[@") && !cache.hasPrefix("?[?") && !cache.hasPrefix("#[#") {
                text += " "
                templateRange.location += 1
                delegate?.lessonTextParserHandleSpace(self)
                //spaceHandler?()
                cache.removeAll()
            }
//            else if cache.hasPrefix("@[@") && cache.hasSuffix("@]@") {
//                language = ProgramingLanguage(rawValue: String(cache[3...(cache.count - 4)]))
//                cache.removeAll()
//            }
            else if cache.hasPrefix("?[?") && cache.hasSuffix("?]?") {
                let answer = String(cache[3...(cache.count - 4)])
                let key = "<!--" + String(questionIndex) + "-->"
                text += key
                text += key
                //templateRange.location += (key.count * 2)
                //delegate?.lessonTextParser(self, token: .question, text: answer, language: language)
//                if let l = language {
//                    delegate?.lessonTextParser(self, handleQuestionAt: questionIndex, answer: answer, language: l)
//                    //questionHandler?(answerIndex, answer, language!)
//                }
                delegate?.lessonTextParser(self, handleQuestionAt: questionIndex, answer: answer)
                cache.removeAll()
                questionIndex += 1
            } else if cache.hasPrefix("#[#") && cache.hasSuffix("#]#") {
                let template = String(cache[3...(cache.count - 4)])
                text += template
                templateRange.length = template.count
                //delegate?.lessonTextParser(self, token: .template, text: template, language: language)
//                if let l =  language {
//                    delegate?.lessonTextParser(self, handleTemplateIn: templateRange, template: template, language: l)
//                    //templateHandler?(templateRange, template, language!)
//                }
                delegate?.lessonTextParser(self, handleTemplateIn: templateRange, template: template)
                templateRange.location += templateRange.length
                cache.removeAll()
            }
            lessonTextIndex += 1
        }
        delegate?.lessonTextParser(self, finishedParsing: TextUtils.formatUserTextToPreviewText(text))
        return text
    }
    
}
