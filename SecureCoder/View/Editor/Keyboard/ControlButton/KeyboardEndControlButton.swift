import UIKit

class KeyboardEndControlButton: UIButton {
}

extension KeyboardEndControlButton: KeyboardControlButton {
    
    func keyboardControlButton(control target: EditorTextView) {
        guard target.selectedRange.location != target.text.count else {
            return
        }
        let selectedLocation = target.selectedRange.location
        for index in selectedLocation...(target.text.count - 1) {
            if target.text[index] == "\n" {
                target.selectedRange.location = index
                break
            }
            if index == (target.text.count - 1) {
                target.selectedRange.location = target.text.count
                break
            }
        }
    }
    
    
}
