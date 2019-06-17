
import UIKit
import WebKit

class CodeEditorViewController: UIViewController {
    
    private static let cellID = "CELL"
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var lesson: Lesson?
    
    private var font = UIFont.boldSystemFont(ofSize: 18)
    private var tintColor = UIColor.white
    private var activeCodeEditorView: CodeEditorView?
    private var codeEditorViews = [CodeEditorView]()
    
    private let showPreviewWebViewButton = UIButton()
    private let showAnswerWebViewButton = UIButton()
    private let webViewContainer = UIView()
    private let previewWebView = WKWebView()
    private let answerWebView = WKWebView()
    private let codeEditorViewContainer = UIView()
    private let filesTableView = UITableView()
    private let fileButton = UIButton()
    private let blackOutView = UIView()
    private let descriptionView = DescriptionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupSubviews()
        showSlide()
        loadUserFile()
    }
    
    private func addSubviews() {
        view.addSubview(codeEditorViewContainer)
        view.addSubview(filesTableView)
        view.addSubview(fileButton)
        view.addSubview(webViewContainer)
    }

    private func setupSubviews() {
        setupWebviews()
        setupFileButton()
        setupFilesTableView()
        setupDescriptionView()
        setupCodeEditorViewContainer()
        setupCodeEditorViews()
    }
    
    private func setupCodeEditorViewContainer() {
        codeEditorViewContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeEditorViewContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            codeEditorViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            codeEditorViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            codeEditorViewContainer.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.55)
            ])
    }
    
    private func setupCodeEditorViews() {
        guard let lesson = lesson else {
            return
        }
        for (fileIndex, file) in lesson.files.enumerated() {
            let codeEditorView = CodeEditorView()
            codeEditorViews.append(codeEditorView)
            codeEditorView.questionDidChangeEventHandler = handleQuestionDidChangeEvent(_:)
            setupCodeEditorViewComponents(codeEditorView: codeEditorView, lessonText: file.text)
            setupQuestions(codeEditorView.questions)
            codeEditorView.setNextQuestion()
            setUserAnswersToQuestionTextFields(file: file, questions: codeEditorView.questions)
            if fileIndex == 0 || codeEditorView.isCompleted {
                changeCodeEditorView(to: codeEditorView)
            }
        }
    }
    
    private func setupFilesTableView() {
        filesTableView.dataSource = self
        filesTableView.delegate = self
        filesTableView.register(FileTableViewCell.self, forCellReuseIdentifier: CodeEditorViewController.cellID)
        filesTableView.tableFooterView = UIView()
        filesTableView.backgroundColor = .lightGray
        filesTableView.frame = CGRect(
            x: view.bounds.width,
            y: 0,
            width: view.bounds.width * 0.4,
            height: view.bounds.height)
    }
    
    private func setupFileButton() {
        let fileButtonSize: CGFloat = 44
        fileButton.layer.cornerRadius = fileButtonSize * 0.5
        fileButton.setBackgroundImage(UIImage(named: "file-icon"), for: .normal)
        fileButton.addTarget(self, action: #selector(handleFileButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
        fileButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fileButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            fileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            fileButton.widthAnchor.constraint(equalToConstant: fileButtonSize),
            fileButton.heightAnchor.constraint(equalTo: fileButton.widthAnchor),
            ])
    }
    
    private func setupWebviews() {
        let webViewButtonsContainer = UIView()
        view.addSubview(webViewButtonsContainer)
        webViewButtonsContainer.backgroundColor = UIColor(white: 0.8, alpha: 1)
        webViewButtonsContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webViewButtonsContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webViewButtonsContainer.trailingAnchor.constraint(equalTo: codeEditorViewContainer.leadingAnchor),
            webViewButtonsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webViewButtonsContainer.heightAnchor.constraint(equalToConstant: 44),
            ])
        let webViewButtonsSeparator = UIView()
        webViewButtonsContainer.addSubview(webViewButtonsSeparator)
        webViewButtonsSeparator.backgroundColor = UIColor(white: 0.5, alpha: 1)
        webViewButtonsSeparator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webViewButtonsSeparator.centerXAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.centerXAnchor),
            webViewButtonsSeparator.centerYAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.centerYAnchor),
            webViewButtonsSeparator.widthAnchor.constraint(equalToConstant: 1),
            webViewButtonsSeparator.heightAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6666)
            ])
        webViewButtonsContainer.addSubview(showPreviewWebViewButton)
        showPreviewWebViewButton.setTitle("プレビュー", for: .normal)
        showPreviewWebViewButton.setTitleColor(.black, for: .normal)
        showPreviewWebViewButton.titleLabel?.font = .systemFont(ofSize: 14)
        showPreviewWebViewButton.addTarget(self, action: #selector(showPreviewWebView), for: .touchUpInside)
        showPreviewWebViewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showPreviewWebViewButton.leadingAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.leadingAnchor),
            showPreviewWebViewButton.trailingAnchor.constraint(equalTo: webViewButtonsSeparator.leadingAnchor),
            showPreviewWebViewButton.topAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.topAnchor),
            showPreviewWebViewButton.bottomAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.bottomAnchor),
            ])
        webViewButtonsContainer.addSubview(showAnswerWebViewButton)
        showAnswerWebViewButton.setTitle("見本", for: .normal)
        showAnswerWebViewButton.setTitleColor(.black, for: .normal)
        showAnswerWebViewButton.titleLabel?.font = .systemFont(ofSize: 14)
        showAnswerWebViewButton.addTarget(self, action: #selector(showAnswerWebView), for: .touchUpInside)
        showAnswerWebViewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showAnswerWebViewButton.leadingAnchor.constraint(equalTo: webViewButtonsSeparator.trailingAnchor),
            showAnswerWebViewButton.topAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.topAnchor),
            showAnswerWebViewButton.bottomAnchor.constraint(equalTo: webViewButtonsContainer.safeAreaLayoutGuide.bottomAnchor),
            showAnswerWebViewButton.widthAnchor.constraint(equalTo: showPreviewWebViewButton.widthAnchor)
            ])
        webViewContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webViewContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webViewContainer.trailingAnchor.constraint(equalTo: codeEditorViewContainer.leadingAnchor),
            webViewContainer.topAnchor.constraint(equalTo: webViewButtonsContainer.bottomAnchor),
            webViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        if let indexFile = lesson?.index {
            answerWebView.load(URLRequest(url: indexFile.answerURL))
        }
        showPreviewWebView()
    }

    private func setupQuestions(_ questions: [QuestionTextField]) {
        for question in questions {
            question.keyboardView.backgroundColor = UIColor(white: 0.25, alpha: 1)
            for button in question.keyboardView.buttons {
                button.backgroundColor = UIColor(white: 0.35, alpha: 1)
                button.layer.borderColor = UIColor.white.cgColor
                button.layer.borderWidth = 0.25
                button.setTitleColor(.white, for: .normal)
                button.addTarget(self, action: #selector(handleKeyboardButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
            }
        }
    }
    
    private func setupCodeEditorViewComponents(codeEditorView: CodeEditorView, lessonText: String) {
        let editorComponents = EditorComponentsBuilder().build(
            pointer: .zero,
            font: font,
            tintColor: tintColor,
            lessonText: lessonText)
        editorComponents.forEach { editorComponent in
            let bufferSize = CGSize(width: 64, height: 132)
            codeEditorView.scrollView.addSubview(editorComponent)
            codeEditorView.scrollView.contentSize.width = max(
                codeEditorView.scrollView.contentSize.width,
                editorComponent.frame.origin.x + editorComponent.bounds.width + bufferSize.width)
            codeEditorView.scrollView.contentSize.height = max(codeEditorView.scrollView.contentSize.height,
                                                               editorComponent.frame.origin.y + editorComponent.bounds.height + bufferSize.height)
            if let question = editorComponent as? QuestionTextField {
                question.editorView = codeEditorView
                question.addTarget(self, action: #selector(handleQuestionTextFieldEditingChangedEvent(_:)), for: .editingChanged)
                codeEditorView.questions.append(question)
            }
        }
    }
    
    private func setupDescriptionView() {
        view.addSubview(blackOutView)
        blackOutView.alpha = 0
        blackOutView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        view.addSubview(descriptionView)
        descriptionView.alpha = 0
        descriptionView.backgroundColor = .make(fromHex: "#3b485f")
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.closeButton.addTarget(self, action: #selector(hideDescriptionView), for: .touchUpInside)
        NSLayoutConstraint.activate([
            descriptionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            descriptionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
            ])
    }
    
    private func setUserAnswersToQuestionTextFields(file: File, questions: [QuestionTextField]) {
        guard let userText = try? String(contentsOf: file.userURL) else {
            return
        }
        let userAnswers = UserFileManager.extractUserAnswers(userText: userText)
        for (userAnswerIndex, userAnswer) in userAnswers.enumerated() {
            guard !userAnswer.isEmpty else {
                break
            }
            questions[userAnswerIndex].insertText(userAnswer)
        }
    }
    
    private func changeCodeEditorView(to codeEditorView: CodeEditorView) {
        guard let lesson = lesson,
              let codeEditorViewIndex = codeEditorViews.firstIndex(of: codeEditorView),
              let descriptions = lesson.descriptios[lesson.files[codeEditorViewIndex].title] else {
            return
        }
        descriptionView.descriptions = descriptions
        descriptionView.titleLabels.forEach { titleLabel in
            titleLabel.textColor = .black
            titleLabel.font = .boldSystemFont(ofSize: 24)
        }
        descriptionView.contentTextViews.forEach { contentTextView in
            contentTextView.textColor = .black
            contentTextView.font = .systemFont(ofSize: 20)
            contentTextView.backgroundColor = .clear
        }
        descriptionView.separatorViews.forEach { $0.backgroundColor = .white }
        activeCodeEditorView = codeEditorView
        codeEditorViewContainer.subviews.forEach { $0.removeFromSuperview() }
        codeEditorViewContainer.addSubview(codeEditorView)
        codeEditorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeEditorView.leadingAnchor.constraint(equalTo: codeEditorViewContainer.safeAreaLayoutGuide.leadingAnchor),
            codeEditorView.trailingAnchor.constraint(equalTo: codeEditorViewContainer.safeAreaLayoutGuide.trailingAnchor),
            codeEditorView.topAnchor.constraint(equalTo: codeEditorViewContainer.safeAreaLayoutGuide.topAnchor),
            codeEditorView.bottomAnchor.constraint(equalTo: codeEditorViewContainer.safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
    private func showSlide() {
        //        let slideViewController = SlideViewController()
        //        slideViewController.slides = lesson?.slides
        //        present(slideViewController, animated: true)
    }
    
    private func showDescriptionView(descriptionIndex: Int) {
        blackOutView.frame = view.bounds
        descriptionView.selectedDescriptionIndex = descriptionIndex
        descriptionView.scrollToDescription(at: descriptionIndex, animate: false)
        UIView.animate(withDuration: 0.5) {
            self.blackOutView.alpha = 1
            self.descriptionView.alpha = 1
        }
    }
    
    @objc
    private func hideDescriptionView() {
        UIView.animate(withDuration: 0.5) {
            self.blackOutView.alpha = 0
            self.descriptionView.alpha = 0
        }
    }
    
    private func playCorrectAnimation() {
        let font = UIFont.boldSystemFont(ofSize: 18)
        playNotificationAnimation(
            text: "正解!!",
            font: font,
            width: 64,
            textColor: .white,
            backgroundColor: .forestGreen
        )
    }
    
    private func playOKAnimation() {
        let text = "○"
        let font = UIFont.boldSystemFont(ofSize: 24)
        playNotificationAnimation(
            text: text,
            font: font,
            width: 64,
            textColor: .white,
            backgroundColor: .forestGreen
        )
    }
    
    private func playNGAnimation() {
        let text = "×"
        let font = UIFont.boldSystemFont(ofSize: 24)
        playNotificationAnimation(
            text: text,
            font: font,
            width: 64,
            textColor: .white,
            backgroundColor: .signalRed
        )
    }
    
    private func playNotificationAnimation(text: String, font: UIFont, width: CGFloat, textColor: UIColor, backgroundColor: UIColor) {
        let label = UILabel()
        view.addSubview(label)
        label.text = text
        label.textColor = textColor
        label.textAlignment = .center
        label.font = font
        label.backgroundColor = backgroundColor
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -8),
            label.widthAnchor.constraint(equalToConstant: width),
            label.heightAnchor.constraint(equalToConstant: 30)
            ])
        UIView.animate(withDuration: 0.5, animations: {
            label.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 1, animations: {
                label.alpha = 0
            }) { _ in
                label.removeFromSuperview()
            }
        }
    }
    
    private func saveText(question: QuestionTextField) {
        guard let lesson = lesson,
              let questionText = question.text,
              !questionText.isEmpty,
              let codeEditorView = question.editorView,
              let fileIndex = codeEditorViews.firstIndex(of: codeEditorView),
              let userText = try? String(contentsOf: lesson.files[fileIndex].userURL),
              let regex = try? NSRegularExpression(pattern:
                "<!--" + String(codeEditorView.activeQuestionIndex) + "-->")
        else {
            return
        }
        let matches = regex.matches(in: userText, range: NSRange(location: 0, length: (userText as NSString).length))
        guard matches.count == 2 else {
            return
        }
        let startIndex = userText.index(userText.startIndex, offsetBy: matches[0].range.location + matches[0].range.length)
        let endIndex = userText.index(userText.startIndex, offsetBy: matches[1].range.location)
        let newUserText = userText.replacingCharacters(in: startIndex..<endIndex, with: questionText)
        do {
            try newUserText.write(to: lesson.files[fileIndex].userURL, atomically: true, encoding: .utf8)
            let previewText = UserFileManager.formatUserTextToPreviewText(newUserText)
            try previewText.write(to: lesson.files[fileIndex].previewURL, atomically: true, encoding: .utf8)
        } catch {
            Application.printErrorLog(error.localizedDescription)
        }
    }
    
    private func loadUserFile() {
        guard let lesson = lesson else {
            return
        }
        guard let activeCodeEditorView  = activeCodeEditorView else {
            return
        }
        guard let fileIndex = codeEditorViews.firstIndex(of: activeCodeEditorView) else {
            return
        }
        if lesson.files[fileIndex].title.contains("css"), let indexFile = lesson.index {
            let request = URLRequest(url: indexFile.previewURL)
            previewWebView.load(request)
        } else {
            let request = URLRequest(url: lesson.files[fileIndex].previewURL)
            previewWebView.load(request)
        }
        previewWebView.reload()
    }
    
    private func scrollToQuestion(codeEditorView: CodeEditorView) {
        guard let question = codeEditorView.activeQuestion else {
            return
        }
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            codeEditorView.scrollView.contentOffset.y = question.frame.origin.y - question.bounds.height
        })
    }
    
    private func insertCharacterIfCorrect(to question: QuestionTextField, answer: Character, character: Character) -> Bool {
        guard (answer == character) else {
            return false
        }
        question.insertText(String(character))
        return true
    }
    
    private func handleQuestionDidChangeEvent(_ codeEditorView: CodeEditorView) {
        let questionIndex = codeEditorView.activeQuestionIndex
        guard let fileIndex = codeEditorViews.firstIndex(of: codeEditorView),
              let file = lesson?.files[fileIndex],
              let descriptions = lesson?.descriptios[file.title],
              let descriptionIndex = descriptions.firstIndex(where: {$0.index == questionIndex})
        else {
            return
        }
        showDescriptionView(descriptionIndex: descriptionIndex)
    }
    
    private func showWebView(_ webView: WKWebView) {
        webViewContainer.subviews.forEach { $0.removeFromSuperview() }
        webViewContainer.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: webViewContainer.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: webViewContainer.safeAreaLayoutGuide.trailingAnchor),
            webView.topAnchor.constraint(equalTo: webViewContainer.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: webViewContainer.safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
    @objc
    private func showPreviewWebView() {
        showWebView(previewWebView)
        showAnswerWebViewButton.backgroundColor = .clear
        showPreviewWebViewButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    @objc
    private func showAnswerWebView() {
        showWebView(answerWebView)
        showAnswerWebViewButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        showPreviewWebViewButton.backgroundColor = .clear
    }
    
    @objc
    private func handleFileButtonTouchUpInsideEvent(_ sender: UIButton) {
        let animationDuration: TimeInterval = 0.25
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.repeatCount = 1
        rotateAnimation.duration = animationDuration
        let x: CGFloat
        if filesTableView.frame.origin.x < view.bounds.width {
            x = view.bounds.width
            rotateAnimation.toValue = -2 * CGFloat.pi
        } else {
            x = view.bounds.width - filesTableView.bounds.width
            rotateAnimation.toValue = 2 * CGFloat.pi
        }
        fileButton.layer.add(rotateAnimation, forKey: "rotation")
        UIView.animate(withDuration: animationDuration, animations: {
            self.filesTableView.frame.origin.x = x
        }) {_ in
            if self.filesTableView.frame.origin.x == self.view.bounds.width {
                self.fileButton.setBackgroundImage(UIImage(named: "file-icon"), for: .normal)
            } else if self.filesTableView.frame.origin.x <= (self.view.bounds.width - self.filesTableView.bounds.width) * 1.1 {
                self.fileButton.setBackgroundImage(UIImage(named: "cross-icon"), for: .normal)
            }
        }
    }
    
    @objc
    private func handleKeyboardButtonTouchUpInsideEvent(_ sender: UIButton) {
        guard let question = activeCodeEditorView?.activeQuestion,
              let senderTitle = sender.title(for: .normal)
        else {
            return
        }
        let answer = question.answer[question.text?.count ?? 0]
        let succeeded = insertCharacterIfCorrect(to: question, answer: answer, character: Character(senderTitle))
        if succeeded {
            sender.darken(coeff: 0.5)
            sender.isEnabled = false
        } else {
            playNGAnimation()
        }
    }
    
    @objc
    private func handleQuestionTextFieldEditingChangedEvent(_ question: QuestionTextField) {
        guard let codeEditorView = question.editorView else {
            return
        }
        saveText(question: question)
        loadUserFile()
        if question.isCompleted {
            playCorrectAnimation()
            codeEditorView.setNextQuestion()
            if codeEditorView.isCompleted {
                if let codeEditorViewIndex = codeEditorViews.firstIndex(of: codeEditorView) {
                    var nextCodeEditorViewIndex = codeEditorViewIndex + 1
                    while nextCodeEditorViewIndex < codeEditorViews.count {
                        if !codeEditorViews[nextCodeEditorViewIndex].questions.isEmpty {
                            break
                        }
                        nextCodeEditorViewIndex += 1
                    }
                    if nextCodeEditorViewIndex == codeEditorViews.count {
                        UIView.animate(withDuration: 1) {
                            codeEditorView.lastQuestion?.keyboardView.alpha = 0
                        }
                    } else {
                        let nextCodeEditor = codeEditorViews[nextCodeEditorViewIndex]
                        nextCodeEditor.activeQuestion?.activate(true)
                        changeCodeEditorView(to: nextCodeEditor)
                        scrollToQuestion(codeEditorView: nextCodeEditor)
                        if let lesson = lesson,
                           let descriptionIndex = lesson.descriptios[lesson.files[codeEditorViewIndex].title]?.firstIndex(where: { $0.index == 0 })
                        {
                            showDescriptionView(descriptionIndex: descriptionIndex)
                        }
                    }
                }
            } else {
                scrollToQuestion(codeEditorView: codeEditorView)
            }
        } else {
            playOKAnimation()
        }
        if question.markedTextRange == nil {
            let key = "<!--" + String(question.index) + "-->"
            let pattern =  key + ".*" + key
            if let fileIndex = codeEditorViews.firstIndex(of: codeEditorView),
                let url = lesson?.files[fileIndex].userURL,
                let userText = try? String(contentsOf: url),
                let regex = try? NSRegularExpression(pattern: pattern)
            {
                let attributedUserText = SyntaxHighlighter.decorate(userText, tintColor: tintColor, font: font, language: question.language)
                let matches = regex.matches(in: userText, range: NSRange(location: 0, length: (userText as NSString).length))
                let range = NSRange(location: matches[0].range.location + key.count, length: matches[0].range.length - key.count * 2)
                question.attributedText = attributedUserText.attributedSubstring(from: range)
                let textSize = question.text?.size(withAttributes: [.font: font]) ?? .zero
                question.caret.frame.origin.x = textSize.width
            }
        }
    }
    
}

extension CodeEditorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lesson?.files.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CodeEditorViewController.cellID) as? FileTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .lightGray
        cell.iconImageView.image = lesson?.files[indexPath.row].programingLanguage?.iconImage
        cell.fileLabel.text = lesson?.files[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeCodeEditorView(to: codeEditorViews[indexPath.row])
    }
    
}
