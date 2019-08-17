import UIKit

class KeyboardTokenSafeChangePassword1View: KeyboardView {
    
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
        let openParentheses = KeyboardView.makeButton()
        openParentheses.setTitle("(", for: .normal)
        openParentheses.setTitleColor(.white, for: .normal)
        let closeParentheses = KeyboardView.makeButton()
        closeParentheses.setTitle(")", for: .normal)
        closeParentheses.setTitleColor(.white, for: .normal)
        let doubleQuotation = KeyboardView.makeButton()
        doubleQuotation.setTitle("\"", for: .normal)
        doubleQuotation.setTitleColor(PHP.stringColor, for: .normal)
        doubleQuotation.count = 2
        let tokenString = KeyboardView.makeButton()
        tokenString.setTitle("token", for: .normal)
        tokenString.setTitleColor(PHP.stringColor, for: .normal)
        let empty = KeyboardView.makeButton()
        empty.setTitle("empty", for: .normal)
        empty.setTitleColor(PHP.functionColor, for: .normal)
        let session = KeyboardView.makeButton()
        session.setTitle("$_SESSION", for: .normal)
        session.setTitleColor(PHP.variableColor, for: .normal)
        alignButtons(groups: [openBracket, closeBracket, openParentheses, closeParentheses], [doubleQuotation, tokenString], [empty, session])
    }
    
}
