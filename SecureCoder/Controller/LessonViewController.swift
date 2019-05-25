import UIKit

class LessonViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var lesson: Lesson?
    
    private let keyboardView = KeyboardView()
    private let codeEditorView = CodeEditorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupSubviews()
        showSlide()
    }
    
    private func setupSubviews() {
        view.addSubview(codeEditorView)
        codeEditorView.text = lesson?.text
        codeEditorView.questions.forEach { $0.addTarget(self, action: #selector(handleQuestionTextFieldEditingChangedEvent(_:)), for: .editingChanged) }
        codeEditorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeEditorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            codeEditorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            codeEditorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            codeEditorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        guard let question = codeEditorView.activeQuestion else {
            return
        }
        let size: CGFloat = 128
        codeEditorView.scrollView.addSubview(keyboardView)
        keyboardView.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        keyboardView.backgroundColor = UIColor(white: 0.25, alpha: 1)
        keyboardView.setTitlesRandom(answer: String(question.answer[0]))
        keyboardView.buttons.forEach { $0.addTarget(self, action: #selector(handleKeyboardButtonTouchUpInsideEvent(_:)), for: .touchUpInside) }
        moveKeyboard(to: question)
    }
    
    private func showSlide() {
//        let slideViewController = SlideViewController()
//        slideViewController.slides = lesson?.slides
//        present(slideViewController, animated: true)
    }
    
    private func moveKeyboard(to question: QuestionTextField) {
        let spacing: CGFloat = 8
        keyboardView.frame.origin = CGPoint(
            x: question.frame.origin.x,
            y: question.frame.origin.y + question.bounds.height + spacing
        )
    }
    
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
        if question.text == question.answer {
            playCorrectAnimation()
            codeEditorView.setNextQuestion()
            if let nextQuestion = codeEditorView.activeQuestion {
                moveKeyboard(to: nextQuestion)
                setKeyboardButtonTitles(with: nextQuestion)
            }
        } else {
            playOKAnimation()
            setKeyboardButtonTitles(with: question)
        }
    }
    
}
