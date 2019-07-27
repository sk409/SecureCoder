import UIKit

class EditorComponentsBuilder {
    
    private var font: UIFont?
    private var tintColor: UIColor?
    private var programingLanguage: ProgramingLanguage?
    private var line = 1
    private var pointer = CGRect()
    private var views = [UIView]()
    
    func build(origin: CGPoint, font: UIFont, tintColor: UIColor, text: String, language: ProgramingLanguage) -> [UIView] {
        self.pointer.origin = origin
        self.pointer.size = .zero
        self.font = font
        self.tintColor = tintColor
        self.programingLanguage = language
        line = 1
        views = []
        var parser = LessonTextParser()
        parser.delegate = self
        _ = parser.parse(text, language: language)
        return views
    }
    
}

extension EditorComponentsBuilder: LessonTextParserDelegate {
    
    func lessonTextParserHandleNewLine(_ lessonTextParser: LessonTextParser) {
//        guard let pointer = pointer else {
//            return
//        }
        line += 1
        let lineMargin: CGFloat = 5
        self.pointer = CGRect(x: 0, y: pointer.origin.y + pointer.height + lineMargin, width: 0, height: 0)
    }
    
    func lessonTextParserHandleSpace(_ lessonTextParser: LessonTextParser) {
        guard let font = font//,
              //let pointer = pointer
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
        guard //let pointer = pointer,
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
        guard //let pointer = pointer,
              let font = font
        else {
            return
        }
        let templateLabel = TemplateLabel()
        templateLabel.backgroundColor = .clear
        templateLabel.numberOfLines = 0
        templateLabel.text = template
        templateLabel.range = range
        templateLabel.line = line
        let size = template.size(withAttributes: [.font: font])
        let x = pointer.origin.x + pointer.width
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
        var syntaxHighlighter = SyntaxHighlighter(tintColor: tintColor, font: font)
        syntaxHighlighter.programingLanguage = programingLanguage
        let attributedText = syntaxHighlighter.syntaxHighlight(planeText)
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
