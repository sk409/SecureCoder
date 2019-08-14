import UIKit

class KeyboardAuthenticationBypassUnsafeAuth0View: KeyboardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let singleQuotation = KeyboardView.makeButton()
        singleQuotation.setTitle("'", for: .normal)
        singleQuotation.setTitleColor(PHP.stringColor, for: .normal)
        singleQuotation.count = 2
        let name = KeyboardView.makeButton()
        name.setTitle("$name", for: .normal)
        name.setTitleColor(PHP.variableColor, for: .normal)
        alignButtons(groups: [singleQuotation, name])
    }
    
}
