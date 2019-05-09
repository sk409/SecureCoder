import UIKit

class KeyboardLeftControlButton: UIButton {
}

extension KeyboardLeftControlButton: KeyboardControlButton {
    
    func keyboardControlButton(control target: EditorTextView) {
        target.selectedRange.location = max(target.selectedRange.location - 1, 0)
    }
    
}
