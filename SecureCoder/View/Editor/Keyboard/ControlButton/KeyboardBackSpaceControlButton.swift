import UIKit

class KeyboardBackSpaceControlButton: UIButton {
}

extension KeyboardBackSpaceControlButton: KeyboardControlButton {
    
    func keyboardControlButton(control target: EditorTextView) {
        let selectedLocation = target.selectedRange.location
        guard selectedLocation != 0 else {
            return
        }
        let attributedText = NSMutableAttributedString(attributedString: target.attributedText.attributedSubstring(from: NSRange(location: 0, length: selectedLocation - 1)))
        attributedText.append(target.attributedText.attributedSubstring(from: NSRange(location: selectedLocation, length: target.text.count - selectedLocation)))
        target.attributedText = attributedText
        // TODO: ガクガクする
        target.decorateSyntaxHighlight(caretLocation: (selectedLocation - 1), synchronize: false)
        //
    }
    
}
