import UIKit

class QuestionTextField: UITextField {
    
    let answer: String
    let language: ProgramingLanguage
    
    let caret = CaretView()
    
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
    
    private func setupSubviews() {
        addSubview(caret)
        caret.frame = CGRect(origin: .zero, size: CGSize(width: 1, height: bounds.height))
        caret.backgroundColor = .turquoiseBlue
    }
    
}
