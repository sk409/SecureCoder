import UIKit

class WebElementView: UILabel {
    
    enum Display {
        case inline
        case block
        case inlineblock
        case flex
    }
    
    var cache = [String: Any]()
    var margin = UIEdgeInsets.zero
    var display = Display.block
    
    let codeLabel = CodeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func focus(with duration: TimeInterval = 0.5, borderWidth: CGFloat = 1, borderColor: CGColor = UIColor.red.cgColor, backgroundColor: UIColor = .white, completion: (() -> Void)? = nil)
    {
        layer.removeAllAnimations()
        cache["backgroundColor"] = self.backgroundColor
        cache["layer.borderColor"] = layer.borderColor
        cache["layer.borderWidth"] = layer.borderWidth
        self.backgroundColor = backgroundColor
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.toValue = borderColor
        borderColorAnimation.duration = duration
        borderColorAnimation.isRemovedOnCompletion = false
        borderColorAnimation.fillMode = .forwards
        layer.add(borderColorAnimation, forKey: "borderColorAnimation")
        let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderWidthAnimation.toValue = borderWidth
        borderWidthAnimation.duration = duration
        borderWidthAnimation.isRemovedOnCompletion = false
        borderWidthAnimation.fillMode = .forwards
        layer.add(borderWidthAnimation, forKey: "borderWidthAnimation")
        let margin: CGFloat = 10
        switch codeLabel.positionX {
        case .left:
            codeLabel.frame.origin.x = frame.origin.x + margin
        case .right:
            codeLabel.frame.origin.x = frame.maxX + margin
        case .center:
            codeLabel.center.x = (frame.origin.x + frame.maxX) / 2
        }
        switch codeLabel.positionY {
        case .top:
            codeLabel.frame.origin.y = 0
        case .bottom:
            codeLabel.frame.origin.y = bounds.height + margin
        case .center:
            codeLabel.center.x = bounds.height / 2
        }
        UIView.animate(withDuration: duration, animations: {
            self.codeLabel.frame.size = self.codeLabel.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
        }) { _ in
            completion?()
        }
    }
    
    func unfocus(with duration: TimeInterval = 1, completion: (() -> Void)? = nil) {
        guard let borderColor = cache["layer.borderColor"],
              let borderWidth = cache["layer.borderWidth"],
              let backgroundColor = cache["backgroundColor"] as? UIColor
        else {
            return
        }
        self.backgroundColor = backgroundColor
        layer.removeAllAnimations()
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.toValue = borderColor
        borderColorAnimation.duration = duration
        borderColorAnimation.isRemovedOnCompletion = false
        borderColorAnimation.fillMode = .forwards
        layer.add(borderColorAnimation, forKey: "borderColorAnimation")
        let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderWidthAnimation.toValue = borderWidth
        borderWidthAnimation.duration = duration
        borderWidthAnimation.isRemovedOnCompletion = false
        borderWidthAnimation.fillMode = .forwards
        layer.add(borderWidthAnimation, forKey: "borderWidthAnimation")
        UIView.animate(withDuration: duration, animations: {
            self.codeLabel.frame.size = .zero
        }) { _ in
            completion?()
        }
    }
    
    func set(code: String, language: ProgramingLanguage) {
        var syntaxHighlighter = SyntaxHighlighter(tintColor: .white, font: .boldSystemFont(ofSize: 16))
        syntaxHighlighter.programingLanguage = language
        codeLabel.attributedText = syntaxHighlighter.syntaxHighlight(code)
        codeLabel.numberOfLines = 0
    }
    
    private func setupViews() {
        isUserInteractionEnabled = true
        addSubview(codeLabel)
        codeLabel.backgroundColor = .black
    }
    
}
