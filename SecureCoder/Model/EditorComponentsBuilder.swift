import UIKit

class EditorComponentsBuilder {
    
    private var pointer: CGRect?
    private var font: UIFont?
    private var tintColor: UIColor?
    private var programingLanguage: ProgramingLanguage?
    
    private var views = [UIView]()
    
    func build(pointer: CGRect, font: UIFont, tintColor: UIColor, lessonText: String, language: ProgramingLanguage) -> [UIView] {
        self.pointer = pointer
        self.font = font
        self.tintColor = tintColor
        self.programingLanguage = language
//        var views = [UIView]()
//        var pointer = pointer
//        let newLineHandler = {
//            let lineMargin: CGFloat = 5
//            pointer = CGRect(x: 0, y: pointer.origin.y + pointer.height + lineMargin, width: 0, height: 0)
//        }
//        let spaceHandler = {
//            let spaceSize = " ".size(withAttributes: [.font: font])
//            pointer = CGRect(
//                x: pointer.origin.x + pointer.width,
//                y: pointer.origin.y,
//                width: spaceSize.width,
//                height: spaceSize.height
//            )
//        }
//        let questionHandler: (Int, String, ProgramingLanguage) -> Void = { questionIndex, answer, language in
//            let question = QuestionTextField(index: questionIndex, answer: answer, language: language)
//            question.caret.alpha = 0
//            question.inputView = UIView()
//            question.isUserInteractionEnabled = false
//            question.textColor = .white
//            question.font = font
//            question.backgroundColor = .clear
//            question.layer.borderColor = UIColor.white.cgColor
//            question.layer.borderWidth = 0.5
//            let size = answer.size(withAttributes: [.font: font])
//            let x = pointer.origin.x + pointer.width + 5
//            let y = pointer.origin.y
//            question.frame = CGRect(x: x, y: y, width: size.width, height: size.height + 5)
//            views.append(question)
//            pointer = question.frame
//        }
//        let templateHandler: (NSRange, String, ProgramingLanguage) -> Void = { range, text, language in
//            let template = TemplateLabel()
//            template.backgroundColor = .clear
//            template.numberOfLines = 0
//            template.attributedText = SyntaxHighlighter.decorate(text, tintColor: tintColor, font: font, language: language)
//            template.range = range
//            let size = text.size(withAttributes: [.font: font])
//            let x = pointer.origin.x + pointer.width + 5
//            let y = pointer.origin.y
//            template.frame = CGRect(x: x, y: y, width: size.width, height: size.height + 5)
//            views.append(template)
//            pointer = template.frame
//        }
        var parser = LessonTextParser()
        parser.delegate = self
//        parser.newLineHandler = newLineHandler
//        parser.spaceHandler = spaceHandler
//        parser.questionHandler = questionHandler
//        parser.templateHandler = templateHandler
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

extension EditorComponentsBuilder: LessonTextParserDelegate {
    
    func lessonTextParserHandleNewLine(_ lessonTextParser: LessonTextParser) {
        guard let pointer = pointer else {
            return
        }
        let lineMargin: CGFloat = 5
        self.pointer = CGRect(x: 0, y: pointer.origin.y + pointer.height + lineMargin, width: 0, height: 0)
    }
    
    func lessonTextParserHandleSpace(_ lessonTextParser: LessonTextParser) {
        guard let font = font,
              let pointer = pointer
        else {
                return
        }
        let spaceSize = " ".size(withAttributes: [.font: font])
        self.pointer = CGRect(
            x: pointer.origin.x + pointer.width,
            y: pointer.origin.y,
            width: spaceSize.width,
            height: spaceSize.height
        )
    }
    
    func lessonTextParser(_ lessonTextParser: LessonTextParser, handleQuestionAt index: Int, answer: String) {
        guard let pointer = pointer,
              let font = font,
              let programingLanguage = programingLanguage
        else {
            return
        }
        let question = QuestionTextField(index: index, answer: answer, language: programingLanguage)
        question.caret.alpha = 0
        question.inputView = UIView()
        question.isUserInteractionEnabled = false
        question.textColor = .white
        question.font = font
        question.backgroundColor = .clear
        question.layer.borderColor = UIColor.white.cgColor
        question.layer.borderWidth = 0.5
        let size = answer.size(withAttributes: [.font: font])
        let x = pointer.origin.x + pointer.width + 5
        let y = pointer.origin.y
        question.frame = CGRect(x: x, y: y, width: size.width, height: size.height + 5)
        views.append(question)
        self.pointer = question.frame
    }
    
    func lessonTextParser(_ lessonTextParser: LessonTextParser, handleTemplateIn range: NSRange, template: String) {
        guard let pointer = pointer,
              let font = font
        else {
            return
        }
        let templateLabel = TemplateLabel()
        templateLabel.backgroundColor = .clear
        templateLabel.numberOfLines = 0
        templateLabel.range = range
        templateLabel.text = template
        let size = template.size(withAttributes: [.font: font])
        let x = pointer.origin.x + pointer.width + 5
        let y = pointer.origin.y
        templateLabel.frame = CGRect(x: x, y: y, width: size.width, height: size.height + 5)
        views.append(templateLabel)
        self.pointer = templateLabel.frame
    }
    
    func lessonTextParser(_ lessonTextParser: LessonTextParser, finishedParsing planeText: String) {
        guard let tintColor = tintColor,
              let font = font,
              let programingLanguage = programingLanguage
        else {
            return
        }
        let attributedText = SyntaxHighlighter.decorate(planeText, tintColor: tintColor, font: font, language: programingLanguage)
        for view in views {
            guard let templateLabel = view as? TemplateLabel,
                  let range = templateLabel.range
            else {
                continue
            }
            templateLabel.attributedText = attributedText.attributedSubstring(from: range)
        }
    }
    
    
    
    
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
