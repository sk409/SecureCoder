import UIKit

class KeyboardDynamicColumnUnsafeBooks0View: KeyboardView {
    
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
        space.count = 2
        let sortKey = KeyboardView.makeButton()
        sortKey.setTitle("$sortKey", for: .normal)
        sortKey.setTitleColor(PHP.variableColor, for: .normal)
        let order = KeyboardView.makeButton()
        order.setTitle("ORDER", for: .normal)
        order.setTitleColor(SQL.keywordColor, for: .normal)
        let by = KeyboardView.makeButton()
        by.setTitle("BY", for: .normal)
        by.setTitleColor(SQL.keywordColor, for: .normal)
        alignButtons(groups: [space, sortKey], [order, by])
    }
    
}
