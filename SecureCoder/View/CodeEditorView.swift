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
    
    var scrollBuffer: CGSize?
    var drawFunctionHandler: ((CodeEditorView) -> Void)?
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(scrollView)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        scrollView.frame = safeAreaLayoutGuide.layoutFrame
        drawFunctionHandler?(self)
    }
    
    func focus(_ texts: [String]) {
        guard !texts.isEmpty, let components = components else {
            return
        }
        var focusedComponents = [UIView]()
        for component in components {
            guard let labelText = (component as? TemplateLabel)?.text else {
                continue
            }
            if texts.contains(labelText) {
                let borderAnimationDuration: TimeInterval = 1
                let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
                borderWidthAnimation.fromValue = 0
                borderWidthAnimation.toValue = 1
                borderWidthAnimation.duration = borderAnimationDuration
                borderWidthAnimation.isRemovedOnCompletion = false
                borderWidthAnimation.fillMode = .forwards
                component.layer.add(borderWidthAnimation, forKey: "borderWidthAnimation")
                let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
                borderColorAnimation.fromValue = UIColor.clear.cgColor
                borderColorAnimation.toValue = UIColor.red.cgColor
                borderColorAnimation.duration = borderAnimationDuration
                borderColorAnimation.isRemovedOnCompletion = false
                borderColorAnimation.fillMode = .forwards
                component.layer.add(borderColorAnimation, forKey: "borderColorAnimation")
                focusedComponents.append(component)
            }
        }
        for component in components {
            guard !focusedComponents.contains(component) else {
                continue
            }
            component.layer.removeAllAnimations()
            component.layer.borderWidth = 0
            component.layer.borderColor = UIColor.clear.cgColor
        }
        if let firstFocusedComponent = focusedComponents.first {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.scrollView.contentOffset.y = firstFocusedComponent.frame.origin.y
            }, completion: nil)
        }
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
