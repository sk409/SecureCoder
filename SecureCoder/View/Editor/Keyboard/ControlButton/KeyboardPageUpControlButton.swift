import UIKit

class KeyboardPageUpControlButton: UIButton {
}

extension KeyboardPageUpControlButton: KeyboardControlButton {
    
    func keyboardControlButton(control target: EditorTextView) {
        target.selectedRange.location = 0
    }
    
}
