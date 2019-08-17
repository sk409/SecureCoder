import UIKit

class KeyboardRefererSafeChangePassword0View: KeyboardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let openBracket = KeyboardView.makeButton()
        openBracket.setTitle("[", for: .normal)
        openBracket.setTitleColor(.white, for: .normal)
        let closeBracket = KeyboardView.makeButton()
        closeBracket.setTitle("]", for: .normal)
        closeBracket.setTitleColor(.white, for: .normal)
        let doubleQuotation = KeyboardView.makeButton()
        doubleQuotation.setTitle("\"", for: .normal)
        doubleQuotation.setTitleColor(PHP.stringColor, for: .normal)
        doubleQuotation.count = 4
        let notEqual = KeyboardView.makeButton()
        notEqual.setTitle("!==", for: .normal)
        notEqual.setTitleColor(.white, for: .normal)
        let space = KeyboardView.makeButton()
        space.setTitle(" ", for: .normal)
        space.count = 2
        let server = KeyboardView.makeButton()
        server.setTitle("$_SERVER", for: .normal)
        server.setTitleColor(PHP.variableColor, for: .normal)
        let referer = KeyboardView.makeButton()
        referer.setTitle("HTTP_REFERER", for: .normal)
        referer.setTitleColor(PHP.stringColor, for: .normal)
        let url = KeyboardView.makeButton()
        url.setTitle("http://www.safe.co.jp/home.php", for: .normal)
        url.setTitleColor(PHP.stringColor, for: .normal)
        alignButtons(groups: [openBracket, closeBracket, doubleQuotation, notEqual, space], [server, referer], [url])
    }
    
}
