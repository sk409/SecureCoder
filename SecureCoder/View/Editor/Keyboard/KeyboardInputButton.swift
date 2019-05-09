import UIKit

class KeyboardInputButton: UIButton {
    
    var text: String?
    var shiftedText: String?
    
    var title: String?
    var shiftedTitle: String?
    
    private var activeText: String?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        activeText = text
        if title == nil {
            setTitle(text, for: .normal)
        } else {
            setTitle(title, for: .normal)
        }
    }
    
    func shift() {
        if activeText == text {
            activeText = shiftedText
            if shiftedTitle == nil {
                setTitle(shiftedText, for: .normal)
            } else {
                setTitle(shiftedTitle, for: .normal)
            }
        } else {
            activeText = text
            if title == nil {
                setTitle(text, for: .normal)
            } else {
                setTitle(title, for: .normal)
            }
        }
    }
    
    func input(to target: EditorTextView) {
        guard let activeText = activeText else {
            return
        }
        guard let delegate = target.delegate else {
            return
        }
        guard delegate.textView?(target, shouldChangeTextIn: target.selectedRange, replacementText: activeText) ?? false else {
            return
        }
        let selectedLocation = target.selectedRange.location
        target.insertText(activeText)
        target.selectedRange.location = (selectedLocation + 1)
    }
    
}
