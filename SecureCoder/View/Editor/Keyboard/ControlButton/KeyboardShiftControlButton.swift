import UIKit

class KeyboardShiftControlButton: KeyboardControlButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func control(target: EditorTextView) {
        guard let keyboardView = target.inputView as? KeyboardView else {
            return
        }
        for button in keyboardView.buttons {
            guard let keyboardAlphabetInputButton = button as? KeyboardInputButton else {
                continue
            }
            keyboardAlphabetInputButton.shift()
        }
    }
    
    private func setup() {
        titleLabel?.font = .systemFont(ofSize: 14)
        setTitle("shift", for: .normal)
    }
    
}

//extension KeyboardShiftControlButton: KeyboardControlButton {
//
//    func keyboardControlButton(control target: EditorTextView) {
//        guard let keyboardView = target.inputView as? KeyboardView else {
//            return
//        }
//        // TODO:
////        for view in (keyboardView.alphabetKeyboardView.views + keyboardView.symbolKeyboardView.views) {
////            guard let keyboardAlphabetInputButton = view as? KeyboardInputButton else {
////                continue
////            }
////            keyboardAlphabetInputButton.shift()
////        }
//    }
//
//}
