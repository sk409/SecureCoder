import UIKit

class KeyboardBackSpaceControlButton: KeyboardControlButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func control(target: EditorTextView) {
        let selectedLocation = target.selectedRange.location
        guard selectedLocation != 0 else {
            return
        }
        let attributedText = NSMutableAttributedString(attributedString: target.attributedText.attributedSubstring(from: NSRange(location: 0, length: selectedLocation - 1)))
        attributedText.append(target.attributedText.attributedSubstring(from: NSRange(location: selectedLocation, length: target.text.count - selectedLocation)))
        target.attributedText = attributedText
        // TODO: ガクガク対策(やって大丈夫?)
        target.selectedRange.location = (selectedLocation - 1)
        //
        target.decorateSyntaxHighlight(caretLocation: (selectedLocation - 1), synchronize: false)
        target.autoCorrect()
    }
    
    private func setup() {
        titleLabel?.font = .systemFont(ofSize: 14)
        setTitle("back", for: .normal)
    }
    
}

//extension KeyboardBackSpaceControlButton: KeyboardControlButton {
//
//    func keyboardControlButton(control target: EditorTextView) {
//        let selectedLocation = target.selectedRange.location
//        guard selectedLocation != 0 else {
//            return
//        }
//        let attributedText = NSMutableAttributedString(attributedString: target.attributedText.attributedSubstring(from: NSRange(location: 0, length: selectedLocation - 1)))
//        attributedText.append(target.attributedText.attributedSubstring(from: NSRange(location: selectedLocation, length: target.text.count - selectedLocation)))
//        target.attributedText = attributedText
//        // TODO: ガクガク対策(やって大丈夫?)
//        target.selectedRange.location = (selectedLocation - 1)
//        //
//        target.decorateSyntaxHighlight(caretLocation: (selectedLocation - 1), synchronize: false)
//        target.autoCorrect()
//    }
//
//}
