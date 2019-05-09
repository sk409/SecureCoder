import UIKit

class KeyboardShiftControlButton: UIButton {
}

extension KeyboardShiftControlButton: KeyboardControlButton {
    
    func keyboardControlButton(control target: EditorTextView) {
        guard let keyboardView = target.inputView as? KeyboardView else {
            return
        }
        for view in (keyboardView.alphabetKeyboardView.views + keyboardView.symbolKeyboardView.views) {
            guard let keyboardAlphabetInputButton = view as? KeyboardInputButton else {
                continue
            }
            keyboardAlphabetInputButton.shift()
        }
    }
    
}
