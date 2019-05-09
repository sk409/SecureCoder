import UIKit

class KeyboardView: UIView {
    
    let alphabetKeyboardView = KeyboardAlphabetView()
    let symbolKeyboardView = KeyboardSymbolView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubViews()
    }
    
    private func setupSubViews() {
        alphabetKeyboardView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        symbolKeyboardView.frame = CGRect(x: bounds.width, y: 0, width: bounds.width, height: bounds.height)
        let scrollView = UIScrollView(frame: frame)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: bounds.width * 2, height: bounds.height)
        scrollView.addSubview(alphabetKeyboardView)
        scrollView.addSubview(symbolKeyboardView)
        addSubview(scrollView)
    }
    
}
