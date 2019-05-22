//import UIKit
//
//class KeyboardLeftControlButton: KeyboardControlButton {
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//    
//    override func control(target: EditorTextView) {
//        target.selectedRange.location = max(target.selectedRange.location - 1, 0)
//    }
//    
//    private func setup() {
//        titleLabel?.font = .systemFont(ofSize: 24)
//        setTitle("◀︎", for: .normal)
//    }
//    
//}
//
////extension KeyboardLeftControlButton: KeyboardControlButton {
////
////    func keyboardControlButton(control target: EditorTextView) {
////        target.selectedRange.location = max(target.selectedRange.location - 1, 0)
////    }
////
////}
