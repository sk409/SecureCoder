import UIKit

class EditorTextView: UITextView {
    
    var file: File? {
        didSet {
            guard let file = file else {
                return
            }
            text = file.text
            isEditable = file.isEditable
            //
            font = .systemFont(ofSize: 18)
            //
            codeAutoCompleter = PHPAutoCompleter()
            //
            codeSyntaxHighlighter = PHPSyntaxHighlighter(defaultColor: defaultColor, font: .systemFont(ofSize: 18))
            //
            decorateSyntaxHighlight(caretLocation: text!.count, synchronize: true)
            sizeToFit()
        }
    }
    
    private(set) var defaultColor = UIColor.white
    
    private var codeAutoCompleter: CodeAutoCompleter?
    private var codeSyntaxHighlighter: CodeSyntaxHighlighter?
    
    private var keyboardView: KeyboardView?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupInputControls()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInputControls()
    }
    
    override func sizeToFit() {
        let size = sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
        frame.size.width = size.width
    }
    
    func completeCode() {
        guard let file = file else {
            return
        }
        guard let codeAutoCompleter = self.codeAutoCompleter else {
            return
        }
        let completionResult = codeAutoCompleter.complete(text, selectedLocation: selectedRange.location)
        let insertionAttributeText = NSAttributedString(string: completionResult.insertionText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText!)
        mutableAttributedString.insert(insertionAttributeText, at: completionResult.insertionLocation)
        attributedText = mutableAttributedString
        selectedRange.location = completionResult.caretLocation
        file.setText(text!)
    }
    
    func decorateSyntaxHighlight(caretLocation: Int, synchronize: Bool) {
        guard let codeSyntaxHighlighter = codeSyntaxHighlighter else {
            return
        }
        if synchronize {
            attributedText = codeSyntaxHighlighter.syntaxHighlight(text)
            selectedRange.location = caretLocation
        } else {
            DispatchQueue.main.async {
                let decorated = codeSyntaxHighlighter.syntaxHighlight(self.text)
                DispatchQueue.main.async {
                    if self.text == decorated.string {
                        self.attributedText = decorated
                        self.selectedRange.location = caretLocation
                    }
                }
            }
        }
    }
    
    private func setupInputControls() {
        let screenWidth = UIScreen.main.bounds.size.width
        let keyboardToolViewHeight = UIScreen.main.bounds.size.height * 0.05
        let keyboardToolView = KeyboardToolView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: keyboardToolViewHeight))
        keyboardToolView.toggleKeyboardButton.addTarget(self, action: #selector(handleToggleKeyboardButtonTapEvent(_:)), for: .touchUpInside)
        keyboardToolView.doneButton.addTarget(self, action: #selector(handleDoneButtonTapEvent(_:)), for: .touchUpInside)
        inputAccessoryView = keyboardToolView
        let inputViewHeight = UIScreen.main.bounds.size.height * 0.35
        keyboardView = KeyboardView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: inputViewHeight))
        guard let keyboardView = keyboardView else {
            return
        }
        for view in (keyboardView.alphabetKeyboardView.views + keyboardView.symbolKeyboardView.views) {
            if let button = view as? UIButton {
                if button is KeyboardControlButton {
                    button.addTarget(self, action: #selector(handleKeyboardControlButtonTapEvent(_:)), for: .touchUpInside)
                } else if button is KeyboardInputButton {
                    button.addTarget(self, action: #selector(handleKeyboardAlphabetInputButtonTapEvent(_:)), for: .touchUpInside)
                }
                
            } else if let stackView = view as? UIStackView {
                for subview in stackView.arrangedSubviews {
                    if let button = subview as? UIButton {
                        if button is KeyboardControlButton {
                            button.addTarget(self, action: #selector(handleKeyboardControlButtonTapEvent(_:)), for: .touchUpInside)
                        } else if button is KeyboardInputButton {
                            button.addTarget(self, action: #selector(handleKeyboardAlphabetInputButtonTapEvent(_:)), for: .touchUpInside)
                        }
                    }
                }
            }
        }
//        if let kanaKeyboardView = keyboardInputView.kanaKeyboardView {
//            for kaneButton in kanaKeyboardView.buttons {
//                kaneButton.delegate = self
//                kaneButton.activeColor = .cyan
//                kaneButton.inactiveColor = .lightGray
//                kaneButton.addTarget(self, action: #selector(handleKeyboardKanaInputButton(_:))
//                    , for: .touchUpInside)
//            }
//        }
        inputView = keyboardView
    }
    
    private func autoCorrect() {
        guard var urlComponents = URLComponents(string: "http://www.google.com/transliterate") else {
            return
        }
        let markedText = (text as NSString).substring(with: NSRange(location: selectedRange.location, length: selectedRange.length))
        urlComponents.queryItems = [URLQueryItem(name: "langpair", value: "ja-Hira|ja"), URLQueryItem(name: "text", value: markedText + ",")]
        guard let url = urlComponents.url else {
            return
        }
        var candidateDictionaries: [[String: [String]]]?
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                semaphore.signal()
            }
            guard let data = data else {
                return
            }
            guard var jsonString = String(data: data, encoding: .utf8) else {
                return
            }
            let range = jsonString.range(of: ",")
            jsonString = jsonString.replacingCharacters(in: range!, with: ":")
            jsonString = jsonString.replacingCharacters(in: jsonString.index(jsonString.startIndex, offsetBy: 1)...jsonString.index(jsonString.startIndex, offsetBy: 1), with: "{")
            jsonString = jsonString.replacingCharacters(in: jsonString.index(jsonString.endIndex, offsetBy: -2)...jsonString.index(jsonString.endIndex, offsetBy: -2), with: "}")
            guard let candidateData = jsonString.data(using: .utf8) else {
                return
            }
            guard let result = try? JSONDecoder().decode([[String: [String]]].self, from: candidateData) else {
                return
            }
            candidateDictionaries = result
        }.resume()
        semaphore.wait()
        guard let autoCorrectView = (inputAccessoryView as? AutoCorrectView) else {
            return
        }
        guard let candidateTexts = candidateDictionaries?[0][String(markedText)] else {
            return
        }
        autoCorrectView.texts = candidateTexts
    }
    
    @objc
    private func handleToggleKeyboardButtonTapEvent(_ sender: UIButton) {
        inputView = (inputView == nil) ? keyboardView : nil
        endEditing(true)
        becomeFirstResponder()
    }
    
    @objc
    private func handleDoneButtonTapEvent(_ sender: UIButton) {
        endEditing(true)
    }
    
    @objc
    private func handleKeyboardControlButtonTapEvent(_ sender: UIButton) {
        guard let sender = sender as? KeyboardControlButton else {
            return
        }
        sender.keyboardControlButton(control: self)
    }
    
    @objc
    private func handleKeyboardAlphabetInputButtonTapEvent(_ sender: UIButton) {
        guard let sender = sender as? KeyboardInputButton else {
            return
        }
        sender.input(to: self)
    }
    
    @objc
    private func handleKeyboardKanaInputButton(_ sender: UIButton) {
        guard let sender = sender as? KeyboardKanaInputButton else {
            return
        }
        guard let text = sender.titleLabel?.text else {
            return
        }
        sender.input(to: self, text: text)
        autoCorrect()
    }
    
}

extension EditorTextView: FlickButtonDelegate {
    
    func flickButton(_ flickButton: FlickButton, popUpViewsDidHide activeView: UIView?) {
        guard let keyboardKanaInputButton = flickButton as? KeyboardKanaInputButton else {
            return
        }
        guard let labelText = (activeView as? UILabel)?.text else {
            return
        }
        keyboardKanaInputButton.input(to: self, text: labelText)
        autoCorrect()
    }
    
    func flickButton(_ flickButton: FlickButton, didFlick selectedView: UIView?) {
        guard let keyboardKanaInputButton = flickButton as? KeyboardKanaInputButton else {
            return
        }
        guard let labelText = (selectedView as? UILabel)?.text else {
            return
        }
        keyboardKanaInputButton.input(to: self, text: labelText)
        autoCorrect()
    }
    
}
