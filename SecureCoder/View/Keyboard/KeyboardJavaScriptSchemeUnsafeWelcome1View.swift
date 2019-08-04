import UIKit

class KeyboardJavaScriptSchemeUnsafeWelcome1View: KeyboardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let htmlspecialchars = KeyboardView.makeButton()
        htmlspecialchars.setTitle("htmlspecialchars", for: .normal)
        htmlspecialchars.setTitleColor(PHP.functionColor, for: .normal)
        alignButtons(groups: [htmlspecialchars])
    }
    
}
