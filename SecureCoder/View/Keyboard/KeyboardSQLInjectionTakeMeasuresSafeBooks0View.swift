import UIKit

class KeyboardSQLInjectionTakeMeasuresSafeBook0View: KeyboardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let author = KeyboardView.makeButton()
        author.setTitle("author", for: .normal)
        author.setTitleColor(PHP.stringColor, for: .normal)
        let equal = KeyboardView.makeButton()
        equal.setTitle("=", for: .normal)
        equal.setTitleColor(PHP.stringColor, for: .normal)
        let question = KeyboardView.makeButton()
        question.setTitle("?", for: .normal)
        question.setTitleColor(PHP.stringColor, for: .normal)
        alignButtons(groups: [author, equal, question])
    }
    
    
}
