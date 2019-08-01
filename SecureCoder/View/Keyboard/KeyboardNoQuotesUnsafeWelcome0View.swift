import UIKit

class KeyboardNoQuotesUnsafeWelcome0View: KeyboardView {
    
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
        space.count = 4
        let comma = KeyboardView.makeButton()
        comma.setTitle(",", for: .normal)
        comma.setTitleColor(.white, for: .normal)
        let semicolon = KeyboardView.makeButton()
        semicolon.setTitle(";", for: .normal)
        semicolon.setTitleColor(.white, for: .normal)
        let equal = KeyboardView.makeButton()
        equal.setTitle("=", for: .normal)
        equal.setTitleColor(.white, for: .normal)
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
        let echo = KeyboardView.makeButton()
        echo.setTitle("echo", for: .normal)
        echo.setTitleColor(PHP.reservedWordColor, for: .normal)
        let get = KeyboardView.makeButton()
        get.setTitle("$_GET", for: .normal)
        get.setTitleColor(PHP.variableColor, for: .normal)
        let value = KeyboardView.makeButton()
        value.setTitle("value", for: .normal)
        value.setTitleColor(PHP.attributeColor, for: .normal)
        let name = KeyboardView.makeButton()
        name.setTitle("name", for: .normal)
        name.setTitleColor(PHP.stringColor, for: .normal)
        let openPHP = KeyboardView.makeButton()
        openPHP.setTitle("<?php", for: .normal)
        openPHP.setTitleColor(PHP.tagColor, for: .normal)
        let closePHP = KeyboardView.makeButton()
        closePHP.setTitle("?>", for: .normal)
        closePHP.setTitleColor(PHP.tagColor, for: .normal)
        let htmlspecialchars = KeyboardView.makeButton()
        htmlspecialchars.setTitle("htmlspecialchars", for: .normal)
        htmlspecialchars.setTitleColor(PHP.functionColor, for: .normal)
        let entquotes = KeyboardView.makeButton()
        entquotes.setTitle("ENT_QUOTES", for: .normal)
        entquotes.setTitleColor(.white, for: .normal)
        alignButtons(groups: [quotation, space, comma, semicolon, equal], [openParenthesis, closeParenthesis, openBracket, closeBracket], [echo, get, value, name, openPHP, closePHP], [htmlspecialchars, entquotes])
    }
    
}
