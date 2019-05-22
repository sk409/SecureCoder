//import UIKit
//
//class KeyboardPageUpControlButton: KeyboardControlButton {
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
//        target.selectedRange.location = 0
//    }
//    
//    private func setup() {
//        titleLabel?.font = .systemFont(ofSize: 14)
//        setTitle("PgUp", for: .normal)
//    }
//    
//}
//
////extension KeyboardPageUpControlButton: KeyboardControlButton {
////
////    func keyboardControlButton(control target: EditorTextView) {
////        target.selectedRange.location = 0
////    }
////
////}
