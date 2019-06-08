import UIKit

struct EditorComponentsBuilder {
    
    func build(pointer: CGRect, font: UIFont, tintColor: UIColor, lessonText: String) -> [UIView] {
        var views = [UIView]()
        var pointer = pointer
        let newLineHandler = {
            let lineMargin: CGFloat = 5
            pointer = CGRect(x: 0, y: pointer.origin.y + pointer.height + lineMargin, width: 0, height: 0)
        }
        let spaceHandler = {
            let spaceSize = " ".size(withAttributes: [.font: font])
            pointer = CGRect(
                x: pointer.origin.x + pointer.width,
                y: pointer.origin.y,
                width: spaceSize.width,
                height: spaceSize.height
            )
        }
        let questionHandler: (String, ProgramingLanguage) -> Void = { answer, language in
            let question = QuestionTextField(answer: answer, language: language)
            //scrollView.addSubview(question)
            //questions.append(question)
            question.caret.alpha = 0
            question.inputView = UIView()
            question.isUserInteractionEnabled = false
            question.textColor = .white
            question.font = font
            question.backgroundColor = .clear
            question.layer.borderColor = UIColor.white.cgColor
            question.layer.borderWidth = 0.5
            //        question.addTarget(self, action: #selector(handleQuestionTextFieldEditingChangedEvent(_:)), for: .editingChanged)
            let size = answer.size(withAttributes: [.font: font])
            let x = pointer.origin.x + pointer.width + 5
            let y = pointer.origin.y
            question.frame = CGRect(x: x, y: y, width: size.width, height: size.height + 5)
            views.append(question)
            pointer = question.frame
        }
        let templateHandler: (String, ProgramingLanguage) -> Void = { text, language in
            let template = UILabel()
            //scrollView.addSubview(template)
            template.backgroundColor = .clear
            template.numberOfLines = 0
            template.attributedText = SyntaxHighlighter.decorate(text, defaultColor: tintColor, font: font, language: language)
            let size = text.size(withAttributes: [.font: font])
            let x = pointer.origin.x + pointer.width + 5
            let y = pointer.origin.y
            template.frame = CGRect(x: x, y: y, width: size.width, height: size.height + 5)
            views.append(template)
            pointer = template.frame
        }
        var parser = LessonTextParser()
        parser.newLineHandler = newLineHandler
        parser.spaceHandler = spaceHandler
        parser.questionHandler = questionHandler
        parser.templateHandler = templateHandler
        _ = parser.parse(lessonText)
        return views
    }
    
//    private mutating func addQuestion(answer: String, language: ProgramingLanguage) {
//        let question = QuestionTextField(answer: answer, language: language)
//        //scrollView.addSubview(question)
//        //questions.append(question)
//        question.caret.alpha = 0
//        question.inputView = UIView()
//        question.isUserInteractionEnabled = false
//        question.textColor = .white
//        question.font = font
//        question.backgroundColor = .clear
//        question.layer.borderColor = UIColor.white.cgColor
//        question.layer.borderWidth = 0.5
////        question.addTarget(self, action: #selector(handleQuestionTextFieldEditingChangedEvent(_:)), for: .editingChanged)
//        let size = answer.size(withAttributes: [.font: font!])
//        let x = pointer.origin.x + pointer.width + 5
//        let y = pointer.origin.y
//        question.frame = CGRect(x: x, y: y, width: size.width, height: size.height + 5)
//        views.append(question)
//        pointer = question.frame
//    }
    
//    private mutating func addTemplate(text: String, language: ProgramingLanguage) {
//        let template = UILabel()
//        //scrollView.addSubview(template)
//        template.backgroundColor = .clear
//        template.numberOfLines = 0
//        template.attributedText = SyntaxHighlighter.decorate(text, defaultColor: tintColor, font: font, language: language)
//        let size = text.size(withAttributes: [.font: font!])
//        let x = pointer.origin.x + pointer.width + 5
//        let y = pointer.origin.y
//        template.frame = CGRect(x: x, y: y, width: size.width, height: size.height + 5)
//        pointer = template.frame
//    }
    
//    private mutating func addNewLine() {
//        let lineMargin: CGFloat = 5
//        pointer = CGRect(x: 0, y: pointer.origin.y + pointer.height + lineMargin, width: 0, height: 0)
//    }
    
//    private mutating func addSpace() {
//        let spaceSize = " ".size(withAttributes: [.font: font!])
//        pointer = CGRect(
//            x: pointer.origin.x + pointer.width,
//            y: pointer.origin.y,
//            width: spaceSize.width,
//            height: spaceSize.height
//        )
//    }
    
}

//extension EditorComponentsBuilder: LessonTextParserDelegate {
//    
//    func lessonTextParser(_ lessonTextParser: LessonTextParser, token: LessonTextParser.Token, text: String, language: ProgramingLanguage?) {
//        guard let language = language else {
//            return
//        }
//        switch token {
//        case .newLine:
//            addNewLine()
//        case .space:
//            addSpace()
//        case .question:
//            addQuestion(answer: text, language: language)
//        case .template:
//            addTemplate(text: text, language: language)
//        }
//    }
//    
//}
