//import UIKit
//
//class KeyboardUpControlButton: KeyboardControlButton {
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
//        guard let font = target.font else {
//            return
//        }
//        guard target.selectedRange.location != 0 else {
//            return
//        }
//        var line = ""
//        var newLineIndex = -1
//        let selectedIndex = (target.selectedRange.location - 1)
//        for index in (0...selectedIndex).reversed() {
//            let character = target.text[index]
//            if character  == "\n" {
//                newLineIndex = index
//                break
//            }
//            line.append(character)
//        }
//        if newLineIndex == -1 {
//            return
//        }
//        let lineWidth = line.size(withAttributes: [NSAttributedString.Key.font: font]).width
//        for outer in (0..<newLineIndex).reversed() {
//            if (outer != 0) && (target.text[outer] != "\n") {
//                continue
//            }
//            var line2 = ""
//            for inner in outer...newLineIndex {
//                let character = target.text[inner]
//                if (inner != outer) && (character == "\n") {
//                    target.selectedRange.location = inner
//                    break
//                }
//                line2.append(character)
//                let line2Width = line2.size(withAttributes: [NSAttributedString.Key.font: font]).width
//                if lineWidth <= line2Width {
//                    let eps = (" ".size(withAttributes: [NSAttributedString.Key.font: font]).width * 0.9)
//                    if line2Width - lineWidth <= eps {
//                        target.selectedRange.location = (inner + 1)
//                    } else {
//                        target.selectedRange.location = inner
//                    }
//                    break
//                }
//            }
//            break
//        }
//    }
//    
//    private func setup() {
//        titleLabel?.font = .systemFont(ofSize: 24)
//        setTitle("▲", for: .normal)
//    }
//    
//}
//
////extension KeyboardUpControlButton: KeyboardControlButton {
////
////    func keyboardControlButton(control target: EditorTextView) {
////        guard let font = target.font else {
////            return
////        }
////        guard target.selectedRange.location != 0 else {
////            return
////        }
////        var line = ""
////        var newLineIndex = -1
////        let selectedIndex = (target.selectedRange.location - 1)
////        for index in (0...selectedIndex).reversed() {
////            let character = target.text[index]
////            if character  == "\n" {
////                newLineIndex = index
////                break
////            }
////            line.append(character)
////        }
////        if newLineIndex == -1 {
////            return
////        }
////        let lineWidth = line.size(withAttributes: [NSAttributedString.Key.font: font]).width
////        for outer in (0..<newLineIndex).reversed() {
////            if (outer != 0) && (target.text[outer] != "\n") {
////                continue
////            }
////            var line2 = ""
////            for inner in outer...newLineIndex {
////                let character = target.text[inner]
////                if (inner != outer) && (character == "\n") {
////                    target.selectedRange.location = inner
////                    break
////                }
////                line2.append(character)
////                let line2Width = line2.size(withAttributes: [NSAttributedString.Key.font: font]).width
////                if lineWidth <= line2Width {
////                    let eps = (" ".size(withAttributes: [NSAttributedString.Key.font: font]).width * 0.9)
////                    if line2Width - lineWidth <= eps {
////                        target.selectedRange.location = (inner + 1)
////                    } else {
////                        target.selectedRange.location = inner
////                    }
////                    break
////                }
////            }
////            break
////        }
////    }
////
////}
