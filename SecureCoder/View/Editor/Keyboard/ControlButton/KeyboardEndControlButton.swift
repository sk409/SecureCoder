import UIKit

class KeyboardEndControlButton: KeyboardControlButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func control(target: EditorTextView) {
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
    
    private func setup() {
        titleLabel?.font = .systemFont(ofSize: 14)
        setTitle("End", for: .normal)
    }
    
}

//extension KeyboardEndControlButton: KeyboardControlButton {
//
//    func keyboardControlButton(control target: EditorTextView) {
//        guard target.selectedRange.location != target.text.count else {
//            return
//        }
//        let selectedLocation = target.selectedRange.location
//        for index in selectedLocation...(target.text.count - 1) {
//            if target.text[index] == "\n" {
//                target.selectedRange.location = index
//                break
//            }
//            if index == (target.text.count - 1) {
//                target.selectedRange.location = target.text.count
//                break
//            }
//        }
//    }
//
//
//}
