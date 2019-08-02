import UIKit

class KeyboardEntQuotesUnsafeWelcome1View: KeyboardView {
    
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
        let semicolon = KeyboardView.makeButton()
        semicolon.setTitle(";", for: .normal)
        semicolon.setTitleColor(.white, for: .normal)
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
        let get = KeyboardView.makeButton()
        get.setTitle("$_GET", for: .normal)
        get.setTitleColor(PHP.variableColor, for: .normal)
        let name = KeyboardView.makeButton()
        name.setTitle("name", for: .normal)
        name.setTitleColor(PHP.stringColor, for: .normal)
        let htmlspecialchars = KeyboardView.makeButton()
        htmlspecialchars.setTitle("htmlspecialchars", for: .normal)
        htmlspecialchars.setTitleColor(PHP.functionColor, for: .normal)
        alignButtons(groups: [quotation, semicolon], [openParenthesis, closeParenthesis, openBracket, closeBracket], [get, name, htmlspecialchars])
    }
    
}
