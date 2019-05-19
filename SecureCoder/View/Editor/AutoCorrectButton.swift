import UIKit

class AutoCorrectButton: UIButton {
    
    let replacementWord: String
    
    init(word: String, replacementWord: String, color: UIColor) {
        self.replacementWord = replacementWord
        super.init(frame: .zero)
        setTitle(word, for: .normal)
        setTitleColor(color, for: .normal)
        backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
