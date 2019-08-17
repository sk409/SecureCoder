import UIKit

class KeyboardTokenSafeChangePassword0View: KeyboardView {
    
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
        let space = KeyboardView.makeButton()
        space.setTitle(" ", for: .normal)
        space.setTitleColor(.white, for: .normal)
        space.count = 2
        let tokenString = KeyboardView.makeButton()
        tokenString.setTitle("token", for: .normal)
        tokenString.setTitleColor(PHP.stringColor, for: .normal)
        let notEqual = KeyboardView.makeButton()
        notEqual.setTitle("!==", for: .normal)
        notEqual.setTitleColor(.white, for: .normal)
        let token = KeyboardView.makeButton()
        token.setTitle("$token", for: .normal)
        token.setTitleColor(PHP.variableColor, for: .normal)
        let session = KeyboardView.makeButton()
        session.setTitle("$_SESSION", for: .normal)
        session.setTitleColor(PHP.variableColor, for: .normal)
        alignButtons(groups: [openBracket, closeBracket, doubleQuotation, space], [tokenString, notEqual], [token, session])
    }
    
}
