import UIKit

class LessonViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var lesson: Lesson? {
        didSet {
            guide = lesson?.guides.first
        }
    }
    var codeEditorViewIndexPath: IndexPath? {
        guard let lesson = lesson, let guide = guide else {
                return nil
        }
        for (domainIndex, domain) in lesson.domains.enumerated() {
            for (fileIndex, file) in domain.files.enumerated() {
                if file.name == guide.fileName {
                    return IndexPath(row: fileIndex, section: domainIndex)
                }
            }
        }
        return nil
    }
    var guide: Guide?
    var codeEditorView: CodeEditorView?
    var guideMessageTextView: GuideMessageTextView?
    var font = UIFont.boldSystemFont(ofSize: 20)
    var tintColor = UIColor.white
    
    let fileTableView = FileTableView()
    let showPreviewButton = UIButton()
    
    private var codeEditorViews = [CodeEditorView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layoutSubviews()
        setGuideMessageTextView()
        showGuideMessageTextView(completion: nil)
        changeCodeEditorView()
    }
    
    private func setupViews() {
        view.addSubview(fileTableView)
        view.addSubview(showPreviewButton)
        setupFileTableView()
        setupCodeEditorViews()
        setupShowPreviewButton()
    }
    
    private func layoutSubviews() {
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
                let editorComponents = EditorComponentsBuilder().build(origin: CGPoint(x: 0, y: 15), font: font, tintColor: tintColor, text: file.text, language: file.programingLanguage)
                codeEditorView.components = editorComponents
                if let questions = codeEditorView.questions {
                    for (questionIndex, question) in questions.enumerated() {
                        question.keyboardView = KeyboardViewFactory.make(name: [lesson.title, file.name, String(questionIndex)].joined(separator: "_"))!
                        question.keyboardView?.backgroundColor = .darkGray
                        question.keyboardView?.buttons.forEach { button in
                            button.backgroundColor = .lightGray
                            button.addTarget(self, action: #selector(handleKeyboardButton(_:)), for: .touchUpInside)
                        }
                    }
                }
            }
        }
    }

    private func setupShowPreviewButton() {
        showPreviewButton.alpha = 0
        showPreviewButton.setBackgroundImage(UIImage(named: "next_button"), for: .normal)
        showPreviewButton.addTarget(self, action: #selector(handleShowPreviewButton(_:)), for: .touchUpInside)
        showPreviewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showPreviewButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            showPreviewButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            showPreviewButton.widthAnchor.constraint(equalToConstant: 44),
            showPreviewButton.heightAnchor.constraint(equalTo: showPreviewButton.widthAnchor),
            ])
    }
    
    private func changeCodeEditorView() {
        guard let codeEditorViewIndexPath = codeEditorViewIndexPath else {
            return
        }
        changeCodeEditorView(
            domainIndex: codeEditorViewIndexPath.section,
            fileIndex: codeEditorViewIndexPath.row
        )
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
    
    private func setGuideMessageTextView() {
        guard let explainers = guide?.explainers else {
            return
        }
        guideMessageTextView?.removeFromSuperview()
        guideMessageTextView = GuideMessageTextView()
        guard let guideMessageTextView = guideMessageTextView else {
            return
        }
        view.addSubview(guideMessageTextView)
        guideMessageTextView.frame = CGRect(
            x: view.safeAreaInsets.left,
            y: view.frame.height,
            width: view.safeAreaLayoutGuide.layoutFrame.width,
            height: view.safeAreaLayoutGuide.layoutFrame.height * 0.45
        )
        guideMessageTextView.isEditable = false
        guideMessageTextView.settingNewExplainerHandler = handleGuideMessageTextViewSettingNewExplainer
        guideMessageTextView.endNotificationHandler = handleGuideMessageTextViewEndNotification
        guideMessageTextView.explainers = explainers
    }
    
    private func showGuideMessageTextView(completion: (() -> Void)?) {
        guard let guideMessageTextView = guideMessageTextView else {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            guideMessageTextView.frame.origin.y = self.view.safeAreaLayoutGuide.layoutFrame.height - guideMessageTextView.frame.height
            self.fileTableView.frame.size.height -= guideMessageTextView.frame.height
        }) { _ in
            completion?()
        }
    }
    
    private func hideGuideMessageTextView(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5, animations: {
            self.guideMessageTextView?.frame.origin.y = self.view.frame.height
            self.fileTableView.frame.size.height = self.view.safeAreaLayoutGuide.layoutFrame.height
        }) { _ in
            completion()
        }
    }
    
    private func handleCodeEditorViewDrawFunction(_ sender: CodeEditorView) {
        setGuideMessageTextView()
        showGuideMessageTextView() {
            guard let codeEditorViewIndexPath = self.codeEditorViewIndexPath else {
                return
            }
            self.fileTableView.scrollToRow(at: codeEditorViewIndexPath, at: .top, animated: true)
        }
        sender.drawFunctionHandler = nil
    }
    
    private func handleGuideMessageTextViewSettingNewExplainer(_ sender: GuideMessageTextView) {
        codeEditorView?.removeAllFocusableViews()
        if sender.questionIndices.isEmpty {
            guard let explainer = sender.explainer, let codeEditorView = codeEditorView else {
                return
            }
            codeEditorView.focus(labelTexts: explainer.focusLabels, componentIndices: explainer.focusComponents)
            sender.setMessage()
        } else {
            codeEditorView?.setNextQuestion()
            hideGuideMessageTextView {
                if let codeEditorView = self.codeEditorView, let question = self.codeEditorView?.question {
                    codeEditorView.scroll(to: question)
                    codeEditorView.fit()
                    codeEditorView.scrollView.contentSize.height = max(codeEditorView.scrollView.contentSize.height, question.frame.maxY + self.view.bounds.height - question.bounds.height)
                }
            }
        }
    }
    
    private func handleGuideMessageTextViewEndNotification(_ sender: GuideMessageTextView) {
        guard let lesson = lesson, let guide = guide, let guideIndex = lesson.guides.firstIndex(of: guide) else {
            return
        }
        hideGuideMessageTextView {
            sender.removeFromSuperview()
            let nextGuideIndex = (guideIndex + 1)
            if nextGuideIndex < lesson.guides.count {
                self.guide = lesson.guides[nextGuideIndex]
                self.changeCodeEditorView()
                if let codeEditorView = self.codeEditorView {
                    codeEditorView.drawFunctionHandler = self.handleCodeEditorViewDrawFunction
                }
            } else {
                let animationDuration: TimeInterval = 0.5
                self.codeEditorView?.components?.forEach { ($0 as? TemplateLabel)?.unfocus(with: animationDuration) }
                UIView.animate(withDuration: animationDuration) {
                    self.showPreviewButton.alpha = 1
                }
            }
        }
    }
    
    @objc
    private func handleKeyboardButton(_ sender: KeyboardButton) {
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
        if isCompleted {
            notificationMessage = "正解"
            notificationBackgroundColor = .forestGreen
            if let guideMessageTextView = guideMessageTextView {
                guideMessageTextView.questionIndices.removeFirst()
                question.activate(isActive: false, keyboardViewDidShow: nil, keyboardViewDidHide: {
                    if guideMessageTextView.questionIndices.isEmpty {
                        guideMessageTextView.setMessage()
                        self.showGuideMessageTextView(completion: nil)
                    } else {
                        if let codeEditorView = self.codeEditorView, let question = codeEditorView.question {
                            codeEditorView.setNextQuestion()
                            codeEditorView.scroll(to: question)
                            codeEditorView.fit()
                            codeEditorView.scrollView.contentSize.height = max(codeEditorView.scrollView.contentSize.height, question.frame.maxY + self.view.bounds.height - question.bounds.height)
                        }
                    }
                })
            }
        } else if isCorrect {
            notificationMessage = "○"
            notificationBackgroundColor = .forestGreen
        } else {
            notificationMessage = "✖︎"
            notificationBackgroundColor = .red
        }
        NotificationMessage.send(text: notificationMessage, axisX: .right, axisY: .center, size: nil, font: .boldSystemFont(ofSize: 24), textColor: .white, backgroundColor: notificationBackgroundColor, lifeSeconds: 1)
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
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let lesson = lesson, let guide = guide, let guideIndex = lesson.guides.firstIndex(of: guide) else {
            return nil
        }
        guard guideIndex == (lesson.guides.count - 1) else {
            NotificationMessage.send(text: "全ての説明を読むまでファイルの変更はできません", axisX: .right, axisY: .center, size: nil, font: .boldSystemFont(ofSize: 18), textColor: .white, backgroundColor: .red, lifeSeconds: 2)
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeCodeEditorView(domainIndex: indexPath.section, fileIndex: indexPath.row)
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
    
    
}

//// ターゲットを明確にして何を学ばせるかを掘り下げる(コード以外にもミドルウェアなども？)
//// コンテンツで差別化を図る
//// 脆弱性を絞ってレッスンを作る
//// 脆弱性を実際に作らせる
//// それを改善させる
//// 問題があった箇所に線を引く
//// 間違った場所を問題にする
//// CYDERではできないことをできる(表面的な対応ではなく裏側のこと)
//
//
//import UIKit
//import WebKit
//
//class CodeEditorViewController: UIViewController {
//    
//    private static let cellID = "CELL"
//    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//    
//    var lesson: Lesson?
//    
//    private var font = UIFont.boldSystemFont(ofSize: 18)
//    private var tintColor = UIColor.white
//    private var activeCodeEditorView: CodeEditorView?
//    private var codeEditorViews = [CodeEditorView]()
//    
//    private let showPreviewWebViewButton = UIButton()
//    private let showAnswerWebViewButton = UIButton()
//    private let webViewContainer = UIView()
//    private let previewWebView = WKWebView()
//    private let answerWebView = WKWebView()
//    private let codeEditorViewContainer = UIView()
//    private let filesTableView = UITableView()
//    private let fileButton = UIButton()
//    private let blackOutView = UIView()
//    private let descriptionView = DescriptionView()
//    private let slidesLauncher = SlidesLauncher()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupSubviews()
//        loadUserFile()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if let slides = lesson?.slides {
//            slidesLauncher.show(slides: slides)
//        }
//    }
//
//    private func setupSubviews() {
//        view.addSubview(codeEditorViewContainer)
//        view.addSubview(filesTableView)
//        view.addSubview(fileButton)
//        view.addSubview(webViewContainer)
//        setupWebviews()
//        setupFileButton()
//        setupFilesTableView()
//        setupDescriptionView()
//        setupCodeEditorViewContainer()
//        setupCodeEditorViews()
//    }
//    
//    private func setupCodeEditorViewContainer() {
//        codeEditorViewContainer.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            codeEditorViewContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            codeEditorViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            codeEditorViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            codeEditorViewContainer.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.55)
//            ])
//    }
//    
//    private func setupCodeEditorViews() {
//        guard let lesson = lesson else {
//            return
//        }
//        for file in lesson.files {
//            guard let `extension` = file.extension else {
//                continue
//            }
//            let codeEditorView = CodeEditorView()
//            codeEditorViews.append(codeEditorView)
//            codeEditorView.questionDidChangeEventHandler = handleQuestionDidChangeEvent(_:)
//            setupCodeEditorViewComponents(codeEditorView: codeEditorView, lessonText: file.text, language: ProgramingLanguage(extension: `extension`))
//            setupQuestions(codeEditorView.questions)
//            codeEditorView.setNextQuestion()
//            setUserAnswersToQuestionTextFields(file: file, questions: codeEditorView.questions)
//            if codeEditorView.isCompleted {
//                changeCodeEditorView(to: codeEditorView)
//            }
//        }
//        if activeCodeEditorView == nil,
//           let indexFile = lesson.index,
//           let indexFileIndex = lesson.files.firstIndex(where: {$0.title == indexFile.title })
//        {
//            changeCodeEditorView(to: codeEditorViews[indexFileIndex])
//        }
//    }
//    
//    private func setupFilesTableView() {
//        filesTableView.dataSource = self
//        filesTableView.delegate = self
//        filesTableView.register(FileTableViewCell.self, forCellReuseIdentifier: CodeEditorViewController.cellID)
//        filesTableView.tableFooterView = UIView()
//        filesTableView.backgroundColor = .lightGray
//        filesTableView.frame = CGRect(
//            x: view.bounds.width,
//            y: 0,
//            width: view.bounds.width * 0.4,
//            height: view.bounds.height)
//    }
//    
//    private func setupFileButton() {
//        let fileButtonSize: CGFloat = 44
//        fileButton.layer.cornerRadius = fileButtonSize * 0.5
//        fileButton.setBackgroundImage(UIImage(named: "file-icon"), for: .normal)
//        fileButton.addTarget(self, action: #selector(handleFileButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
//        fileButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            fileButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
//            fileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
//            fileButton.widthAnchor.constraint(equalToConstant: fileButtonSize),
//            fileButton.heightAnchor.constraint(equalTo: fileButton.widthAnchor),
//            ])
//    }
//    
//    private func setupWebviews() {
//        let webViewButtonsContainer = UIView()
//        view.addSubview(webViewButtonsContainer)
//        webViewButtonsContainer.backgroundColor = UIColor(white: 0.8, alpha: 1)
//        webViewButtonsContainer.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            webViewButtonsContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            webViewButtonsContainer.trailingAnchor.constraint(equalTo: codeEditorViewContainer.leadingAnchor),
//            webViewButtonsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            webViewButtonsContainer.heightAnchor.constraint(equalToConstant: 44),
//            ])
//        let webViewButtonsSeparator = UIView()
//        webViewButtonsContainer.addSubview(webViewButtonsSeparator)
//        webViewButtonsSeparator.backgroundColor = UIColor(white: 0.5, alpha: 1)
//        webViewButtonsSeparator.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            webViewButtonsSeparator.centerXAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.centerXAnchor),
//            webViewButtonsSeparator.centerYAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.centerYAnchor),
//            webViewButtonsSeparator.widthAnchor.constraint(equalToConstant: 1),
//            webViewButtonsSeparator.heightAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6666)
//            ])
//        webViewButtonsContainer.addSubview(showPreviewWebViewButton)
//        showPreviewWebViewButton.setTitle("プレビュー", for: .normal)
//        showPreviewWebViewButton.setTitleColor(.black, for: .normal)
//        showPreviewWebViewButton.titleLabel?.font = .systemFont(ofSize: 14)
//        showPreviewWebViewButton.addTarget(self, action: #selector(showPreviewWebView), for: .touchUpInside)
//        showPreviewWebViewButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            showPreviewWebViewButton.leadingAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.leadingAnchor),
//            showPreviewWebViewButton.trailingAnchor.constraint(equalTo: webViewButtonsSeparator.leadingAnchor),
//            showPreviewWebViewButton.topAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.topAnchor),
//            showPreviewWebViewButton.bottomAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.bottomAnchor),
//            ])
//        webViewButtonsContainer.addSubview(showAnswerWebViewButton)
//        showAnswerWebViewButton.setTitle("見本", for: .normal)
//        showAnswerWebViewButton.setTitleColor(.black, for: .normal)
//        showAnswerWebViewButton.titleLabel?.font = .systemFont(ofSize: 14)
//        showAnswerWebViewButton.addTarget(self, action: #selector(showAnswerWebView), for: .touchUpInside)
//        showAnswerWebViewButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            showAnswerWebViewButton.leadingAnchor.constraint(equalTo: webViewButtonsSeparator.trailingAnchor),
//            showAnswerWebViewButton.topAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.topAnchor),
//            showAnswerWebViewButton.bottomAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.bottomAnchor),
//            showAnswerWebViewButton.widthAnchor.constraint(equalTo: showPreviewWebViewButton.widthAnchor)
//            ])
//        webViewContainer.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            webViewContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            webViewContainer.trailingAnchor.constraint(equalTo: codeEditorViewContainer.leadingAnchor),
//            webViewContainer.topAnchor.constraint(equalTo: webViewButtonsContainer.bottomAnchor),
//            webViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            ])
//        if let indexFile = lesson?.index {
//            answerWebView.load(URLRequest(url: indexFile.answerURL))
//        }
//        showPreviewWebView()
//    }
//
//    private func setupQuestions(_ questions: [QuestionTextField]) {
//        for question in questions {
//            question.keyboardView.backgroundColor = UIColor(white: 0.25, alpha: 1)
//            for button in question.keyboardView.buttons {
//                button.backgroundColor = UIColor(white: 0.35, alpha: 1)
//                button.layer.borderColor = UIColor.white.cgColor
//                button.layer.borderWidth = 0.25
//                button.setTitleColor(.white, for: .normal)
//                button.addTarget(self, action: #selector(handleKeyboardButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
//            }
//        }
//    }
//    
//    private func setupCodeEditorViewComponents(codeEditorView: CodeEditorView, lessonText: String, language: ProgramingLanguage) {
//        let editorComponents = EditorComponentsBuilder().build(
//            pointer: .zero,
//            font: font,
//            tintColor: tintColor,
//            lessonText: lessonText,
//            language: language)
//        editorComponents.forEach { editorComponent in
//            let bufferSize = CGSize(width: 64, height: 132)
//            codeEditorView.scrollView.addSubview(editorComponent)
//            codeEditorView.scrollView.contentSize.width = max(
//                codeEditorView.scrollView.contentSize.width,
//                editorComponent.frame.origin.x + editorComponent.bounds.width + bufferSize.width)
//            codeEditorView.scrollView.contentSize.height = max(codeEditorView.scrollView.contentSize.height,
//                                                               editorComponent.frame.origin.y + editorComponent.bounds.height + bufferSize.height)
//            if let question = editorComponent as? QuestionTextField {
//                question.editorView = codeEditorView
//                question.addTarget(self, action: #selector(handleQuestionTextFieldEditingChangedEvent(_:)), for: .editingChanged)
//                codeEditorView.questions.append(question)
//            }
//        }
//    }
//    
//    private func setupDescriptionView() {
//        view.addSubview(blackOutView)
//        blackOutView.alpha = 0
//        blackOutView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
//        view.addSubview(descriptionView)
//        descriptionView.alpha = 0
//        descriptionView.backgroundColor = .make(fromHex: "#3b485f")
//        descriptionView.translatesAutoresizingMaskIntoConstraints = false
//        descriptionView.closeButton.addTarget(self, action: #selector(hideDescriptionView), for: .touchUpInside)
//        NSLayoutConstraint.activate([
//            descriptionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            descriptionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            descriptionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            descriptionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
//            ])
//    }
//    
//    private func setUserAnswersToQuestionTextFields(file: File, questions: [QuestionTextField]) {
//        guard let userText = try? String(contentsOf: file.userURL),
//              let language = file.programingLanguage
//        else {
//            return
//        }
//        let userAnswers = TextUtils.extractUserAnswers(userText: userText, language: language)
//        for (userAnswerIndex, userAnswer) in userAnswers.enumerated() {
//            guard !userAnswer.isEmpty else {
//                break
//            }
//            questions[userAnswerIndex].insertText(userAnswer)
//        }
//    }
//    
//    private func changeCodeEditorView(to codeEditorView: CodeEditorView) {
//        guard let lesson = lesson,
//              let codeEditorViewIndex = codeEditorViews.firstIndex(of: codeEditorView),
//              let descriptions = lesson.descriptios[lesson.files[codeEditorViewIndex].title] else {
//            return
//        }
//        descriptionView.descriptions = descriptions
//        descriptionView.titleLabels.forEach { titleLabel in
//            titleLabel.textColor = .black
//            titleLabel.font = .boldSystemFont(ofSize: 24)
//        }
//        descriptionView.contentTextViews.forEach { contentTextView in
//            contentTextView.textColor = .black
//            contentTextView.font = .systemFont(ofSize: 20)
//            contentTextView.backgroundColor = .clear
//        }
//        descriptionView.separatorViews.forEach { $0.backgroundColor = .white }
//        activeCodeEditorView = codeEditorView
//        codeEditorViewContainer.subviews.forEach { $0.removeFromSuperview() }
//        codeEditorViewContainer.addSubview(codeEditorView)
//        codeEditorView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            codeEditorView.leadingAnchor.constraint(equalTo: codeEditorViewContainer.safeAreaLayoutGuide.leadingAnchor),
//            codeEditorView.trailingAnchor.constraint(equalTo: codeEditorViewContainer.safeAreaLayoutGuide.trailingAnchor),
//            codeEditorView.topAnchor.constraint(equalTo: codeEditorViewContainer.safeAreaLayoutGuide.topAnchor),
//            codeEditorView.bottomAnchor.constraint(equalTo: codeEditorViewContainer.safeAreaLayoutGuide.bottomAnchor),
//            ])
//    }
//    
//    private func showDescriptionView(descriptionIndex: Int) {
//        blackOutView.frame = view.bounds
//        descriptionView.selectedDescriptionIndex = descriptionIndex
//        descriptionView.scrollToDescription(at: descriptionIndex, animate: false)
//        UIView.animate(withDuration: 0.5) {
//            self.blackOutView.alpha = 1
//            self.descriptionView.alpha = 1
//        }
//    }
//    
//    @objc
//    private func hideDescriptionView() {
//        UIView.animate(withDuration: 0.5) {
//            self.blackOutView.alpha = 0
//            self.descriptionView.alpha = 0
//        }
//    }
//    
//    private func playCorrectAnimation() {
//        let font = UIFont.boldSystemFont(ofSize: 18)
//        playNotificationAnimation(
//            text: "正解!!",
//            font: font,
//            width: 64,
//            textColor: .white,
//            backgroundColor: .forestGreen
//        )
//    }
//    
//    private func playOKAnimation() {
//        let text = "○"
//        let font = UIFont.boldSystemFont(ofSize: 24)
//        playNotificationAnimation(
//            text: text,
//            font: font,
//            width: 64,
//            textColor: .white,
//            backgroundColor: .forestGreen
//        )
//    }
//    
//    private func playNGAnimation() {
//        let text = "×"
//        let font = UIFont.boldSystemFont(ofSize: 24)
//        playNotificationAnimation(
//            text: text,
//            font: font,
//            width: 64,
//            textColor: .white,
//            backgroundColor: .signalRed
//        )
//    }
//    
//    private func playNotificationAnimation(text: String, font: UIFont, width: CGFloat, textColor: UIColor, backgroundColor: UIColor) {
//        let label = UILabel()
//        view.addSubview(label)
//        label.text = text
//        label.textColor = textColor
//        label.textAlignment = .center
//        label.font = font
//        label.backgroundColor = backgroundColor
//        label.alpha = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -8),
//            label.widthAnchor.constraint(equalToConstant: width),
//            label.heightAnchor.constraint(equalToConstant: 30)
//            ])
//        UIView.animate(withDuration: 0.5, animations: {
//            label.alpha = 1
//        }) { _ in
//            UIView.animate(withDuration: 1, animations: {
//                label.alpha = 0
//            }) { _ in
//                label.removeFromSuperview()
//            }
//        }
//    }
//    
//    private func saveText(question: QuestionTextField) {
//        guard let lesson = lesson,
//              let questionText = question.text,
//              !questionText.isEmpty,
//              let codeEditorView = question.editorView,
//              let fileIndex = codeEditorViews.firstIndex(of: codeEditorView),
//              let userText = try? String(contentsOf: lesson.files[fileIndex].userURL),
//              let language = lesson.files[fileIndex].programingLanguage,
//              let regex = try? NSRegularExpression(pattern: language.makeAnswerKey(value: String(codeEditorView.activeQuestionIndex)).appendingRegularExpressionEscaping())
//        else {
//            return
//        }
////        print(lesson.files[fileIndex].userURL)
////        print(try? String(contentsOf: lesson.files[fileIndex].userURL))
//        let matches = regex.matches(in: userText, range: NSRange(location: 0, length: (userText as NSString).length))
//        guard matches.count == 2 else {
//            return
//        }
//        let startIndex = userText.index(userText.startIndex, offsetBy: matches[0].range.location + matches[0].range.length)
//        let endIndex = userText.index(userText.startIndex, offsetBy: matches[1].range.location)
//        let newUserText = userText.replacingCharacters(in: startIndex..<endIndex, with: questionText)
//        //try! newUserText.write(to: lesson.files[fileIndex].userURL, atomically: true, encoding: .utf8)
//        FileUtils.saveFile(url: lesson.files[fileIndex].userURL, text: newUserText)
//        let previewText = TextUtils.formatUserTextToPreviewText(newUserText, language: language)
//        FileUtils.saveFile(url: lesson.files[fileIndex].previewURL, text: previewText)
//        //Application.print(lesson.files[fileIndex].previewURL)
//        //try! previewText.write(to: lesson.files[fileIndex].previewURL, atomically: true, encoding: .utf8)
////        do {
////            try newUserText.write(to: lesson.files[fileIndex].userURL, atomically: true, encoding: .utf8)
////            let previewText = TextUtils.formatUserTextToPreviewText(newUserText, language: language)
////            try previewText.write(to: lesson.files[fileIndex].previewURL, atomically: true, encoding: .utf8)
////        } catch {
////            Application.printErrorLog(error.localizedDescription)
////        }？
//    }
//    
//    private func loadUserFile() {
//        guard let lesson = lesson else {
//            return
//        }
//        guard let activeCodeEditorView  = activeCodeEditorView else {
//            return
//        }
//        guard let fileIndex = codeEditorViews.firstIndex(of: activeCodeEditorView) else {
//            return
//        }
//        if lesson.files[fileIndex].title.contains("css"), let indexFile = lesson.index {
//            let request = URLRequest(url: indexFile.previewURL)
//            previewWebView.load(request)
//        } else {
//            let request = URLRequest(url: lesson.files[fileIndex].previewURL)
//            previewWebView.load(request)
//        }
//        previewWebView.reload()
//    }
//    
//    private func scrollToQuestion(codeEditorView: CodeEditorView) {
//        guard let question = codeEditorView.activeQuestion else {
//            return
//        }
//        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
//            codeEditorView.scrollView.contentOffset.y = question.frame.origin.y - question.bounds.height
//        })
//    }
//    
//    private func insertCharacterIfCorrect(to question: QuestionTextField, answer: Character, character: Character) -> Bool {
//        guard (answer == character) else {
//            return false
//        }
//        question.insertText(String(character))
//        return true
//    }
//    
//    private func handleQuestionDidChangeEvent(_ codeEditorView: CodeEditorView) {
//        let questionIndex = codeEditorView.activeQuestionIndex
//        guard let fileIndex = codeEditorViews.firstIndex(of: codeEditorView),
//              let file = lesson?.files[fileIndex],
//              let descriptions = lesson?.descriptios[file.title],
//              let descriptionIndex = descriptions.firstIndex(where: {$0.index == questionIndex})
//        else {
//            return
//        }
//        showDescriptionView(descriptionIndex: descriptionIndex)
//    }
//    
//    private func showWebView(_ webView: WKWebView) {
//        webViewContainer.subviews.forEach { $0.removeFromSuperview() }
//        webViewContainer.addSubview(webView)
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            webView.leadingAnchor.constraint(equalTo: webViewContainer.safeAreaLayoutGuide.leadingAnchor),
//            webView.trailingAnchor.constraint(equalTo: webViewContainer.safeAreaLayoutGuide.trailingAnchor),
//            webView.topAnchor.constraint(equalTo: webViewContainer.safeAreaLayoutGuide.topAnchor),
//            webView.bottomAnchor.constraint(equalTo: webViewContainer.safeAreaLayoutGuide.bottomAnchor),
//            ])
//    }
//    
//    @objc
//    private func showPreviewWebView() {
//        showWebView(previewWebView)
//        showAnswerWebViewButton.backgroundColor = .clear
//        showPreviewWebViewButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
//    }
//    
//    @objc
//    private func showAnswerWebView() {
//        showWebView(answerWebView)
//        showAnswerWebViewButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
//        showPreviewWebViewButton.backgroundColor = .clear
//    }
//    
//    @objc
//    private func handleFileButtonTouchUpInsideEvent(_ sender: UIButton) {
//        let animationDuration: TimeInterval = 0.25
//        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotateAnimation.repeatCount = 1
//        rotateAnimation.duration = animationDuration
//        let x: CGFloat
//        if filesTableView.frame.origin.x < view.bounds.width {
//            x = view.bounds.width
//            rotateAnimation.toValue = -2 * CGFloat.pi
//        } else {
//            x = view.bounds.width - filesTableView.bounds.width
//            rotateAnimation.toValue = 2 * CGFloat.pi
//        }
//        fileButton.layer.add(rotateAnimation, forKey: "rotation")
//        UIView.animate(withDuration: animationDuration, animations: {
//            self.filesTableView.frame.origin.x = x
//        }) {_ in
//            if self.filesTableView.frame.origin.x == self.view.bounds.width {
//                self.fileButton.setBackgroundImage(UIImage(named: "file-icon"), for: .normal)
//            } else if self.filesTableView.frame.origin.x <= (self.view.bounds.width - self.filesTableView.bounds.width) * 1.1 {
//                self.fileButton.setBackgroundImage(UIImage(named: "cross-icon"), for: .normal)
//            }
//        }
//    }
//    
//    @objc
//    private func handleKeyboardButtonTouchUpInsideEvent(_ sender: UIButton) {
//        guard let question = activeCodeEditorView?.activeQuestion,
//              let senderTitle = sender.title(for: .normal)
//        else {
//            return
//        }
//        let answer = question.answer[question.text?.count ?? 0]
//        let succeeded = insertCharacterIfCorrect(to: question, answer: answer, character: Character(senderTitle))
//        if succeeded {
//            sender.darken(coeff: 0.5)
//            sender.isEnabled = false
//        } else {
//            playNGAnimation()
//        }
//    }
//    
//    @objc
//    private func handleQuestionTextFieldEditingChangedEvent(_ question: QuestionTextField) {
//        guard let codeEditorView = question.editorView else {
//            return
//        }
//        saveText(question: question)
//        loadUserFile()
//        if question.isCompleted {
//            playCorrectAnimation()
//            codeEditorView.setNextQuestion()
//            if codeEditorView.isCompleted {
//                if let codeEditorViewIndex = codeEditorViews.firstIndex(of: codeEditorView) {
//                    var nextCodeEditorViewIndex = codeEditorViewIndex + 1
//                    while nextCodeEditorViewIndex < codeEditorViews.count {
//                        if !codeEditorViews[nextCodeEditorViewIndex].questions.isEmpty {
//                            break
//                        }
//                        nextCodeEditorViewIndex += 1
//                    }
//                    if nextCodeEditorViewIndex == codeEditorViews.count {
//                        UIView.animate(withDuration: 1) {
//                            codeEditorView.lastQuestion?.keyboardView.alpha = 0
//                        }
//                    } else {
//                        let nextCodeEditor = codeEditorViews[nextCodeEditorViewIndex]
//                        nextCodeEditor.activeQuestion?.activate(true)
//                        changeCodeEditorView(to: nextCodeEditor)
//                        scrollToQuestion(codeEditorView: nextCodeEditor)
//                        if let lesson = lesson,
//                           let descriptionIndex = lesson.descriptios[lesson.files[codeEditorViewIndex].title]?.firstIndex(where: { $0.index == 0 })
//                        {
//                            showDescriptionView(descriptionIndex: descriptionIndex)
//                        }
//                    }
//                }
//            } else {
//                scrollToQuestion(codeEditorView: codeEditorView)
//            }
//        } else {
//            playOKAnimation()
//        }
//        if question.markedTextRange == nil,
//           let fileIndex = codeEditorViews.firstIndex(of: codeEditorView),
//           let language = lesson?.files[fileIndex].programingLanguage
//        {
//            let key = language.makeAnswerKey(value: String(question.index))
//            let escapedKey = key.appendingRegularExpressionEscaping()
//            let pattern =  escapedKey + ".*" + escapedKey
//            if let fileIndex = codeEditorViews.firstIndex(of: codeEditorView),
//                let url = lesson?.files[fileIndex].userURL,
//                let userText = try? String(contentsOf: url),
//                let regex = try? NSRegularExpression(pattern: pattern)
//            {
//                let attributedUserText = SyntaxHighlighter.decorate(userText, tintColor: tintColor, font: font, language: question.language)
//                let matches = regex.matches(in: userText, range: NSRange(location: 0, length: (userText as NSString).length))
//                let range = NSRange(location: matches[0].range.location + key.count, length: matches[0].range.length - key.count * 2)
//                question.attributedText = attributedUserText.attributedSubstring(from: range)
//                let textSize = question.text?.size(withAttributes: [.font: font]) ?? .zero
//                question.caret.frame.origin.x = textSize.width
//            }
//        }
//    }
//    
//}
//
//extension CodeEditorViewController: UITableViewDataSource, UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return lesson?.files.count ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: CodeEditorViewController.cellID) as? FileTableViewCell else {
//            return UITableViewCell()
//        }
//        cell.backgroundColor = .lightGray
//        cell.iconImageView.image = lesson?.files[indexPath.row].programingLanguage?.iconImage
//        cell.fileLabel.text = lesson?.files[indexPath.row].title
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 42
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        changeCodeEditorView(to: codeEditorViews[indexPath.row])
//    }
//    
//}
