import UIKit

class KeyboardIFrameInjectionUnsafeWelcome0View: KeyboardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let quotation = makeButton()
        quotation.setTitle("\"", for: .normal)
        quotation.setTitleColor(PHP.stringColor, for: .normal)
        quotation.count = 2
        let space = makeButton()
        space.setTitle(" ", for: .normal)
        space.setTitleColor(.white, for: .normal)
        space.count = 1
        let openBracket = makeButton()
        openBracket.setTitle("[", for: .normal)
        openBracket.setTitleColor(.white, for: .normal)
        openBracket.count = 1
        let closeBracket = makeButton()
        closeBracket.setTitle("]", for: .normal)
        closeBracket.setTitleColor(.white, for: .normal)
        closeBracket.count = 1
        let semicolon = makeButton()
        semicolon.setTitle(";", for: .normal)
        semicolon.setTitleColor(.white, for: .normal)
        semicolon.count = 1
        let echo = makeButton()
        echo.setTitle("echo", for: .normal)
        echo.setTitleColor(PHP.reservedWordColor, for: .normal)
        echo.count = 1
        let get = makeButton()
        get.setTitle("$_GET", for: .normal)
        get.setTitleColor(PHP.variableColor, for: .normal)
        get.count = 1
        let name = makeButton()
        name.setTitle("name", for: .normal)
        name.setTitleColor(PHP.stringColor, for: .normal)
        name.count = 1
        alignButtons(groups: [quotation, space], [openBracket, closeBracket, semicolon],
                     [echo, get, name])
    }
    
}
