import UIKit

class KeyboardAuthenticationBypassSafeAuth0View: KeyboardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let name = KeyboardView.makeButton()
        name.setTitle("name", for: .normal)
        name.setTitleColor(PHP.stringColor, for: .normal)
        let equal = KeyboardView.makeButton()
        equal.setTitle("=", for: .normal)
        equal.setTitleColor(PHP.stringColor, for: .normal)
        let question = KeyboardView.makeButton()
        question.setTitle("?", for: .normal)
        question.setTitleColor(PHP.stringColor, for: .normal)
        alignButtons(groups: [name, equal, question])
    }
    
}
