import UIKit

class KeyboardRightControlButton: KeyboardControlButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func control(target: EditorTextView) {
        target.selectedRange.location = min(target.selectedRange.location + 1, target.text.count)
    }
    
    private func setup() {
        titleLabel?.font = .systemFont(ofSize: 24)
        setTitle("▶︎", for: .normal)
    }
    
}

//extension KeyboardRightControlButton: KeyboardControlButton {
//
//    func keyboardControlButton(control target: EditorTextView) {
//        target.selectedRange.location = min(target.selectedRange.location + 1, target.text.count)
//    }
//
//}
