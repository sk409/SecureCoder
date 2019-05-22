//import UIKit
//
//class EditorTextView: UITextView {
//    
//    var file: File? {
//        didSet {
//            guard let file = file else {
//                return
//            }
//            text = file.text
//            isEditable = file.isEditable
//            //
//            font = .systemFont(ofSize: 18)
//            //
//            codeAutoCompleter = PHPAutoCompleter()
//            //
//            codeSyntaxHighlighter = PHPSyntaxHighlighter(defaultColor: defaultColor, font: .systemFont(ofSize: 18))
//            //
//            decorateSyntaxHighlight(caretLocation: text!.count, synchronize: true)
//            sizeToFit()
//        }
//    }
//    
//    private(set) var defaultColor = UIColor.white
//    
//    private var codeAutoCompleter: CodeAutoCompleter?
//    private var codeSyntaxHighlighter: CodeSyntaxHighlighter?
//    
//    private var keyboardView: KeyboardView?
//    
//    override init(frame: CGRect, textContainer: NSTextContainer?) {
//        super.init(frame: frame, textContainer: textContainer)
//        setupInputControls()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupInputControls()
//    }
//    
//    override func sizeToFit() {
//        let size = sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
//        frame.size.width = size.width
//    }
//    
//    func completeCode() {
//        guard let file = file else {
//            return
//        }
//        guard let codeAutoCompleter = self.codeAutoCompleter else {
//            return
//        }
//        let completionResult = codeAutoCompleter.complete(text, selectedLocation: selectedRange.location)
//        let insertionAttributeText = NSAttributedString(string: completionResult.insertionText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
//        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText!)
//        mutableAttributedString.insert(insertionAttributeText, at: completionResult.insertionLocation)
//        attributedText = mutableAttributedString
//        selectedRange.location = completionResult.caretLocation
//        file.text = text!
//    }
//    
//    func decorateSyntaxHighlight(caretLocation: Int, synchronize: Bool) {
//        guard let codeSyntaxHighlighter = codeSyntaxHighlighter else {
//            return
//        }
//        if synchronize {
//            attributedText = codeSyntaxHighlighter.syntaxHighlight(text)
//            selectedRange.location = caretLocation
//        } else {
//            DispatchQueue.main.async {
//                let decorated = codeSyntaxHighlighter.syntaxHighlight(self.text)
//                DispatchQueue.main.async {
//                    if self.text == decorated.string {
//                        self.attributedText = decorated
//                        self.selectedRange.location = caretLocation
//                    }
//                }
//            }
//        }
//    }
//    
//    func autoCorrect() {
//        guard let keyboardToolView = inputAccessoryView as? KeyboardToolView else {
//            return
//        }
//        guard let lesson = Lesson.active else {
//            return
//        }
//        guard let file = file else {
//            return
//        }
//        lesson.save(file, with: text)
//        let token = PHP.Token(self)
//        let tmpText = text
//        let tmpSelectedRange = selectedRange
//        DispatchQueue.global().async {
//            var phpAutoCorrectSuggester = PHPAutoCorrectSuggester()
//            let suggestions = phpAutoCorrectSuggester.suggest(token: token, file: file, caretLocation: tmpSelectedRange.location)
//            DispatchQueue.main.async {
//                guard !suggestions.isEmpty else {
//                    keyboardToolView.autoCorrectView.clear()
//                    return
//                }
//                guard tmpText == self.text && tmpSelectedRange == self.selectedRange else {
//                    return
//                }
//                guard let keyboardToolView = self.inputAccessoryView as? KeyboardToolView else {
//                    return
//                }
//                keyboardToolView.autoCorrectView.suggestions = suggestions
//                for button in keyboardToolView.autoCorrectView.buttons {
//                    button.addTarget(self, action: #selector(self.handleAutoCorrectButtonTapEvent(_:)), for: .touchUpInside)
//                }
//            }
//        }
//    }
//    
//    func replace(in range: NSRange, with insertionText: String) {
//        guard let font = font else {
//            return
//        }
//        let replacedAttributedText = NSMutableAttributedString(attributedString: attributedText.attributedSubstring(from: NSRange(location: 0, length: range.location)))
//        replacedAttributedText.append(NSAttributedString(string: insertionText, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: defaultColor]))
//        replacedAttributedText.append(attributedText.attributedSubstring(from: NSRange(location: range.location + range.length, length: text.count - (range.location + range.length))))
//        attributedText = replacedAttributedText
//    }
//    
//    private func setupInputControls() {
//        let screenWidth = UIScreen.main.bounds.size.width
//        let keyboardToolViewHeight = UIScreen.main.bounds.size.height * 0.05
//        let keyboardToolView = KeyboardToolView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: keyboardToolViewHeight))
//        keyboardToolView.toggleKeyboardButton.addTarget(self, action: #selector(handleToggleKeyboardButtonTapEvent(_:)), for: .touchUpInside)
//        keyboardToolView.doneButton.addTarget(self, action: #selector(handleDoneButtonTapEvent(_:)), for: .touchUpInside)
//        inputAccessoryView = keyboardToolView
//        //let keyboardViewHeight = UIScreen.main.bounds.size.height * 0.35
//        let keyboardViewHeight: CGFloat = 252
//        keyboardView = KeyboardView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: keyboardViewHeight))
////        keyboardView = Bundle.main.loadNibNamed("KeyboardView", owner: self, options: nil)?.first as? KeyboardView
//        guard let keyboardView = keyboardView else {
//            return
//        }
//        //keyboardView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: keyboardViewHeight)
//        for button in keyboardView.buttons {
//            if button is KeyboardControlButton {
//                button.addTarget(self, action: #selector(handleKeyboardControlButtonTapEvent(_:)), for: .touchUpInside)
//            } else if button is KeyboardInputButton {
//                button.addTarget(self, action: #selector(handleKeyboardAlphabetInputButtonTapEvent(_:)), for: .touchUpInside)
//            }
//        }
//        inputView = keyboardView
//    }
//    
//    @objc
//    private func handleToggleKeyboardButtonTapEvent(_ sender: UIButton) {
//        inputView = (inputView == nil) ? keyboardView : nil
//        endEditing(true)
//        becomeFirstResponder()
//    }
//    
//    @objc
//    private func handleDoneButtonTapEvent(_ sender: UIButton) {
//        endEditing(true)
//    }
//    
//    @objc
//    private func handleKeyboardControlButtonTapEvent(_ sender: UIButton) {
//        guard let sender = sender as? KeyboardControlButton else {
//            return
//        }
//        sender.control(target: self)
//    }
//    
//    @objc
//    private func handleKeyboardAlphabetInputButtonTapEvent(_ sender: UIButton) {
//        guard let sender = sender as? KeyboardInputButton else {
//            return
//        }
//        sender.input(to: self)
//    }
//    
//    @objc
//    private func handleAutoCorrectButtonTapEvent(_ sender: UIButton) {
//        guard let keyboardToolView = inputAccessoryView as? KeyboardToolView else {
//            return
//        }
//        guard let replacementWord = (sender as? AutoCorrectButton)?.replacementWord else {
//            return
//        }
//        var startLocation = 0
//        for index in (0...(selectedRange.location - 1)).reversed() {
//            if !text[index].isPrintable() {
//                startLocation = index + 1
//                break
//            }
//        }
//        let range = NSRange(location: startLocation, length: selectedRange.location - startLocation)
//        replace(in: range, with: replacementWord)
//        selectedRange.location = range.location + replacementWord.count
//        decorateSyntaxHighlight(caretLocation: range.location + replacementWord.count, synchronize: false)
//        keyboardToolView.autoCorrectView.clear()
//    }
//    
////    @objc
////    private func handleKeyboardKanaInputButton(_ sender: UIButton) {
////        guard let sender = sender as? KeyboardKanaInputButton else {
////            return
////        }
////        guard let text = sender.titleLabel?.text else {
////            return
////        }
////        sender.input(to: self, text: text)
////        autoCorrect()
////    }
//    
//}
//
////extension EditorTextView: FlickButtonDelegate {
////    
////    func flickButton(_ flickButton: FlickButton, popUpViewsDidHide activeView: UIView?) {
////        guard let keyboardKanaInputButton = flickButton as? KeyboardKanaInputButton else {
////            return
////        }
////        guard let labelText = (activeView as? UILabel)?.text else {
////            return
////        }
////        keyboardKanaInputButton.input(to: self, text: labelText)
////    }
////    
////    func flickButton(_ flickButton: FlickButton, didFlick selectedView: UIView?) {
////        guard let keyboardKanaInputButton = flickButton as? KeyboardKanaInputButton else {
////            return
////        }
////        guard let labelText = (selectedView as? UILabel)?.text else {
////            return
////        }
////        keyboardKanaInputButton.input(to: self, text: labelText)
////    }
////    
////}
