import UIKit

class QuestionTextField: UITextField {
    
    weak var editorView: CodeEditorView?
    
    let answer: String
    let language: ProgramingLanguage
    
    let caret = CaretView()
    
    var isCompleted: Bool {
        return text == answer
    }
    
    init(answer: String, language: ProgramingLanguage) {
        self.answer = answer
        self.language = language
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupSubviews()
    }
    
    func activate(_ active: Bool) {
        if active {
            caret.alpha = 1
            caret.startAnimation()
            isUserInteractionEnabled = true
        } else {
            caret.alpha = 0
            caret.stopAnimation()
            isUserInteractionEnabled = false
        }
    }
    
    private func setupSubviews() {
        addSubview(caret)
        caret.frame = CGRect(origin: caret.frame.origin, size: CGSize(width: 1, height: bounds.height))
        caret.backgroundColor = .turquoiseBlue
    }
    
}
