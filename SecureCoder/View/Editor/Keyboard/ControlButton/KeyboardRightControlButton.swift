import UIKit

class KeyboardRightControlButton: UIButton {
}

extension KeyboardRightControlButton: KeyboardControlButton {
    
    func keyboardControlButton(control target: EditorTextView) {
        target.selectedRange.location = min(target.selectedRange.location + 1, target.text.count)
    }
    
}
