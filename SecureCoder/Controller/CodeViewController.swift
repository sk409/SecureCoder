import UIKit
import WebKit

class CodeViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var lesson: Lesson?
    
    private let keyboardView = KeyboardView()
    private let codeEditorView = CodeEditorView()
    private let previewWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        lesson?.files.forEach { UserFileManager.createUserFileIfNotExists(lessonFile: $0) }
        
        setupSubviews()
        showSlide()
        
        
        //
        loadUserFile()
        //
    }
    
    private func setupSubviews() {
        
        view.addSubview(codeEditorView)
        codeEditorView.lessonText = lesson?.index?.text
        codeEditorView.questions.forEach { $0.addTarget(self, action: #selector(handleQuestionTextFieldEditingChangedEvent(_:)), for: .editingChanged) }
        codeEditorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeEditorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            codeEditorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            codeEditorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            codeEditorView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.55)
            ])
        lesson?.files.forEach { file in
            guard let userText = try? String(contentsOf: file.userURL) else {
                return
            }
            //print(userText)
            let userAnswers = UserFileManager.extractUserAnswers(userText: userText)
            for (index, userAnswer) in userAnswers.enumerated() {
                codeEditorView.questions[index].insertText(userAnswer)
                guard codeEditorView.questions[index].isCompleted else {
                    break
                }
            }
        }
        
//        guard let question = codeEditorView.activeQuestion else {
//            return
//        }
        //let size: CGFloat = 128
        view.addSubview(keyboardView)
        keyboardView.backgroundColor = UIColor(white: 0.25, alpha: 1)
        //keyboardView.setTitlesRandom(answer: String(question.answer[0]))
        keyboardView.buttons.forEach { $0.addTarget(self, action: #selector(handleKeyboardButtonTouchUpInsideEvent(_:)), for: .touchUpInside) }
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            keyboardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            keyboardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            keyboardView.widthAnchor.constraint(equalToConstant: 128),
            keyboardView.heightAnchor.constraint(equalTo: keyboardView.widthAnchor),
            ])

        view.addSubview(previewWebView)
        previewWebView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewWebView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            previewWebView.trailingAnchor.constraint(equalTo: codeEditorView.leadingAnchor),
            previewWebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            previewWebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
    private func showSlide() {
//        let slideViewController = SlideViewController()
//        slideViewController.slides = lesson?.slides
//        present(slideViewController, animated: true)
    }
    
//    private func moveKeyboard(to question: QuestionTextField) {
//        let spacing: CGFloat = 8
//        keyboardView.frame.origin = CGPoint(
//            x: question.frame.origin.x,
//            y: question.frame.origin.y + question.bounds.height + spacing
//        )
//    }
    
    private func setKeyboardButtonTitles(with question: QuestionTextField) {
        let next = String(question.answer[question.text?.count ?? 0])
        if next == " " {
            keyboardView.setTitle(rowIndex: 1, columnIndex: 1, title: " ")
        } else {
            keyboardView.setTitlesRandom(answer: next)
        }
    }
    
    private func playCorrectAnimation() {
        let font = UIFont.boldSystemFont(ofSize: 18)
        playNotificationAnimation(
            text: "正解!!",
            font: font,
            width: view.bounds.width * 0.25,
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
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
        guard let lesson = lesson else {
            return
        }
        guard let questionText = question.text else {
            return
        }
        guard !questionText.isEmpty else {
            return
        }
        /////////////////////////
        // TODO: ファイルとりあえず
        guard let userText = try? String(contentsOf: lesson.files[0].userURL) else {
            return
        }
        /////////////////////////
        let pattern = "<!--" + String(codeEditorView.activeQuestionIndex) + "-->"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
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
            /////////////////////////
            // TODO: ファイルとりあえず
            try newUserText.write(to: lesson.files[0].userURL, atomically: true, encoding: .utf8)
            /////////////////////////
        } catch {
            Application.writeErrorLog(error.localizedDescription)
        }
    }
    
    private func loadUserFile() {
        guard let lesson = lesson else {
            return
        }
        /////////////////////////
        // TODO: ファイルとりあえず
        let request = URLRequest(url: lesson.files[0].userURL)
        /////////////////////////
        previewWebView.load(request)
    }
    
    @objc
    private func handleKeyboardButtonTouchUpInsideEvent(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else {
            return
        }
        guard let question = codeEditorView.activeQuestion else {
            return
        }
        guard let text = question.text else {
            return
        }
        let shouldInsert = question.answer[text.count...(text.count + title.count - 1)] == title
        if shouldInsert {
            question.insertText(title)
        } else {
            playNGAnimation()
        }
    }
    
    @objc
    private func handleQuestionTextFieldEditingChangedEvent(_ question: QuestionTextField) {
        saveText(question: question)
        loadUserFile()
        if question.text == question.answer {
            playCorrectAnimation()
            codeEditorView.setNextQuestion()
            if let nextQuestion = codeEditorView.activeQuestion {
                setKeyboardButtonTitles(with: nextQuestion)
            }
        } else {
            playOKAnimation()
            setKeyboardButtonTitles(with: question)
        }
    }
    
}
