import UIKit

class KeyboardFalsifyFormSafeApply0View: KeyboardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let quotation = KeyboardView.makeButton()
        quotation.setTitle("\"", for: .normal)
        quotation.setTitleColor(PHP.stringColor, for: .normal)
        quotation.count = 2
        let space = KeyboardView.makeButton()
        space.setTitle(" ", for: .normal)
        space.setTitleColor(.white, for: .normal)
        space.count = 2
        let comma = KeyboardView.makeButton()
        comma.setTitle(",", for: .normal)
        comma.setTitleColor(.white, for: .normal)
        let openParenthesis = KeyboardView.makeButton()
        openParenthesis.setTitle("(", for: .normal)
        openParenthesis.setTitleColor(.white, for: .normal)
        let closeParenthesis = KeyboardView.makeButton()
        closeParenthesis.setTitle(")", for: .normal)
        closeParenthesis.setTitleColor(.white, for: .normal)
        let openBracket = KeyboardView.makeButton()
        openBracket.setTitle("[", for: .normal)
        openBracket.setTitleColor(.white, for: .normal)
        let closeBracket = KeyboardView.makeButton()
        closeBracket.setTitle("]", for: .normal)
        closeBracket.setTitleColor(.white, for: .normal)
        let semicolon = KeyboardView.makeButton()
        semicolon.setTitle(";", for: .normal)
        semicolon.setTitleColor(.white, for: .normal)
        let echo = KeyboardView.makeButton()
        echo.setTitle("echo", for: .normal)
        echo.setTitleColor(PHP.reservedWordColor, for: .normal)
        let post = KeyboardView.makeButton()
        post.setTitle("$_POST", for: .normal)
        post.setTitleColor(PHP.variableColor, for: .normal)
        let name = KeyboardView.makeButton()
        name.setTitle("name", for: .normal)
        name.setTitleColor(PHP.stringColor, for: .normal)
        let htmlspecialchars = KeyboardView.makeButton()
        htmlspecialchars.setTitle("htmlspecialchars", for: .normal)
        htmlspecialchars.setTitleColor(PHP.functionColor, for: .normal)
        let entquotes = KeyboardView.makeButton()
        entquotes.setTitle("ENT_QUOTES", for: .normal)
        entquotes.setTitleColor(.white, for: .normal)
        alignButtons(groups: [quotation, space, comma, semicolon], [openParenthesis, closeParenthesis, openBracket, closeBracket], [echo, post, name], [htmlspecialchars, entquotes])
    }
    
}
