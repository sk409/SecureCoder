import UIKit

class KeyboardDownControlButton: UIButton {
}

extension KeyboardDownControlButton: KeyboardControlButton {
    
    func keyboardControlButton(control target: EditorTextView) {
        guard let font = target.font else {
            return
        }
        guard target.selectedRange.location != 0  else {
            for index in 0...(target.text.count - 1) {
                if target.text[index] != "\n" {
                    continue
                }
                target.selectedRange.location = (index + 1)
                break
            }
            return
        }
        var line = ""
        let selectedIndex = (target.selectedRange.location - 1)
        for index in (0...selectedIndex).reversed() {
            let character = target.text[index]
            if character  == "\n" {
                break
            }
            line.append(character)
        }
        var newLineIndex = -1
        for index in (selectedIndex + 1)...(target.text.count - 1) {
            if target.text[index] != "\n" {
                continue
            }
            newLineIndex = index
            break
        }
        if newLineIndex == -1 {
            return
        }
        let lineWidth = line.size(withAttributes: [NSAttributedString.Key.font: font]).width
        var line2 = ""
        for index in (newLineIndex + 1)...(target.text.count - 1) {
            let character = target.text[index]
            if (character == "\n") {
                target.selectedRange.location = index
                break
            }
            line2.append(character)
            let line2Width = line2.size(withAttributes: [NSAttributedString.Key.font: font]).width
            if lineWidth <= line2Width {
                let eps = (" ".size(withAttributes: [NSAttributedString.Key.font: font]).width * 0.9)
                if (line2Width - lineWidth) <= eps {
                    target.selectedRange.location = (index + 1)
                } else {
                    target.selectedRange.location = index
                }
                break
            } else if index == (target.text.count - 1) {
                target.selectedRange.location = target.text.count
                break
            }
        }
    }
    
}
