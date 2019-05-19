import UIKit

class KeyboardInputButton: KeyboardButton {
    
    var text: String?
    var shiftedText: String?
    
    var title: String?
    var shiftedTitle: String?
    
    private var activeText: String?
    
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        setup()
    }
    
    init(text: String, shiftedText: String) {
        super.init(frame: .zero)
        self.text = text
        self.shiftedText = shiftedText
        setup()
    }
    
    init(text: String, title: String) {
        super.init(frame: .zero)
        self.text = text
        self.title = title
        setup()
    }
    
    init(text: String, shiftedText: String, title: String, shiftedTitle: String) {
        super.init(frame: .zero)
        self.text = text
        self.shiftedText = shiftedText
        self.title = title
        self.shiftedTitle = shiftedTitle
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shift() {
        if activeText == text {
            if shiftedText != nil {
                activeText = shiftedText
            }
            if let title = title, let shiftedTitle = shiftedTitle {
                setTitle(text: shiftedTitle, shiftedText: title, state: .normal)
            } else if let text = text, let shiftedText = shiftedText {
                setTitle(text: shiftedText, shiftedText: text, state: .normal)
            } else if let title = title {
                setTitle(title, for: .normal)
            } else {
                setTitle(text, for: .normal)
            }
        } else {
            activeText = text
            if let title = title, let shiftedTitle = shiftedTitle {
                setTitle(text: title, shiftedText: shiftedTitle, state: .normal)
            } else if let text = text, let shiftedText = shiftedText {
                setTitle(text: text, shiftedText: shiftedText, state: .normal)
            } else if let title = title {
                setTitle(title, for: .normal)
            } else {
                setTitle(text, for: .normal)
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
    
    private func setup() {
        backgroundColor = .white
        setTitleColor(.black, for: .normal)
        activeText = text
        if let title = title {
            if let shiftedTitle = shiftedTitle {
                setTitle(text: title, shiftedText: shiftedTitle, state: .normal)
            } else {
                setTitle(title, for: .normal)
            }
        } else if let text = text {
            if let shiftedText = shiftedText {
                setTitle(text: text, shiftedText: shiftedText, state: .normal)
            } else {
                setTitle(text, for: .normal)
            }
        }
    }
    
    private func setTitle(text: String, shiftedText: String, state: UIControl.State) {
        contentVerticalAlignment = .top
        titleLabel?.numberOfLines = 2
        let attributedTitle = NSMutableAttributedString(attributedString: NSAttributedString(string: shiftedText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        attributedTitle.append(NSAttributedString(string: "\n"))
        attributedTitle.append(NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black]))
        setAttributedTitle(attributedTitle, for: state)
    }
    
}
