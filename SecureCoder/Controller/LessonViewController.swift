import UIKit

class LessonViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var lesson: Lesson?
    
    var defaultColor = UIColor.white
    var font = UIFont.systemFont(ofSize: 16)
    
    private var isInitialized = false
    
    private var questions = [QuestionTextField]()
    private var activeQuestionIndex = 0
    
    private let scrollView = UIScrollView()
    private let alphabetKeyboardView = KeyboardView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        let slideViewController = SlideViewController()
        slideViewController.slides = lesson?.slides
        present(slideViewController, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if isInitialized {
            questions.forEach { question in
                question.isUserInteractionEnabled = false
            }
        } else {
            setupSubviews()
            parseLessonText()
            changeKeyboard()
            isInitialized = true
        }
        if activeQuestionIndex <= (questions.count - 1) {
            questions[activeQuestionIndex].isUserInteractionEnabled = true
            questions[activeQuestionIndex].becomeFirstResponder()
        }
    }
    
    private func setupSubviews() {
        
        view.addSubview(scrollView)
        scrollView.frame = view.safeAreaLayoutGuide.layoutFrame
        
        view.addSubview(alphabetKeyboardView)
        alphabetKeyboardView.translatesAutoresizingMaskIntoConstraints = false
        alphabetKeyboardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        alphabetKeyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        alphabetKeyboardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        alphabetKeyboardView.heightAnchor.constraint(equalToConstant: KeyboardView.size.height + KeyboardView.buttonSize).isActive = true
        alphabetKeyboardView.backgroundColor = UIColor(white: 0.25, alpha: 1)
    }
    
    private func parseLessonText() {
        guard let text = lesson?.text else {
            return
        }
        var cache = ""
        var index = 0
        var pointer = CGRect(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top, width: 0, height: 0)
        var language: ProgramingLanguage?
        let updateContentSize: () -> Void = {
            self.scrollView.contentSize.width = max(self.scrollView.contentSize.width, pointer.origin.x + pointer.width)
            self.scrollView.contentSize.height = max(self.scrollView.contentSize.height, pointer.origin.y + pointer.height)
        }
        while index <= (text.count - 1) {
            let character = text[index]
            cache.append(character)
            if cache == "\n" {
                pointer = addNewLine(pointer: pointer)
                updateContentSize()
                cache.removeAll()
            } else if cache == " " && !cache.hasPrefix("@[@") && !cache.hasPrefix("?[?") && !cache.hasPrefix("#[#") {
                pointer = addSpace(pointer: pointer)
                updateContentSize()
                cache.removeAll()
            } else if cache.hasPrefix("@[@") && cache.hasSuffix("@]@") {
                language = ProgramingLanguage(rawValue: String(cache[3...(cache.count - 4)]))
                cache.removeAll()
            } else if cache.hasPrefix("?[?") && cache.hasSuffix("?]?") {
                pointer = addQuestion(answer: String(cache[3...(cache.count - 4)]), language: language!, pointer: pointer)
                updateContentSize()
                cache.removeAll()
            } else if cache.hasPrefix("#[#") && cache.hasSuffix("#]#") {
                pointer = addTemplate(text: String(cache[3...(cache.count - 4)]), language: language!, pointer: pointer)
                updateContentSize()
                cache.removeAll()
            }
            index += 1
        }
    }
    
    private func addQuestion(answer: String, language: ProgramingLanguage, pointer: CGRect) -> CGRect {
        let question = QuestionTextField(answer: answer, language: language)
        scrollView.addSubview(question)
        questions.append(question)
        question.delegate = self
        question.inputView = UIView()
        question.isUserInteractionEnabled = false
        question.textAlignment = .center
        question.textColor = .white
        question.font = font
        question.backgroundColor = view.backgroundColor
        question.layer.borderColor = UIColor.white.cgColor
        question.layer.borderWidth = 0.5
        question.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        let size = answer.size(withAttributes: [.font: font])
        let x = pointer.origin.x + pointer.width + 5
        let y = pointer.origin.y
        question.frame = CGRect(x: x, y: y, width: size.width + 20, height: size.height + 5)
        return question.frame
    }
    
    private func addTemplate(text: String, language: ProgramingLanguage, pointer: CGRect) -> CGRect {
        let template = UILabel()
        scrollView.addSubview(template)
        template.backgroundColor = view.backgroundColor
        template.numberOfLines = 0
        template.attributedText = SyntaxHighlighter.decorate(text, defaultColor: defaultColor, font: font, language: language)
        let size = text.size(withAttributes: [.font: font])
        let x = pointer.origin.x + pointer.width + 5
        let y = pointer.origin.y
        template.frame = CGRect(x: x, y: y, width: size.width, height: size.height + 5)
        return template.frame
    }
    
    private func addNewLine(pointer: CGRect) -> CGRect {
        let lineHeight: CGFloat = 15
        return CGRect(x: 0, y: pointer.origin.y + pointer.height + lineHeight, width: 0, height: 0)
    }
    
    private func addSpace(pointer: CGRect) -> CGRect {
        let spaceSize = " ".size(withAttributes: [.font: font])
        return CGRect(x: pointer.origin.x + pointer.width, y: pointer.origin.y
            , width: spaceSize.width, height: spaceSize.height)
    }
    
    private func playNotificationAnimation(text: String, width: CGFloat, textColor: UIColor, backgroundColor: UIColor) {
        let label = UILabel()
        view.addSubview(label)
        label.text = text
        label.textColor = textColor
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
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
    
    private func playCorrectAnimation() {
        playNotificationAnimation(text: "正解!!", width: view.bounds.width * 0.25, textColor: .white, backgroundColor: .forestGreen)
    }
    
//    private func playOKAnimation() {
//        playNotificationAnimation(text: "○", width: 44, textColor: .white, backgroundColor: .forestGreen)
//    }
//    
//    private func playNGAnimation() {
//        
//    }
    
    private func playOverNumberOfCharactersAnimation() {
        let label = UILabel()
        view.addSubview(label)
        label.text = "文字数が多すぎます。"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.backgroundColor = .red
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
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
    
    private func changeKeyboard() {
        let question = questions[activeQuestionIndex]
        guard let text = question.text else {
            return
        }
        var nextCharacter = Character(" ")
        if text.isEmpty {
            nextCharacter = question.answer[0]
        } else {
            for index in 0...(question.answer.count - 1) {
                guard index != text.count && text[index] == question.answer[index] else {
                    nextCharacter = question.answer[index]
                    break
                }
            }
        }
        if nextCharacter.isUppercase {
            alphabetKeyboardView.change(to: .uppercasedAlphabet)
        } else if nextCharacter.isLowercase {
            alphabetKeyboardView.change(to: .lowercasedAlphabet)
        } else if nextCharacter == " " {
            alphabetKeyboardView.change(to: .space)
        } else if KeyboardView.symbols1.contains(String(nextCharacter)) {
            alphabetKeyboardView.change(to: .symbol1)
        } else if KeyboardView.symbols2.contains(String(nextCharacter)) {
            alphabetKeyboardView.change(to: .symbol2)
        } else if KeyboardView.symbols3.contains(String(nextCharacter)) {
            alphabetKeyboardView.change(to: .symbol3)
        } else if KeyboardView.symbols4.contains(String(nextCharacter)) {
            alphabetKeyboardView.change(to: .symbol4)
        } else if KeyboardView.numbers1.contains(String(nextCharacter)) {
            alphabetKeyboardView.change(to: .number1)
        } else if KeyboardView.numbers2.contains(String(nextCharacter)) {
            alphabetKeyboardView.change(to: .number2)
        }
        alphabetKeyboardView.buttons.forEach { button in
            button.addTarget(self, action: #selector(handleButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
            guard let flickButton = button as? FlickButton else {
                return
            }
            flickButton.delegate = self
        }
    }
    
    private func shouldInsert(character: Character) -> Bool {
        let question = questions[activeQuestionIndex]
        guard let text = question.text else {
            return false
        }
        return question.answer[text.count] == character
    }
    
    @objc
    private func handleButtonTouchUpInsideEvent(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else {
            return
        }
        if shouldInsert(character: Character(title)) {
            questions[activeQuestionIndex].insertText(title)
        } else {
            
        }
    }
    
    @objc
    private func textFieldDidChanged(_ sender: UITextField) {
        guard let question = sender as? QuestionTextField else {
            return
        }
        guard question.markedTextRange == nil else {
            return
        }
        question.attributedText = SyntaxHighlighter.decorate(question.text, defaultColor: defaultColor, font: font, language: question.language)
        if question.text == question.answer {
            playCorrectAnimation()
            questions[activeQuestionIndex].isUserInteractionEnabled = false
            activeQuestionIndex += 1
            if activeQuestionIndex <= (questions.count - 1) {
                questions[activeQuestionIndex].isUserInteractionEnabled = true
                questions[activeQuestionIndex].becomeFirstResponder()
            }
        } else  {
            changeKeyboard()
        }
    }
    
}

extension LessonViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let question = textField as? QuestionTextField else {
            return true
        }
        guard let text = question.text else {
            return true
        }
        guard (text.count + string.count) <= question.answer.count else {
            playOverNumberOfCharactersAnimation()
            return false
        }
        return true
    }
    
}

extension LessonViewController: FlickButtonDelegate {
    
    func flickButton(_ flickButton: FlickButton, componentsWillAppear: [FlickButton.Position: UIView]) {
        alphabetKeyboardView.buttons.forEach { button in
            guard button != flickButton else {
                return
            }
            button.alpha = 0.25
        }
    }
    
    func flickButton(_ flickButton: FlickButton, didFlick view: UIView) {
        if let button = view as? FlickButton {
            if let title = button.title(for: .normal), shouldInsert(character: Character(title)) {
                questions[activeQuestionIndex].insertText(title)
            }
        } else if let label = view as? UILabel {
            if let text = label.text, shouldInsert(character: Character(text)) {
                questions[activeQuestionIndex].insertText(text)
            }
        }
    }
    
    func flickButton(_ flickButton: FlickButton, componentsDidDisappear: [FlickButton.Position : UIView]) {
        alphabetKeyboardView.buttons.forEach { button in
            guard button != flickButton else {
                return
            }
            button.alpha = 1
        }
    }
    
}

