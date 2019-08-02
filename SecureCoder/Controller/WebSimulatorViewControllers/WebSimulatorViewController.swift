import UIKit

class WebSimulatorViewController: UIViewController {
    
    struct GuideSection {
        var isActive = false
        let attributedTexts: [NSMutableAttributedString]
        let onEnter: (((() -> Void)?) -> Void)?
        let onExit: (((() -> Void)?) -> Void)?
        init(attributedTexts: [NSMutableAttributedString], onEnter: (((() -> Void)?) -> Void)?, onExit: (((() -> Void)?) -> Void)?) {
            self.attributedTexts = attributedTexts
            self.onEnter = onEnter
            self.onExit = onExit
        }
    }
    
    struct GuideText {
        
        var force = true
        let text: String
        let programingLanguages: [ProgramingLanguage]
        
        init(text: String) {
            self.text = text
            programingLanguages = []
        }
        
        init(text: String, force: Bool = true, programingLanguages: [ProgramingLanguage]) {
            self.text = text
            self.force = force
            self.programingLanguages = programingLanguages
        }
        
    }
    
    private static let guideMessageCollectionViewTextCellId = "guideMessageCollectionViewTextCellId"
    private static let guideMessageCollectionViewButtonCellId = "guideMessageCollectionViewButtonCellId"
    
    let body = Body()
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
        registerObservers()
    }
    
    func showGuideMessageCollectionView(completion: (() -> Void)? = nil) {
        view.addSubview(guideMessageCollectionView)
        guideMessageCollectionView.frame.origin.x = view.safeAreaInsets.left
        guideMessageCollectionView.frame.size = CGSize(
            width: view.safeAreaLayoutGuide.layoutFrame.width,
            height: view.safeAreaLayoutGuide.layoutFrame.height * 0.4
        )
        UIView.animate(withDuration: 0.5, animations: {
            self.guideMessageCollectionView.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.height - self.guideMessageCollectionView.bounds.height
            self.body.scrollView.contentSize.height += self.guideMessageCollectionView.bounds.height
        }) { _ in
            completion?()
        }
    }
    
    func hideGuideMessageCollectionView(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.guideMessageCollectionView.frame.origin.y = self.view.bounds.height
            self.body.scrollView.contentSize.height -= self.guideMessageCollectionView.bounds.height
        }) { _ in
            self.guideMessageCollectionView.removeFromSuperview()
            completion?()
        }
    }
    
    func focus(on elementView: WebElementView, with duration: TimeInterval = 0.5, completion: (() -> Void)? = nil) {
        let elementViewFrame: CGRect
        if body.elements.contains(elementView) {
            elementViewFrame = elementView.frame
        } else {
            if let superView = elementView.superview {
                elementViewFrame = superView.convert(elementView.frame, to: body.scrollView)
            } else {
                elementViewFrame = .zero
            }
        }
        UIView.animate(withDuration: duration, animations: {
            self.body.scrollView.contentOffset.y = elementViewFrame.origin.y
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
            self.blackOutScrollView.frame = self.view.safeAreaLayoutGuide.layoutFrame
            self.blackOutScrollView.contentOffset = .zero
            self.blackOutScrollView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            self.blackOutScrollView.contentSize.width = max(elementViewFrame.maxX, elementView.codeLabel.frame.maxX + elementView.frame.origin.x)
            self.blackOutScrollView.contentSize.height = max(elementViewFrame.maxY, elementView.codeLabel.frame.maxY + elementView.frame.origin.y)
            self.blackOutScrollView.contentSize.height += self.guideMessageCollectionView.bounds.height
            let buffer = CGSize(width: 8, height: 8)
            self.blackOutScrollView.contentSize.width += buffer.width
            self.blackOutScrollView.contentSize.height += buffer.height
            self.view.addSubview(self.blackOutScrollView)
            self.blackOutScrollView.addSubview(elementView)
            self.view.bringSubviewToFront(self.guideMessageCollectionView)
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
        //guideMessageCollectionView.isScrollEnabled = false
        UIView.animate(withDuration: duration, animations: {
            self.blackOutScrollView.alpha = 0
        }) { _ in
            self.blackOutScrollView.removeFromSuperview()
            elementView.unfocus()
            completion?()
        }
    }
    
    func unfocusAll(with duration: TimeInterval = 0.5, completion: (() -> Void)? = nil) {
        var focusedWebElementViews = [WebElementView]()
        for focusedView in blackOutScrollView.subviews {
            guard let focusedWebElementView = focusedView as? WebElementView else {
                continue
            }
            focusedWebElementViews.append(focusedWebElementView)
        }
        guard !focusedWebElementViews.isEmpty else {
            completion?()
            return
        }
        var finished = 0
        for focuedWebElementView in focusedWebElementViews {
            unfocus(elementView: focuedWebElementView) {
                finished += 1
                if finished == focusedWebElementViews.count {
                    completion?()
                }
            }
        }
    }
    
    func clearGuideSections() {
        guideSections.removeAll(keepingCapacity: true)
    }
    
    func appendGuideSection(_ guideTexts: [GuideText], onEnter: (((() -> Void)?) -> Void)? = nil, onExit: (((() -> Void)?) -> Void)? = nil) {
        var attributedTexts = [NSMutableAttributedString]()
        var syntaxHighlighter = SyntaxHighlighter()
        for guideText in guideTexts {
            let attributedText = NSMutableAttributedString(string: guideText.text, attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 18)])
            for programingLanguage in guideText.programingLanguages {
                syntaxHighlighter.programingLanguage = programingLanguage
                if programingLanguage == .php {
                    var phpSyntaxHighlighter = PHPSyntaxHighlighter()
                    phpSyntaxHighlighter.force = guideText.force
                    syntaxHighlighter.delegate = phpSyntaxHighlighter
                }
                _ = syntaxHighlighter.syntaxHighlight(attributedText)
            }
            attributedTexts.append(attributedText)
        }
        guideSections.append(GuideSection(attributedTexts: attributedTexts, onEnter: onEnter, onExit: onExit))
    }
    
    func addCloseButton() {
        guard !isAddedCloseButton else {
            return
        }
        isAddedCloseButton = true
        guideMessageCollectionView.reloadData()
    }
    
    func removeCloseButton() {
        guard isAddedCloseButton else {
            return
        }
        isAddedCloseButton = false
        guideMessageCollectionView.reloadData()
    }
    
    @objc
    func handleDisabledButton(_ sender: UIButton) {
        NotificationMessage.send(text: "全ての説明文を読むまでは次の画面に遷移できません。", axisX: .right, axisY: .center, size: nil, font: .boldSystemFont(ofSize: 18), textColor: .white, backgroundColor: .red, lifeSeconds: 2)
    }
    
    private func setupViews() {
        view.addSubview(body)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:))))
        body.margin = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        body.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            body.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            body.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            body.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            body.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        guideMessageCollectionView.isPagingEnabled = true
        guideMessageCollectionView.dataSource = self
        guideMessageCollectionView.delegate = self
        guideMessageCollectionView.frame.origin.y = view.frame.height
        guideMessageCollectionView.backgroundColor = .black
        guideMessageCollectionView.register(GuideMessageCollectionViewTextCell.self, forCellWithReuseIdentifier: WebSimulatorViewController.guideMessageCollectionViewTextCellId)
        guideMessageCollectionView.register(GuideMessageCollectionViewButtonCell.self, forCellWithReuseIdentifier: WebSimulatorViewController.guideMessageCollectionViewButtonCellId)
    }
    
    private func registerObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(observeKeyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(observeKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func handleTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc
    private func handleCloseButton(_ sender: UIButton) {
        guideMessageCollectionView.removeFromSuperview()
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
//    @objc
//    private func observeKeyboardNotification(_ notification: Notification) {
//        guard let userInfo = notification.userInfo else {
//            return
//        }
//        guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
//            return
//        }
//        guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
//            return
//        }
//        let keyboardHeight = keyboardRect.cgRectValue.height
//        UIView.animate(withDuration: animationDuration) {
//            if notification.name == UIResponder.keyboardWillShowNotification {
//                self.body.scrollView.contentSize.height += keyboardHeight
//                self.blackOutScrollView.contentSize.height += keyboardHeight
//            } else if notification.name == UIResponder.keyboardWillHideNotification {
//                self.body.scrollView.contentSize.height -= keyboardHeight
//                self.blackOutScrollView.contentSize.height -= keyboardHeight
//            }
//
//        }
//    }
    
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
            cell.textView.setContentOffset(.zero, animated: false)
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
        var onEnter: (((() -> Void)?) -> Void)?
        var onExit: (((() -> Void)?) -> Void)?
        for (index, guideSection) in guideSections.enumerated() {
            if !guideSection.isActive && index == section {
                guideSections[index].isActive = true
                //unfocusAll(with: 0)
                onEnter = guideSection.onEnter
            }
            else if guideSection.isActive && index != section {
                guideSections[index].isActive = false
                onExit = guideSection.onExit
            }
        }
        if onExit != nil {
            guideMessageCollectionView.isScrollEnabled = false
            onExit?() {
                if onEnter == nil {
                    self.guideMessageCollectionView.isScrollEnabled = true
                } else {
                    onEnter?() {
                        self.guideMessageCollectionView.isScrollEnabled = true
                    }
                }
            }
        } else if onEnter != nil {
            guideMessageCollectionView.isScrollEnabled = false
            onEnter?() {
                self.guideMessageCollectionView.isScrollEnabled = true
            }
        }
    }
    
}
