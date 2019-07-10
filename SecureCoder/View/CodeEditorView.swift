import UIKit

class CodeEditorView: UIView {
    
    var components: [UIView]? {
        didSet {
            questions = []
            templates = []
            scrollView.contentOffset = CGPoint(x: CGFloat.infinity, y: .infinity)
            components?.forEach { component in
                scrollView.addSubview(component)
                scrollView.contentOffset = CGPoint(
                    x: min(scrollView.contentOffset.x, component.frame.origin.x),
                    y: min(scrollView.contentOffset.y, component.frame.origin.y)
                )
                scrollView.contentSize = CGSize(
                    width: max(scrollView.contentSize.width, component.frame.maxX),
                    height: max(scrollView.contentSize.height, component.frame.maxY)
                )
                if let questionTextField = component as? QuestionTextField {
                    self.questions?.append(questionTextField)
                } else if let templateLabel = component as? TemplateLabel {
                    self.templates?.append(templateLabel)
                }
            }
            if let scrollBuffer = scrollBuffer {
                scrollView.contentSize.width += scrollBuffer.width
                scrollView.contentSize.height += scrollBuffer.height
            }
        }
    }
    
    var file: File?
    var scrollBuffer: CGSize?
    var drawFunctionHandler: ((CodeEditorView) -> Void)?
    
    var text: String {
        guard let components = components else {
            return ""
        }
        var text = ""
        for component in components {
            if let templateLabel = (component as? TemplateLabel), let labelText = templateLabel.text {
                text += labelText
            } else if let questionTextField = (component as? QuestionTextField),
                let textFieldText = questionTextField.text
            {
                text += textFieldText
            }
        }
        return text
    }
    
    let scrollView = UIScrollView()
    
    private(set) var question: QuestionTextField? {
        willSet {
            question?.activate(isActive: false, keyboardViewDidShow: nil, keyboardViewDidHide: nil)
        }
        didSet {
            question?.activate(isActive: true, keyboardViewDidShow: nil, keyboardViewDidHide: nil)
        }
    }
    private(set) var questions: [QuestionTextField]?
    private(set) var templates: [TemplateLabel]?
    
    private var focusableViews = [FocusableView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawFunctionHandler?(self)
    }
    
    func focus(labelTexts: [String], componentIndices: [[Int]]) {
        guard let components = components else {
            return
        }
        var focusedViews = [UIView]()
        for component in components {
            guard let templateLabel = component as? TemplateLabel,
                  let labelText = templateLabel.text
            else {
                continue
            }
            if labelTexts.contains(labelText) {
                templateLabel.focus(with: 1, borderWidth: 1, borderColor: UIColor.red.cgColor, backgroundColor: .white)
                focusedViews.append(component)
            }
        }
        for component in components {
            guard let templateLabel = component as? TemplateLabel,
                  !focusedViews.contains(component) else {
                continue
            }
            templateLabel.unfocus(with: 1)
        }
        for componentIndexArray in componentIndices {
            let focusableView = FocusableView()
            scrollView.addSubview(focusableView)
            focusableViews.append(focusableView)
            focusedViews.append(focusableView)
            focusableView.frame.origin = CGPoint(x: CGFloat.infinity, y: .infinity)
            for componentIndex in componentIndexArray {
                focusableView.frame.origin.x = min(focusableView.frame.origin.x, components[componentIndex].frame.origin.x)
                focusableView.frame.origin.y = min(focusableView.frame.origin.y,
                                                   components[componentIndex].frame.origin.y)
            }
            for componentIndex in componentIndexArray {
                focusableView.frame.size.width = max(focusableView.bounds.size.width, components[componentIndex].frame.maxX)
                focusableView.frame.size.height = max(focusableView.bounds.size.height,
                                                      components[componentIndex].frame.maxY)
            }
            focusableView.frame.size.width -= focusableView.frame.origin.x
            focusableView.frame.size.height -= focusableView.frame.origin.y
            let buffer = CGSize(width: 0, height: 10)
            focusableView.frame.origin.x -= buffer.width / 2
            focusableView.frame.origin.y -= buffer.height / 2
            focusableView.frame.size.width += buffer.width
            focusableView.frame.size.height += buffer.height
            focusableView.focus(with: 1, borderWidth: 1, borderColor: UIColor.red.cgColor, backgroundColor: .white)
        }
        var topFocusedView: UIView?
        var minY = CGFloat.infinity
        for focusedView in focusedViews {
            if focusedView.frame.origin.y < minY {
                minY = focusedView.frame.origin.y
                topFocusedView = focusedView
            }
        }
        if let tfv = topFocusedView {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.scrollView.contentOffset.y = tfv.frame.origin.y
            }, completion: nil)
        }
    }
    
    func removeAllFocusableViews() {
        focusableViews.forEach { $0.removeFromSuperview() }
    }
    
    func scroll(to component: UIView?) {
        guard let component = component, let components = components, components.contains(component) else {
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.scrollView.contentOffset.y = component.frame.origin.y
        }, completion: nil)
    }
    
    func setNextQuestion() {
        if let question = question, let questions = questions, let questionIndex = questions.firstIndex(of: question) {
            let nextQuestionIndex = (questionIndex + 1)
            self.question = (nextQuestionIndex < questions.count) ? questions[nextQuestionIndex] : nil
        } else {
            self.question = self.questions?.first
        }
    }
    
    func range(of componentView: UIView) -> NSRange? {
        guard let components = components,
            components.contains(componentView) else {
            return nil
        }
        var range = NSRange(location: 0, length: 0)
        for component in components {
            var componentText = ""
            if let templateLabel = (component as? TemplateLabel), let labelText = templateLabel.text {
                componentText = labelText
            } else if let questionTextField = (component as? QuestionTextField), let textFieldText = questionTextField.text
            {
                componentText = textFieldText
            }
            range = NSRange(location: range.location + range.length, length: componentText.count)
            if component == componentView {
                break
            }
        }
        return range
    }
    
    private func setupViews() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
//    var questionDidChangeEventHandler: ((CodeEditorView) -> Void)?
//    var questions = [QuestionTextField]()
//    var activeQuestion: QuestionTextField? {
//        return activeQuestionIndex < questions.count ?  questions[activeQuestionIndex] : nil
//    }
//    var firstQuestion: QuestionTextField? {
//        return questions.first
//    }
//    var lastQuestion: QuestionTextField? {
//        return questions.last
//    }
//    var isCompleted: Bool {
//        return activeQuestion == nil
//    }
//
//    private(set) var activeQuestionIndex = -1
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubviews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        addSubviews()
//    }
//
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        setupSubviews()
//    }
//
//    func setNextQuestion() {
//        if 0 <= activeQuestionIndex && activeQuestionIndex <= (questions.count - 1) {
//            questions[activeQuestionIndex].activate(false)
//            questions[activeQuestionIndex].keyboardView.removeFromSuperview()
//        }
//        activeQuestionIndex += 1
//        if activeQuestionIndex <= (questions.count - 1) {
//            let question = questions[activeQuestionIndex]
//            question.activate(true)
//            let keyboardView = question.keyboardView
//            addSubview(keyboardView)
//            keyboardView.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                keyboardView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
//                keyboardView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
//                ])
//            questionDidChangeEventHandler?(self)
//        }
//    }
//
//    private func addSubviews() {
//        addSubview(scrollView)
//    }
//
//    private func setupSubviews() {
//        scrollView.frame = safeAreaLayoutGuide.layoutFrame
//    }
    
}
