import UIKit

class KeyboardControlButton: KeyboardButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func control(target editorTextView: EditorTextView) {
    }
    
    private func setup() {
        backgroundColor = .darkGray
        setTitleColor(.white, for: .normal)
    }
    
}
