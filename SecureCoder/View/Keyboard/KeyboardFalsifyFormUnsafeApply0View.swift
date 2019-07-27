import UIKit

class KeyboardFalsifyFormUnsafeApply0View: KeyboardView {
    
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
        alignButtons(groups: [quotation, space], [openBracket, closeBracket, semicolon],
                     [echo, post, name])
    }
    
}
