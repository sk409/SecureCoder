import UIKit

class KeyboardHomeControlButton: UIButton {
}

extension KeyboardHomeControlButton: KeyboardControlButton {
    
    func keyboardControlButton(control target: EditorTextView) {
        guard target.selectedRange.location != 0 else {
            return
        }
        let selectedIndex = (target.selectedRange.location - 1)
        for outer in (0...selectedIndex).reversed() {
            if outer == 0 {
                target.selectedRange.location = 0
                break
            }
            if target.text[outer] != "\n" {
                continue
            }
            if target.selectedRange.location < (outer + 1) {
                break
            }
            for inner in (outer + 1)...target.selectedRange.location {
                if (inner != target.text.count) && (target.text[inner] == " ") {
                    continue
                }
                if target.selectedRange.location == inner {
                    target.selectedRange.location = (outer + 1)
                } else {
                    target.selectedRange.location = inner
                }
                break
            }
            break
        }
    }
    
}
