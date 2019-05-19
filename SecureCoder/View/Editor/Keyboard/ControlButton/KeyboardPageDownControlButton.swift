import UIKit

class KeyboardPageDownControlButton: KeyboardControlButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func control(target: EditorTextView) {
        target.selectedRange.location = target.text.count
    }
    
    private func setup() {
        titleLabel?.font = .systemFont(ofSize: 14)
        setTitle("PgDn", for: .normal)
    }
    
}

//extension KeyboardPageDownControlButton: KeyboardControlButton {
//
//    func keyboardControlButton(control target: EditorTextView) {
//        target.selectedRange.location = target.text.count
//    }
//
//}
