import UIKit

class QuestionTextField: UITextField {
    
    let answer: String
    let language: ProgramingLanguage
    
    init(answer: String, language: ProgramingLanguage) {
        self.answer = answer
        self.language = language
        super.init(frame: .zero)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
