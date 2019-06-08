import UIKit

class CodeEditorView: UIView {
    
    var font = UIFont.systemFont(ofSize: 16)
    var textColor = UIColor.white
    
    var lessonText: String? {
        didSet {
            parseText()
            setNextQuestion()
        }
    }
    
    var activeQuestion: QuestionTextField? {
        return activeQuestionIndex <= (questions.count - 1) ? questions[activeQuestionIndex] : nil
    }
    
    let scrollView = UIScrollView()
    
    private(set) var questions = [QuestionTextField]()
    private(set) var activeQuestionIndex = -1
    
    private var pointer = CGRect.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupSubviews()
    }
    
    func setNextQuestion() {
        if 0 <= activeQuestionIndex && activeQuestionIndex <= (questions.count - 1) {
            questions[activeQuestionIndex].caret.alpha = 0
        }
        activeQuestionIndex += 1
        if activeQuestionIndex <= (questions.count - 1) {
            questions[activeQuestionIndex].caret.alpha = 1
        }
    }
    
    private func addSubviews() {
        addSubview(scrollView)
    }
    
    private func setupSubviews() {
        scrollView.frame = safeAreaLayoutGuide.layoutFrame
    }
    
    private func parseText() {
        
        guard let lessonText = lessonText else {
            return
        }
        pointer = CGRect(x: safeAreaInsets.left, y: safeAreaInsets.top, width: 0, height: 0)
        let parser = LessonTextParser(delegate: self)
        _ = parser.parse(lessonText)
        
        
        
//        var language: ProgramingLanguage?
//        let updateContentSize: () -> Void = {
//            self.scrollView.contentSize.width = max(self.scrollView.contentSize.width, pointer.origin.x + pointer.width)
//            self.scrollView.contentSize.height = max(self.scrollView.contentSize.height, pointer.origin.y + pointer.height)
//        }
//        while index <= (lessonText.count - 1) {
//            let character = lessonText[index]
//            cache.append(character)
//            if cache == "\n" {
//                pointer = addNewLine(pointer: pointer)
//                updateContentSize()
//                cache.removeAll()
//            } else if cache == " " && !cache.hasPrefix("@[@") && !cache.hasPrefix("?[?") && !cache.hasPrefix("#[#") {
//                pointer = addSpace(pointer: pointer)
//                updateContentSize()
//                cache.removeAll()
//            } else if cache.hasPrefix("@[@") && cache.hasSuffix("@]@") {
//                language = ProgramingLanguage(rawValue: String(cache[3...(cache.count - 4)]))
//                cache.removeAll()
//            } else if cache.hasPrefix("?[?") && cache.hasSuffix("?]?") {
//                pointer = addQuestion(answer: String(cache[3...(cache.count - 4)]), index: answerIndex, language: language!, pointer: pointer)
//                answerIndex += 1
//                updateContentSize()
//                cache.removeAll()
//            } else if cache.hasPrefix("#[#") && cache.hasSuffix("#]#") {
//                pointer = addTemplate(text: String(cache[3...(cache.count - 4)]), language: language!, pointer: pointer)
//                updateContentSize()
//                cache.removeAll()
//            }
//            index += 1
//        }
    }
    
    private func addQuestion(answer: String, language: ProgramingLanguage) {
        let question = QuestionTextField(answer: answer, language: language)
        scrollView.addSubview(question)
        questions.append(question)
        question.caret.alpha = 0
        question.inputView = UIView()
        question.isUserInteractionEnabled = false
        question.textColor = .white
        question.font = font
        question.backgroundColor = .clear
        question.layer.borderColor = UIColor.white.cgColor
        question.layer.borderWidth = 0.5
        question.addTarget(self, action: #selector(handleQuestionTextFieldEditingChangedEvent(_:)), for: .editingChanged)
        let size = answer.size(withAttributes: [.font: font])
        let x = pointer.origin.x + pointer.width + 5
        let y = pointer.origin.y
        question.frame = CGRect(x: x, y: y, width: size.width, height: size.height + 5)
        pointer = question.frame
    }
    
    private func addTemplate(text: String, language: ProgramingLanguage) {
        let template = UILabel()
        scrollView.addSubview(template)
        template.backgroundColor = .clear
        template.numberOfLines = 0
        template.attributedText = SyntaxHighlighter.decorate(text, defaultColor: textColor, font: font, language: language)
        let size = text.size(withAttributes: [.font: font])
        let x = pointer.origin.x + pointer.width + 5
        let y = pointer.origin.y
        template.frame = CGRect(x: x, y: y, width: size.width, height: size.height + 5)
        pointer = template.frame
    }
    
    private func addNewLine() {
        let lineMargin: CGFloat = 5
        pointer = CGRect(x: 0, y: pointer.origin.y + pointer.height + lineMargin, width: 0, height: 0)
    }
    
    private func addSpace() {
        let spaceSize = " ".size(withAttributes: [.font: font])
        pointer = CGRect(
            x: pointer.origin.x + pointer.width,
            y: pointer.origin.y,
            width: spaceSize.width,
            height: spaceSize.height
        )
    }
    
    @objc
    private func handleQuestionTextFieldEditingChangedEvent(_ question: QuestionTextField) {
        guard question.markedTextRange == nil else {
            return
        }
        question.attributedText = SyntaxHighlighter.decorate(question.text, defaultColor: textColor, font: font, language: question.language)
        let textSize = question.text?.size(withAttributes: [.font: font]) ?? .zero
        question.caret.frame.origin.x = textSize.width
    }
    
}

extension CodeEditorView: LessonTextParserDelegate {
    
    func lessonTextParser(_ lessonTextParser: LessonTextParser, token: LessonTextParser.Token, text: String, language: ProgramingLanguage?) {
        guard let language = language else {
            return
        }
        switch token {
        case .newLine:
            addNewLine()
        case .space:
            addSpace()
        case .question:
            addQuestion(answer: text, language: language)
        case .template:
            addTemplate(text: text, language: language)
        }
    }
    
}
