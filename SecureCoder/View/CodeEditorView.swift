import UIKit

class CodeEditorView: UIView {
    
    let scrollView = UIScrollView()
    
    var questionDidChangeEventHandler: ((CodeEditorView) -> Void)?
    var questions = [QuestionTextField]()
    var activeQuestion: QuestionTextField? {
        return activeQuestionIndex < questions.count ?  questions[activeQuestionIndex] : nil
    }
    var firstQuestion: QuestionTextField? {
        return questions.first
    }
    var lastQuestion: QuestionTextField? {
        return questions.last
    }
    var isCompleted: Bool {
        return activeQuestion == nil
    }
    
    private(set) var activeQuestionIndex = -1
    
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
            questions[activeQuestionIndex].activate(false)
            questions[activeQuestionIndex].keyboardView.removeFromSuperview()
        }
        activeQuestionIndex += 1
        if activeQuestionIndex <= (questions.count - 1) {
            let question = questions[activeQuestionIndex]
            question.activate(true)
            let keyboardView = question.keyboardView
            addSubview(keyboardView)
            keyboardView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                keyboardView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
                keyboardView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
                ])
            questionDidChangeEventHandler?(self)
        }
    }
    
    private func addSubviews() {
        addSubview(scrollView)
    }
    
    private func setupSubviews() {
        scrollView.frame = safeAreaLayoutGuide.layoutFrame
    }
    
}
