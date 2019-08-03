import UIKit

class KeyboardEntQuotesUnsafeWelcome2View: KeyboardView {
    
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
        quotation.setTitle("'", for: .normal)
        quotation.setTitleColor(PHP.stringColor, for: .normal)
        alignButtons(groups: [quotation])
    }
    
}
