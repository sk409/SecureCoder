import UIKit

class LessonViewController: UIViewController {
    
    private static let guideMessageCollectionViewTextCellId = "guideMessageCollectionViewTextCellId"
    private static let guideMessageCollectionViewButtonCellId = "guideMessageCollectionViewButtonCellId"

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var lesson: Lesson? {
        didSet {
            guide = lesson?.guides[guideIndex]
            explainer = guide?.explainers[explainerIndex]
        }
    }
    var guideIndex = 0
    var explainerIndex = 0
    var guide: Guide?
    var explainer: Explainer?
    var codeEditorView: CodeEditorView?
    var font = UIFont.boldSystemFont(ofSize: 20)
    var tintColor = UIColor.white
    var lineSpacing: CGFloat = 8
    
    //let swipeIconImageView = UIImageView(image: UIImage(named: "swipe-icon"))
    let fileTableView = UITableView()
    let showGuideMessageButton = UIButton()
    let guideMessageView = GuideMessageView()
    
    private var codeEditorViews = [CodeEditorView]()
    private let swipeAnimation = SwipeAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layoutSubviews()
        showGuideMessageCollectionView(withSwipeIcon: true)
        changeCodeEditorView()
    }
    
    private func setupViews() {
        view.addSubview(fileTableView)
        view.addSubview(showGuideMessageButton)
        view.addSubview(guideMessageView)
        setupFileTableView()
        setupShowGuideMessageButton()
        setupCodeEditorViews()
        setupGuideMessageCollectionView()
    }
    
    private func layoutSubviews() {
        showGuideMessageButton.alpha = 1
        guideMessageView.frame = CGRect(
            x: view.safeAreaInsets.left,
            y: view.frame.height,
            width: view.safeAreaLayoutGuide.layoutFrame.width,
            height: view.safeAreaLayoutGuide.layoutFrame.height * 0.45
        )
        fileTableView.frame = CGRect(
            x: view.safeAreaInsets.left,
            y: view.safeAreaInsets.top,
            width: view.safeAreaLayoutGuide.layoutFrame.width * 0.25,
            height: view.safeAreaLayoutGuide.layoutFrame.height
        )
    }
    
    private func setupFileTableView() {
        fileTableView.dataSource = self
        fileTableView.delegate = self
        fileTableView.backgroundColor = UIColor(red: 46/255, green: 50/255, blue: 60/255, alpha: 1)
    }
    
    private func setupShowGuideMessageButton() {
        let size: CGFloat = 44
        showGuideMessageButton.alpha = 0
        showGuideMessageButton.layer.cornerRadius = (size / 2)
        showGuideMessageButton.backgroundColor = .forestGreen
        showGuideMessageButton.titleLabel?.font = .boldSystemFont(ofSize: 24)
        showGuideMessageButton.setTitle("?", for: .normal)
        showGuideMessageButton.setTitleColor(.white, for: .normal)
        showGuideMessageButton.addTarget(self, action: #selector(handleShowGuideMessageButton(_:)), for: .touchUpInside)
        showGuideMessageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showGuideMessageButton.leadingAnchor.constraint(equalTo: fileTableView.trailingAnchor, constant: 8),
            showGuideMessageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            showGuideMessageButton.widthAnchor.constraint(equalToConstant: size),
            showGuideMessageButton.heightAnchor.constraint(equalTo: showGuideMessageButton.widthAnchor),
            ])
    }
    
    private func setupCodeEditorViews() {
        guard let lesson = lesson else {
            return
        }
        for domain in lesson.domains {
            for file in domain.files {
                let codeEditorView = CodeEditorView()
                codeEditorViews.append(codeEditorView)
                codeEditorView.file = file
                codeEditorView.scrollBuffer = CGSize(width: 0, height: view.frame.height * 0.5)
                let editorComponents = EditorComponentsBuilder().build(origin: CGPoint(x: 0, y: 15), font: font, tintColor: tintColor, text: file.text, lineSpacing: lineSpacing, language: file.programingLanguage)
                codeEditorView.components = editorComponents
                codeEditorView.setNextQuestion()
                if let questions = codeEditorView.questions {
                    for (questionIndex, question) in questions.enumerated() {
                        question.keyboardView = KeyboardViewFactory.make(name: [lesson.title, file.name, String(questionIndex)].joined(separator: "_"))!
                        question.keyboardView?.backgroundColor = UIColor(white: 0.125, alpha: 1)
                        question.keyboardView?.buttons.forEach { button in
                            button.backgroundColor = UIColor(white: 0.25, alpha: 1)
                            button.addTarget(self, action: #selector(handleKeyboardButton(_:)), for: .touchUpInside)
                        }
                    }
                }
            }
        }
    }
    
//    private func setupSeparatorView() {
////        separatorView.backgroundColor = UIColor(white: 0.75, alpha: 1)
////        separatorView.translatesAutoresizingMaskIntoConstraints = false
////        NSLayoutConstraint.activate([
////            separatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
////            separatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
////            separatorView.topAnchor.constraint(equalTo: guideMessageCollectionView.topAnchor),
////            separatorView.heightAnchor.constraint(equalToConstant: 3),
////            ])
//    }
    
    private func setupGuideMessageCollectionView() {
        guideMessageView.collectionView.dataSource = self
        guideMessageView.collectionView.delegate = self
        guideMessageView.collectionView.isPagingEnabled = true
        guideMessageView.collectionView.bounces = false
        guideMessageView.collectionView.register(GuideMessageCollectionViewTextCell.self, forCellWithReuseIdentifier: LessonViewController.guideMessageCollectionViewTextCellId)
        guideMessageView.collectionView.register(GuideMessageCollectionViewButtonCell.self, forCellWithReuseIdentifier: LessonViewController.guideMessageCollectionViewButtonCellId)
    }
    
    private func changeCodeEditorView() {
        guard let lesson = lesson, let guide = guide else {
            return
        }
        var domainIndex: Int?
        var fileIndex: Int?
        for (di, domain) in lesson.domains.enumerated() {
            for (fi, file) in domain.files.enumerated() {
                if file.name == guide.fileName {
                    domainIndex = di
                    fileIndex = fi
                    break
                }
            }
            if domainIndex != nil && fileIndex != nil {
                break
            }
        }
        if let di = domainIndex, let fi = fileIndex {
            changeCodeEditorView(
                domainIndex: di,
                fileIndex: fi
            )
        }
    }
    
    private func changeCodeEditorView(domainIndex: Int, fileIndex: Int) {
        guard let lesson = lesson else {
            return
        }
        codeEditorViews.forEach { $0.removeFromSuperview() }
        let codeEditorViewIndex = lesson.domains.prefix(domainIndex).reduce(0, { $0 + $1.files.count }) + fileIndex
        let codeEditorView = codeEditorViews[codeEditorViewIndex]
        self.codeEditorView = codeEditorView
        view.addSubview(codeEditorView)
        view.sendSubviewToBack(codeEditorView)
        codeEditorView.frame = CGRect(
            x: fileTableView.frame.maxX,
            y: view.safeAreaInsets.top,
            width: view.safeAreaLayoutGuide.layoutFrame.width - fileTableView.bounds.width,
            height: view.safeAreaLayoutGuide.layoutFrame.height
        )
        fileTableView.selectRow(at: IndexPath(row: fileIndex, section: domainIndex), animated: true, scrollPosition: .top)
    }
    
    private func showGuideMessageCollectionView(withSwipeIcon swipeIcon: Bool = false, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.guideMessageView.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.height - self.guideMessageView.frame.height
            self.fileTableView.frame.size.height = self.view.bounds.height -  self.guideMessageView.frame.height
        }) { _ in
            if swipeIcon {
                self.swipeAnimation.start(on: self.view)
            }
            completion?()
        }
    }
    
    private func hideGuideMessageTextView(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5, animations: {
            self.guideMessageView.frame.origin.y = self.view.frame.height
            self.fileTableView.frame.size.height = self.view.safeAreaLayoutGuide.layoutFrame.height
        }) { _ in
            completion()
        }
    }
    
    @objc
    private func handleShowGuideMessageButton(_ sender: UIButton) {
        codeEditorView?.question?.activate(isActive: false, keyboardViewDidShow: nil) {
            self.showGuideMessageCollectionView()
        }
    }
    
    @objc
    private func handleKeyboardButton(_ sender: KeyboardButton) {
        if guide?.fileName != codeEditorView?.file?.name {
            changeCodeEditorView()
        }
        guard let codeEditorView = codeEditorView,
            let question = codeEditorView.question
        else {
            return
        }
        let newText = question.text! + sender.title(for: .normal)!
        let isCompleted = question.answer == newText
        let isCorrect = question.answer.hasPrefix(newText)
        if isCompleted || isCorrect {
            let attributedText = NSMutableAttributedString(attributedString: question.attributedText ?? NSAttributedString())
            attributedText.append(NSAttributedString(string: sender.title(for: .normal)!, attributes: [.foregroundColor: sender.titleColor(for: .normal)!]))
            question.attributedText = attributedText
            question.moveCaret()
            let questionMaxX = question.frame.origin.x + question.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity)).width
            let scrollViewMaxX = codeEditorView.scrollView.contentOffset.x + codeEditorView.scrollView.bounds.width
            if scrollViewMaxX <= questionMaxX {
                UIView.animate(withDuration: 0.2) {
                    codeEditorView.scrollView.contentOffset.x = questionMaxX - codeEditorView.scrollView.bounds.width
                }
            }
            sender.count -= 1
            if sender.count == 0 {
                var hue: CGFloat = 0
                var saturation: CGFloat = 0
                var brightness: CGFloat = 0
                var alpha: CGFloat = 0
                sender.backgroundColor!.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
                sender.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness * 0.25, alpha: alpha)
                sender.isEnabled = false
            }
        }
        let notificationMessage: String
        let notificationBackgroundColor: UIColor
        let notificationSize: CGSize
        if isCompleted {
            notificationMessage = "正解"
            notificationBackgroundColor = .forestGreen
            notificationSize = CGSize(width: 64, height: 44)
            lesson?.guides[guideIndex].explainers[explainerIndex].questionIndices.removeFirst()
            question.activate(isActive: false, keyboardViewDidShow: nil, keyboardViewDidHide: {
                guard let explainer = self.explainer else {
                    return
                }
                codeEditorView.setNextQuestion()
                if explainer.questionIndices.isEmpty {
                    self.guideMessageView.collectionView.reloadData()
                    self.showGuideMessageCollectionView()
                } else {
                    if let codeEditorView = self.codeEditorView {
                        codeEditorView.question?.activate(isActive: true, keyboardViewDidShow: nil, keyboardViewDidHide: nil)
                        if let question = codeEditorView.question {
                            codeEditorView.scroll(to: question)
                            codeEditorView.fit()
                            codeEditorView.scrollView.contentSize.height = max(codeEditorView.scrollView.contentSize.height, question.frame.maxY + self.view.bounds.height - question.bounds.height)
                        }
                    }
                }
            })
        } else if isCorrect {
            notificationMessage = "○"
            notificationBackgroundColor = .forestGreen
            notificationSize = CGSize(width: 44, height: 44)
        } else {
            notificationMessage = "✖︎"
            notificationBackgroundColor = .red
            notificationSize = CGSize(width: 44, height: 44)
        }
        NotificationMessage.send(text: notificationMessage, axisX: .center, axisY: .center, size: notificationSize, font: .boldSystemFont(ofSize: 24), textColor: .white, backgroundColor: notificationBackgroundColor, lifeSeconds: 1)
    }
    
    @objc
    private func handleShowKeyboardViewButton(_ sender: UIButton) {
        hideGuideMessageTextView {
            if self.guide?.fileName != self.codeEditorView?.file?.name {
                self.changeCodeEditorView()
            }
            if let codeEditorView = self.codeEditorView, let question = self.codeEditorView?.question {
                codeEditorView.question?.activate(isActive: true, keyboardViewDidShow: nil, keyboardViewDidHide: nil)
                codeEditorView.fit()
                codeEditorView.scrollView.contentSize.height = max(codeEditorView.scrollView.contentSize.height, question.frame.maxY + self.view.bounds.height - question.bounds.height)
                codeEditorView.scroll(to: question)
            }
        }
    }
    
    @objc
    private func handleShowPreviewButton(_ sender: UIButton) {
        guard let lessonTitle = lesson?.title,
            let previewViewController = WebSimulatorViewControllerFactory.make(lessonTitle: lessonTitle)
            else {
                return
        }
        present(previewViewController, animated: true)
    }
    
    
}

extension LessonViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lesson?.domains.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lesson?.domains[section].files.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = lesson?.domains[indexPath.section].files[indexPath.row].name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .systemFont(ofSize: 14)
        cell.textLabel?.numberOfLines = 0
        cell.contentView.backgroundColor = UIColor(red: 46/255, green: 50/255, blue: 60/255, alpha: 1)
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1)
        cell.selectedBackgroundView = selectedBackgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 63/255, green: 63/255, blue: 63/255, alpha: 1)
        label.font = .boldSystemFont(ofSize: 16)
        label.text = lesson?.domains[section].name
        label.textColor = .white
        label.numberOfLines = 0
        label.layoutMargins = UIEdgeInsets(top: -16, left: 0, bottom: 0, right: 0)
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeCodeEditorView(domainIndex: indexPath.section, fileIndex: indexPath.row)
    }
    
    
}

extension LessonViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let lesson = lesson else {
            return 0
        }
        var numberOfSection = 0
        for guide in lesson.guides {
            for explainer in guide.explainers {
                numberOfSection += 1
                if !explainer.questionIndices.isEmpty {
                    return numberOfSection
                }
            }
        }
        return numberOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let lesson = lesson else {
            return 0
        }
        var explainerIndex = 0
        for (guideIndex, guide) in lesson.guides.enumerated() {
            for (eIndex, explainer) in guide.explainers.enumerated() {
                if explainerIndex == section {
                    let messageCount = explainer.questionIndices.isEmpty ? explainer.messages.count : 1
                    if guideIndex == (lesson.guides.count - 1) && (eIndex == guide.explainers.count - 1) && explainer.questionIndices.isEmpty
                    {
                        return messageCount + 1
                    } else {
                        return messageCount
                    }
                }
                explainerIndex += 1
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let lesson = lesson else {
            return UICollectionViewCell()
        }
        var section = 0
        var explainer: Explainer?
        for guide in lesson.guides {
            for e in guide.explainers {
                if section == indexPath.section && indexPath.item < e.messages.count {
                    explainer = e
                    break
                }
                section += 1
            }
            if explainer != nil {
                break
            }
        }
        if explainer == nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LessonViewController.guideMessageCollectionViewButtonCellId, for: indexPath) as! GuideMessageCollectionViewButtonCell
            cell.buttonTitle = "プレビューを確認する"
            cell.button.removeTarget(self, action: #selector(handleShowPreviewButton(_:)), for: .touchUpInside)
            cell.button.addTarget(self, action: #selector(handleShowPreviewButton(_:)), for: .touchUpInside)
            return cell
        } else {
            if !explainer!.questionIndices.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LessonViewController.guideMessageCollectionViewButtonCellId, for: indexPath) as! GuideMessageCollectionViewButtonCell
                cell.buttonTitle = "問題を解く"
                cell.button.removeTarget(self, action: #selector(handleShowKeyboardViewButton(_:)), for: .touchUpInside)
                cell.button.addTarget(self, action: #selector(handleShowKeyboardViewButton(_:)), for: .touchUpInside)
                return cell
            } else {
                var syntaxHighlighter = SyntaxHighlighter(tintColor: .white, font: .boldSystemFont(ofSize: 16), lineSpacing: lineSpacing)
                syntaxHighlighter.delegate = GuideTextSyntaxHighlighter()
                var attributedText = syntaxHighlighter.syntaxHighlight(explainer!.messages[indexPath.item].text)
                explainer!.messages[indexPath.item].languages.forEach { language in
                    syntaxHighlighter.programingLanguage = language
                    if language == .php {
                        var phpSyntaxHighlighter = PHPSyntaxHighlighter()
                        phpSyntaxHighlighter.force = true
                        syntaxHighlighter.delegate = phpSyntaxHighlighter
                    }
                    attributedText = syntaxHighlighter.syntaxHighlight(attributedText)
                }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LessonViewController.guideMessageCollectionViewTextCellId, for: indexPath) as! GuideMessageCollectionViewTextCell
                cell.textView.isEditable = false
                cell.textView.isSelectable = false
                cell.textView.attributedText = attributedText
                return cell
            }
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
        guard scrollView == guideMessageView.collectionView, let lesson = lesson else {
            return
        }
        swipeAnimation.stop()
        if guide?.fileName != codeEditorView?.file?.name {
            changeCodeEditorView()
        }
        var found = false
        var x: CGFloat = 0
        var guideIndex = 0
        var explainerIndex = 0
        for (gIndex, guide) in lesson.guides.enumerated() {
            guideIndex = gIndex
            for (eIndex, explainer) in guide.explainers.enumerated() {
                for _ in explainer.messages {
                    if scrollView.contentOffset.x <= x {
                        found = true
                        explainerIndex = eIndex
                        break
                    }
                    x += scrollView.bounds.width
                }
                if found {
                    break
                }
            }
            if found {
                break
            }
        }
        guard self.guideIndex != guideIndex || self.explainerIndex != explainerIndex else {
            return
        }
        if self.guideIndex != guideIndex {
            guide = lesson.guides[guideIndex]
            changeCodeEditorView()
        }
        explainer = lesson.guides[guideIndex].explainers[explainerIndex]
        codeEditorView?.removeAllFocusableViews()
        if let explainer = explainer {
            codeEditorView?.focus(labelTexts: explainer.focusLabels, componentIndices: explainer.focusComponents)
        }
        self.guideIndex = guideIndex
        self.explainerIndex = explainerIndex
    }
    
}
