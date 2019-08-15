import UIKit

class KeyboardDynamicColumnSafeBooks0View: KeyboardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let space = KeyboardView.makeButton()
        space.setTitle(" ", for: .normal)
        let comma = KeyboardView.makeButton()
        comma.setTitle(",", for: .normal)
        comma.setTitleColor(.white, for: .normal)
        let openParentheses = KeyboardView.makeButton()
        openParentheses.setTitle("(", for: .normal)
        openParentheses.setTitleColor(.white, for: .normal)
        let closeParentheses = KeyboardView.makeButton()
        closeParentheses.setTitle(")", for: .normal)
        closeParentheses.setTitleColor(.white, for: .normal)
        let sortKey = KeyboardView.makeButton()
        sortKey.setTitle("$sortKey", for: .normal)
        sortKey.setTitleColor(PHP.variableColor, for: .normal)
        let keys = KeyboardView.makeButton()
        keys.setTitle("$keys", for: .normal)
        keys.setTitleColor(PHP.variableColor, for: .normal)
        let inArray = KeyboardView.makeButton()
        inArray.setTitle("in_array", for: .normal)
        inArray.setTitleColor(PHP.functionColor, for: .normal)
        alignButtons(groups: [space, comma, openParentheses, closeParentheses], [sortKey, keys], [inArray])
    }
    
}
