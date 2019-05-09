import UIKit

@IBDesignable
class KeyboardKanaInputButton: FlickButton {
    
    @IBInspectable var centerText: String?
    @IBInspectable var leftText: String?
    @IBInspectable var topText: String?
    @IBInspectable var rightText: String?
    @IBInspectable var bottomText: String?
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let centerLabel = UILabel()
        centerLabel.text = centerText
        centerLabel.textAlignment = .center
        centerView = centerLabel
        let leftLabel = UILabel()
        leftLabel.text = leftText
        leftLabel.textAlignment = .center
        leftView = leftLabel
        let topLabel = UILabel()
        topLabel.text = topText
        topLabel.textAlignment = .center
        topView = topLabel
        let rightLabel = UILabel()
        rightLabel.text = rightText
        rightLabel.textAlignment = .center
        rightView = rightLabel
        let bottomLabel = UILabel()
        bottomLabel.text = bottomText
        bottomLabel.textAlignment = .center
        bottomView = bottomLabel
    }
    
    func input(to target: EditorTextView, text: String) {
        guard let delegate = target.delegate else {
            return
        }
        guard delegate.textView?(target, shouldChangeTextIn: target.selectedRange, replacementText: text) ?? false else {
            return
        }
        let markedText = (target.text as NSString).substring(with: NSRange(location: target.selectedRange.location, length: target.selectedRange.length))
        target.setMarkedText(markedText + text, selectedRange: NSRange(location: 0, length: target.selectedRange.length + 1))
        (delegate as? CodeEditorViewController)?.fitSizeEditorTextView()
        delegate.textViewDidChangeSelection?(target)
    }
    
}
