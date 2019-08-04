import UIKit

class KeyboardJavaScriptSchemeUnsafeWelcome2View: KeyboardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let entquotes = KeyboardView.makeButton()
        entquotes.setTitle("ENT_QUOTES", for: .normal)
        entquotes.setTitleColor(.white, for: .normal)
        alignButtons(groups: [entquotes])
    }
    
}
