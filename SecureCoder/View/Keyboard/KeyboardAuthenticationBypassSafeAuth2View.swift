import UIKit

class KeyboardAuthenticationBypassSafeAuth2View: KeyboardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let one = KeyboardView.makeButton()
        one.setTitle("1", for: .normal)
        one.setTitleColor(.white, for: .normal)
        let comma = KeyboardView.makeButton()
        comma.setTitle(",", for: .normal)
        comma.setTitleColor(.white, for: .normal)
        comma.count = 2
        let space = KeyboardView.makeButton()
        space.setTitle(" ", for: .normal)
        space.setTitleColor(.white, for: .normal)
        space.count = 2
        let openParentheses = KeyboardView.makeButton()
        openParentheses.setTitle("(", for: .normal)
        openParentheses.setTitleColor(.white, for: .normal)
        let closeParentheses = KeyboardView.makeButton()
        closeParentheses.setTitle(")", for: .normal)
        closeParentheses.setTitleColor(.white, for: .normal)
        let bindValue = KeyboardView.makeButton()
        bindValue.setTitle("bindValue", for: .normal)
        bindValue.setTitleColor(PHP.functionColor, for: .normal)
        let name = KeyboardView.makeButton()
        name.setTitle("$name", for: .normal)
        name.setTitleColor(PHP.variableColor, for: .normal)
        let pdo = KeyboardView.makeButton()
        pdo.setTitle("PDO", for: .normal)
        pdo.setTitleColor(PHP.classColor, for: .normal)
        let colon = KeyboardView.makeButton()
        colon.setTitle("::", for: .normal)
        colon.setTitleColor(.white, for: .normal)
        let paramStr = KeyboardView.makeButton()
        paramStr.setTitle("PARAM_STR", for: .normal)
        paramStr.setTitleColor(.white, for: .normal)
        alignButtons(groups: [one, comma, space, openParentheses, closeParentheses], [bindValue, name], [pdo, colon, paramStr])
    }
    
}
