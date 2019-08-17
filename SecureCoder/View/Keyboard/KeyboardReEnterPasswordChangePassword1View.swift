
import UIKit

class KeyboardReEnterPasswordSafeChangePassword1View: KeyboardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let openParentheses = KeyboardView.makeButton()
        openParentheses.setTitle("(", for: .normal)
        openParentheses.setTitleColor(.white, for: .normal)
        let closeParentheses = KeyboardView.makeButton()
        closeParentheses.setTitle(")", for: .normal)
        closeParentheses.setTitleColor(.white, for: .normal)
        let comma = KeyboardView.makeButton()
        comma.setTitle(",", for: .normal)
        comma.setTitleColor(.white, for: .normal)
        let space = KeyboardView.makeButton()
        space.setTitle(" ", for: .normal)
        let isExists = KeyboardView.makeButton()
        isExists.setTitle("isExists", for: .normal)
        isExists.setTitleColor(PHP.functionColor, for: .normal)
        let id = KeyboardView.makeButton()
        id.setTitle("$id", for: .normal)
        id.setTitleColor(PHP.variableColor, for: .normal)
        let password = KeyboardView.makeButton()
        password.setTitle("$password", for: .normal)
        password.setTitleColor(PHP.variableColor, for: .normal)
        alignButtons(groups: [openParentheses, closeParentheses, comma, space], [isExists], [id, password])
    }
    
}
