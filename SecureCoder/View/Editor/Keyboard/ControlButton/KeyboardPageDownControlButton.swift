import UIKit

class KeyboardPageDownControlButton: UIButton {
}

extension KeyboardPageDownControlButton: KeyboardControlButton {
    
    func keyboardControlButton(control target: EditorTextView) {
        target.selectedRange.location = target.text.count
    }
    
}
