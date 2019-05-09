import UIKit

class KeyboardDeleteControlButton: UIButton {
}

extension KeyboardDeleteControlButton: KeyboardControlButton {
    
    func keyboardControlButton(control target: EditorTextView) {
        let selectedLocation = target.selectedRange.location
        guard selectedLocation != target.text.count else {
            return
        }
        let attributedText = NSMutableAttributedString(attributedString: target.attributedText.attributedSubstring(from: NSRange(location: 0, length: selectedLocation)))
        attributedText.append(target.attributedText.attributedSubstring(from: NSRange(location: selectedLocation + 1, length: target.text.count - selectedLocation - 1)))
        target.attributedText = attributedText
        target.decorateSyntaxHighlight(caretLocation: selectedLocation, synchronize: false)
    }
    
}
