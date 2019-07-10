import UIKit

class WebSimulatorViewController: UIViewController {
    
    var setNextGuideTextHandler: (() -> Void)?
    var endGuideHandler: (() -> Void)?
    
    let webSimulatorView = WebSimulatorView()
    let guideTextView = UITextView()
    
    private var guideTexts = [NSMutableAttributedString]()
    private let blackOutScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
//    func addBlackOut() {
//        blackOutScrollView.alpha = 1
//        blackOutScrollView.frame = view.safeAreaLayoutGuide.layoutFrame
//        blackOutScrollView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        view.addSubview(blackOutScrollView)
//    }
//
//    func addBlackOut(with duration: TimeInterval, completion: (() -> Void)?) {
//        addBlackOut()
//        blackOutScrollView.alpha = 0
//        UIView.animate(withDuration: duration, animations: {
//            self.blackOutScrollView.alpha = 1
//        }) { _ in
//            completion?()
//        }
//    }
//
//    func removeBlackOut() {
//        blackOutScrollView.removeFromSuperview()
//    }
//
//    func removeBlackOut(with duration: TimeInterval, completion: (() -> Void)?) {
//        UIView.animate(withDuration: duration, animations: {
//            self.blackOutScrollView.alpha = 0
//        }) { _ in
//            completion?()
//        }
//    }
//
//    func bringElementToFront(_ elementView: WebElementView) {
//        guard elementsPerLine.flatMap({ $0 }).contains(elementView) else {
//            return
//        }
//
//    }
    
    func setGuideText() {
        guard !guideTexts.isEmpty else {
            return
        }
        guideTextView.attributedText = guideTexts.removeFirst()
    }
    
    func showGuideTextView(completion: (() -> Void)?) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        window.addSubview(guideTextView)
        guideTextView.frame.origin.x = window.safeAreaInsets.left
        guideTextView.frame.size = CGSize(
            width: window.safeAreaLayoutGuide.layoutFrame.width,
            height: window.safeAreaLayoutGuide.layoutFrame.height * 0.4
        )
        UIView.animate(withDuration: 0.5, animations: {
            self.guideTextView.frame.origin.y = window.safeAreaLayoutGuide.layoutFrame.height - self.guideTextView.bounds.height
            self.webSimulatorView.contentView.contentSize.height += self.guideTextView.bounds.height
        }) { _ in
            completion?()
        }
    }
    
    func hideGuideTextView(completion: (() -> Void)?) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.guideTextView.frame.origin.y = window.frame.height
            self.webSimulatorView.contentView.contentSize.height -= self.guideTextView.bounds.height
        }) { _ in
            self.guideTextView.removeFromSuperview()
            completion?()
        }
    }
    
//    func fit() {
//        contentView.contentSize = .zero
//        for elementView in elementsPerLine.flatMap({$0.compactMap { $0 }}) {
//            contentView.contentSize.width = max(contentView.contentSize.width, elementView.frame.maxX)
//            contentView.contentSize.height = max(contentView.contentSize.width, elementView.frame.maxY)
//            if elementView.subviews.contains(elementView.codeLabel) {
//                contentView.contentSize.width = max(contentView.contentSize.width, elementView.codeLabel.frame.maxX)
//                contentView.contentSize.height = max(contentView.contentSize.width, elementView.codeLabel.frame.maxY)
//            }
//        }
//    }
    
    func focus(on elementView: WebElementView, with duration: TimeInterval = 1, completion: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.keyWindow
        else {
            return
        }
        let elementViewFrame: CGRect
        if webSimulatorView.elements.contains(elementView) {
            elementViewFrame = elementView.frame
        } else {
            if let superView = elementView.superview {
                elementViewFrame = superView.convert(elementView.frame, to: webSimulatorView.contentView)
            } else {
                elementViewFrame = .zero
            }
        }
        UIView.animate(withDuration: duration, animations: {
            self.webSimulatorView.contentView.contentOffset.y = elementViewFrame.origin.y
        }) { _ in
            elementView.cache["frame.origin.y"] = elementView.frame.origin.y
            elementView.cache["superview"] = elementView.superview
            elementView.removeFromSuperview()
            elementView.focus()
            elementView.frame.origin.y = 0
            self.blackOutScrollView.alpha = 1
            self.blackOutScrollView.frame = window.safeAreaLayoutGuide.layoutFrame
            self.blackOutScrollView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            self.blackOutScrollView.contentSize.width = max(elementViewFrame.maxX, elementView.codeLabel.frame.maxX + elementView.frame.origin.x)
            self.blackOutScrollView.contentSize.height = max(elementViewFrame.maxY, elementView.codeLabel.frame.maxY + elementView.frame.origin.y)
            self.blackOutScrollView.contentSize.height += self.guideTextView.bounds.height
            let buffer = CGSize(width: 8, height: 8)
            self.blackOutScrollView.contentSize.width += buffer.width
            self.blackOutScrollView.contentSize.height += buffer.height
            window.addSubview(self.blackOutScrollView)
            self.blackOutScrollView.addSubview(elementView)
            window.bringSubviewToFront(self.guideTextView)
            completion?()
        }
    }
    
    func unfocus(elementView: WebElementView, width duration: TimeInterval = 1, completion: (() -> Void)? = nil) {
        guard blackOutScrollView.subviews.contains(elementView),
              let superview = elementView.cache["superview"] as? UIView
        else {
            return
        }
        elementView.removeFromSuperview()
        elementView.frame.origin.y = elementView.cache["frame.origin.y"] as! CGFloat
        superview.addSubview(elementView)
        UIView.animate(withDuration: duration, animations: {
            self.blackOutScrollView.alpha = 0
        }) { _ in
            self.blackOutScrollView.removeFromSuperview()
            elementView.unfocus()
            completion?()
        }
    }
    
    func appendGuideText(_ text: String, programingLanguages: ProgramingLanguage?...) {
        let mutableAttributedString = NSMutableAttributedString(string: text, attributes: [.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 18)])
        var syntaxHighlighter = SyntaxHighlighter()
        for programingLanguage in programingLanguages {
            syntaxHighlighter.programingLanguage = programingLanguage
            if programingLanguage == .php {
                var phpSyntaxHighlighter = PHPSyntaxHighlighter()
                phpSyntaxHighlighter.force = true
                syntaxHighlighter.delegate = phpSyntaxHighlighter
            }
            _ = syntaxHighlighter.syntaxHighlight(mutableAttributedString)
        }
        guideTexts.append(mutableAttributedString)
    }
    
//    func focus(on views: UIView...) {
//        contentView.subviews.forEach { subview in
//            subview.layer.removeAllAnimations()
//            subview.layer.borderColor = UIColor.clear.cgColor
//            subview.layer.borderWidth = 0
//        }
//        var firstView: UIView?
//        for v in views {
//            guard contentView.subviews.contains(v) else {
//                continue
//            }
//            let animationDuration: TimeInterval = 0.5
//            let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
//            borderColorAnimation.toValue = UIColor.red.cgColor
//            borderColorAnimation.duration = animationDuration
//            borderColorAnimation.isRemovedOnCompletion = false
//            borderColorAnimation.fillMode = .forwards
//            v.layer.add(borderColorAnimation, forKey: "borderColorAnimation")
//            let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
//            borderWidthAnimation.toValue = 1
//            borderWidthAnimation.duration = animationDuration
//            borderWidthAnimation.isRemovedOnCompletion = false
//            borderWidthAnimation.fillMode = .forwards
//            v.layer.add(borderWidthAnimation, forKey: "borderWidthAnimation")
//            if firstView == nil {
//                firstView = v
//            }
//        }
//        if let fv = firstView {
//            UIView.animate(withDuration: 1) {
//                self.contentView.contentOffset.y = fv.frame.origin.y
//            }
//        }
//    }
    
//    func showCode(element: UIView, code: String) {
//        var syntaxHighlighter = SyntaxHighlighter(tintColor: .black, font: .boldSystemFont(ofSize: 16))
//        syntaxHighlighter.programingLanguage = .html
//        let codeLabel = UILabel()
//        codeLabels.append(codeLabel)
//        codeLabel.backgroundColor = .lightGray
//        codeLabel.numberOfLines = 0
//        codeLabel.attributedText = syntaxHighlighter.syntaxHighlight(code)
//        codeLabel.frame.origin.x = element.frame.origin.x + 10
//        codeLabel.frame.origin.y = element.frame.maxY + 10
//        contentView.addSubview(codeLabel)
//        UIView.animate(withDuration: 1) {
//            codeLabel.frame.size = codeLabel.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
//            self.contentView.contentSize.width = max(self.contentView.contentSize.width, codeLabel.frame.maxX)
//        }
//    }
    
//    func removeAllCodeLabels() {
//        UIView.animate(withDuration: 1, animations: {
//            for codeLabel in self.codeLabels {
//                codeLabel.frame.size = .zero
//            }
//        }) { _ in
//            self.codeLabels.forEach { $0.removeFromSuperview() }
//            var maxX: CGFloat = 0
//            for elementView in self.contentView.subviews {
//                maxX = max(maxX, elementView.frame.maxX)
//            }
//            self.contentView.contentSize.width = maxX
//        }
//    }
    
    private func setupViews() {
        view.addSubview(webSimulatorView)
        webSimulatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webSimulatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webSimulatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webSimulatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webSimulatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        guideTextView.isEditable = false
        guideTextView.isScrollEnabled = false
        guideTextView.frame.origin.y = view.frame.height
        guideTextView.backgroundColor = .lightGray
        //guideTextView.font = .boldSystemFont(ofSize: 18)
        //guideTextView.textContainer.lineBreakMode = .byCharWrapping
        guideTextView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGuideTextViewTapGesture(_:))))
    }
    
    @objc
    private func handleGuideTextViewTapGesture(_ sender: UITapGestureRecognizer) {
        if guideTexts.isEmpty {
            endGuideHandler?()
        } else {
            setNextGuideTextHandler?()
            setGuideText()
        }
    }
    
}
