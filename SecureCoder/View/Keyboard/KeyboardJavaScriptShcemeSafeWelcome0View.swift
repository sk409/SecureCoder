import UIKit

class KeyboardJavaScriptSchemeSafeWelcome0View: KeyboardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let checkurl = KeyboardView.makeButton()
        checkurl.setTitle("check_url", for: .normal)
        checkurl.setTitleColor(PHP.functionColor, for: .normal)
        alignButtons(groups: [checkurl])
    }
    
}
