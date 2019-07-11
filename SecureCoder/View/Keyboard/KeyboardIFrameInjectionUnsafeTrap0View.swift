import UIKit

class KeyboardIFrameInjectionUnsafeTrap0View: KeyboardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let lessThan = KeyboardButton()
        lessThan.setTitle("<", for: .normal)
        lessThan.setTitleColor(.stringRed, for: .normal)
        lessThan.count = 2
        let greaterThan = KeyboardButton()
        greaterThan.setTitleColor(.stringRed, for: .normal)
        greaterThan.setTitle(">", for: .normal)
        greaterThan.count = 2
        let equal = KeyboardButton()
        equal.setTitle("=", for: .normal)
        equal.setTitleColor(.stringRed, for: .normal)
        equal.count = 1
        let slash = KeyboardButton()
        slash.setTitle("/", for: .normal)
        slash.setTitleColor(.stringRed, for: .normal)
        slash.count = 1
        let space = KeyboardButton()
        space.setTitle(" ", for: .normal)
        space.setTitleColor(.white, for: .normal)
        space.count = 1
        let script = KeyboardButton()
        script.setTitle("script", for: .normal)
        script.setTitleColor(.stringRed, for: .normal)
        script.count = 2
        let src = KeyboardButton()
        src.setTitle("src", for: .normal)
        src.setTitleColor(.stringRed, for: .normal)
        src.count = 1
        let url = KeyboardButton()
        url.setTitle("http://www.trap.cp.jp/iframe_injection.js", for: .normal)
        url.setTitleColor(.stringRed, for: .normal)
        url.count = 1
        let group1 = [lessThan, greaterThan, equal, slash, space]
        let group2 = [script, src]
        let group3 = [url]
        alignButtons(groups: group1, group2, group3)
    }
    
}
