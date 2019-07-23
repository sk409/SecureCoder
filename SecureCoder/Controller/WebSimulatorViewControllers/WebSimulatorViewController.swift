import UIKit

class WebSimulatorViewController: UIViewController {
    
    struct GuideSection {
        var isActive = false
        let attributedTexts: [NSMutableAttributedString]
        let onEnter: (() -> Void)?
        let onExit: (() -> Void)?
        init(attributedTexts: [NSMutableAttributedString], onEnter: (() -> Void)?, onExit: (() -> Void)?) {
            self.attributedTexts = attributedTexts
            self.onEnter = onEnter
            self.onExit = onExit
        }
    }
    
    struct GuideText {
        
        let text: String
        let programingLanguages: [ProgramingLanguage]
        
        init(text: String) {
            self.text = text
            programingLanguages = []
        }
        
        init(text: String, programingLanguages: [ProgramingLanguage]) {
            self.text = text
            self.programingLanguages = programingLanguages
        }
        
    }
    
    private static let guideMessageCollectionViewTextCellId = "guideMessageCollectionViewTextCellId"
    private static let guideMessageCollectionViewButtonCellId = "guideMessageCollectionViewButtonCellId"
    
    let webSimulatorView = WebSimulatorView()
    let guideMessageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }())
    
    private var isAddedCloseButton = false
    private var guideSections = [GuideSection]()
    private let blackOutScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func showGuideMessageCollectionView(completion: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        window.addSubview(guideMessageCollectionView)
        guideMessageCollectionView.frame.origin.x = window.safeAreaInsets.left
        guideMessageCollectionView.frame.size = CGSize(
            width: window.safeAreaLayoutGuide.layoutFrame.width,
            height: window.safeAreaLayoutGuide.layoutFrame.height * 0.4
        )
        UIView.animate(withDuration: 0.5, animations: {
            self.guideMessageCollectionView.frame.origin.y = window.safeAreaLayoutGuide.layoutFrame.height - self.guideMessageCollectionView.bounds.height
            self.webSimulatorView.contentView.contentSize.height += self.guideMessageCollectionView.bounds.height
        }) { _ in
            completion?()
        }
    }
    
    func hideGuideMessageCollectionView(completion: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.guideMessageCollectionView.frame.origin.y = window.frame.height
            self.webSimulatorView.contentView.contentSize.height -= self.guideMessageCollectionView.bounds.height
        }) { _ in
            self.guideMessageCollectionView.removeFromSuperview()
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
    
    func focus(on elementView: WebElementView, with duration: TimeInterval = 0.5, completion: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.keyWindow else {
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
        guideMessageCollectionView.isScrollEnabled = false
        UIView.animate(withDuration: duration, animations: {
            self.webSimulatorView.contentView.contentOffset.y = elementViewFrame.origin.y
        }) { _ in
            defer {
                self.guideMessageCollectionView.isScrollEnabled = true
            }
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
            self.blackOutScrollView.contentSize.height += self.guideMessageCollectionView.bounds.height
            let buffer = CGSize(width: 8, height: 8)
            self.blackOutScrollView.contentSize.width += buffer.width
            self.blackOutScrollView.contentSize.height += buffer.height
            window.addSubview(self.blackOutScrollView)
            self.blackOutScrollView.addSubview(elementView)
            window.bringSubviewToFront(self.guideMessageCollectionView)
            completion?()
        }
    }
    
    func unfocus(elementView: WebElementView, width duration: TimeInterval = 0.5, completion: (() -> Void)? = nil) {
        guard blackOutScrollView.subviews.contains(elementView),
              let superview = elementView.cache["superview"] as? UIView
        else {
            return
        }
        elementView.removeFromSuperview()
        elementView.frame.origin.y = elementView.cache["frame.origin.y"] as! CGFloat
        superview.addSubview(elementView)
        guideMessageCollectionView.isScrollEnabled = false
        UIView.animate(withDuration: duration, animations: {
            self.blackOutScrollView.alpha = 0
        }) { _ in
            defer {
                self.guideMessageCollectionView.isScrollEnabled = true
            }
            self.blackOutScrollView.removeFromSuperview()
            elementView.unfocus()
            completion?()
        }
    }
    
    func unfocusAll(with duration: TimeInterval = 0.5) {
        for focusedView in blackOutScrollView.subviews {
            guard let focusedElementView = focusedView as? WebElementView else {
                continue
            }
            unfocus(elementView: focusedElementView)
        }
    }
    
    func clearGuideSections() {
        guideSections.removeAll(keepingCapacity: true)
    }
    
    func appendGuideSection(_ guideTexts: [GuideText], onEnter: (() -> Void)? = nil, onExit: (() -> Void)? = nil) {
        if onExit != nil {
            fatalError()
        }
        var attributedTexts = [NSMutableAttributedString]()
        var syntaxHighlighter = SyntaxHighlighter()
        for guideText in guideTexts {
            let attributedText = NSMutableAttributedString(string: guideText.text, attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 18)])
            for programingLanguage in guideText.programingLanguages {
                syntaxHighlighter.programingLanguage = programingLanguage
                if programingLanguage == .php {
                    var phpSyntaxHighlighter = PHPSyntaxHighlighter()
                    phpSyntaxHighlighter.force = true
                    syntaxHighlighter.delegate = phpSyntaxHighlighter
                }
                _ = syntaxHighlighter.syntaxHighlight(attributedText)
            }
            attributedTexts.append(attributedText)
        }
        guideSections.append(GuideSection(attributedTexts: attributedTexts, onEnter: onEnter, onExit: onExit))
    }
    
    func addCloseButton() {
        isAddedCloseButton = true
        guideMessageCollectionView.reloadData()
    }
    
    func removeCloseButton() {
        isAddedCloseButton = false
        guideMessageCollectionView.reloadData()
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
        guideMessageCollectionView.isPagingEnabled = true
        guideMessageCollectionView.dataSource = self
        guideMessageCollectionView.delegate = self
        guideMessageCollectionView.frame.origin.y = view.frame.height
        guideMessageCollectionView.backgroundColor = .black
        guideMessageCollectionView.register(GuideMessageCollectionViewTextCell.self, forCellWithReuseIdentifier: WebSimulatorViewController.guideMessageCollectionViewTextCellId)
        guideMessageCollectionView.register(GuideMessageCollectionViewButtonCell.self, forCellWithReuseIdentifier: WebSimulatorViewController.guideMessageCollectionViewButtonCellId)
    }
    
    @objc
    private func handleCloseButton(_ sender: UIButton) {
        guideMessageCollectionView.removeFromSuperview()
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
}

extension WebSimulatorViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isAddedCloseButton ? guideSections.count + 1 : guideSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < guideSections.count {
            return guideSections[section].attributedTexts.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section < guideSections.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WebSimulatorViewController.guideMessageCollectionViewTextCellId, for: indexPath) as! GuideMessageCollectionViewTextCell
            cell.textView.attributedText = guideSections[indexPath.section].attributedTexts[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WebSimulatorViewController.guideMessageCollectionViewButtonCellId, for: indexPath) as! GuideMessageCollectionViewButtonCell
            cell.buttonTitle = "レッスン選択画面に戻る"
            cell.button.addTarget(self, action: #selector(handleCloseButton(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var found = false
        var section = 0
        var x: CGFloat = 0
        for guideSection in guideSections {
            for _ in guideSection.attributedTexts {
                if scrollView.contentOffset.x <= x {
                    found = true
                    break
                }
                x += guideMessageCollectionView.bounds.width
            }
            if found {
                break
            }
            section += 1
        }
        for (index, guideSection) in guideSections.enumerated() {
            if !guideSection.isActive && index == section {
                guideSections[index].isActive = true
                unfocusAll(with: 0)
                guideSection.onEnter?()
            }
            else if guideSection.isActive && index != section {
                guideSection.onExit?()
                guideSections[index].isActive = false
            }
        }
    }
    
}
