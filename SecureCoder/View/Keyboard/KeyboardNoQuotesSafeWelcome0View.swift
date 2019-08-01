import UIKit

class KeyboardNoQuotesSafeWelcome0View: KeyboardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let quotes = KeyboardView.makeButton()
        quotes.setTitle("\"", for: .normal)
        quotes.setTitleColor(PHP.stringColor, for: .normal)
        alignButtons(groups: [quotes])
    }
    
}
