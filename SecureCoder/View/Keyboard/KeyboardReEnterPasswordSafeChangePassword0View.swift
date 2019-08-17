
import UIKit

class KeyboardReEnterPasswordSafeChangePassword0View: KeyboardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let openBracket = KeyboardView.makeButton()
        openBracket.setTitle("[", for: .normal)
        openBracket.setTitleColor(.white, for: .normal)
        let closeBracket = KeyboardView.makeButton()
        closeBracket.setTitle("]", for: .normal)
        closeBracket.setTitleColor(.white, for: .normal)
        let doubleQuotation = KeyboardView.makeButton()
        doubleQuotation.setTitle("\"", for: .normal)
        doubleQuotation.setTitleColor(PHP.stringColor, for: .normal)
        doubleQuotation.count = 2
        let post = KeyboardView.makeButton()
        post.setTitle("$_POST", for: .normal)
        post.setTitleColor(PHP.variableColor, for: .normal)
        let password = KeyboardView.makeButton()
        password.setTitle("password", for: .normal)
        password.setTitleColor(PHP.stringColor, for: .normal)
        alignButtons(groups: [openBracket, closeBracket, doubleQuotation], [post, password])
    }
    
}
