import UIKit

class KeyboardAlphabetView: UIView {
    
    private(set) var views = [UIView]()
    
    private var stackedSubviews1 = [UIView]()
    private var stackedSubviews2 = [UIView]()
    private var stackedSubviews3 = [UIView]()
    private var stackedSubviews4 = [UIView]()
    private var stackedSubviews5 = [UIView]()
    
    private let enter = KeyboardInputButton()
    private let shift = KeyboardShiftControlButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let safeAreaHeight = bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
        let marginBetweenStackView: CGFloat = 8
        let stackViewCount = 5
        let stackViewHeight = (safeAreaHeight - marginBetweenStackView * CGFloat(stackViewCount - 1)) / CGFloat(stackViewCount)
        let spacingInStackView1: CGFloat = 8
        let buttonCountInStackView1 = 10
        let buttonWidth = (bounds.width - spacingInStackView1 * CGFloat(buttonCountInStackView1 - 1)) / CGFloat(buttonCountInStackView1)
        let stackView1 = UIStackView(arrangedSubviews: stackedSubviews1)
        addSubview(stackView1)
        stackView1.translatesAutoresizingMaskIntoConstraints = false
        stackView1.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView1.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        stackView1.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        stackView1.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        stackView1.distribution = .fillEqually
        stackView1.spacing = spacingInStackView1
        let stackView2 = UIStackView(arrangedSubviews: stackedSubviews2)
        addSubview(stackView2)
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        stackView2.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView2.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        stackView2.topAnchor.constraint(equalTo: stackView1.bottomAnchor, constant: marginBetweenStackView).isActive = true
        stackView2.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        stackView2.distribution = .fillEqually
        stackView2.spacing = spacingInStackView1
        let stackView3 = UIStackView(arrangedSubviews: stackedSubviews3)
        addSubview(stackView3)
        stackView3.translatesAutoresizingMaskIntoConstraints = false
        stackView3.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: buttonWidth * 0.5).isActive = true
        stackView3.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -buttonWidth * 0.5).isActive = true
        stackView3.topAnchor.constraint(equalTo: stackView2.bottomAnchor, constant: marginBetweenStackView).isActive = true
        stackView3.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        stackView3.distribution = .fillEqually
        stackView3.spacing = (bounds.width - (buttonWidth * CGFloat(buttonCountInStackView1))) / CGFloat(buttonCountInStackView1 - 2)
        let stackView4 = UIStackView(arrangedSubviews: stackedSubviews4)
        addSubview(stackView4)
        stackView4.translatesAutoresizingMaskIntoConstraints = false
        stackView4.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: buttonWidth * 1.5).isActive = true
        stackView4.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -buttonWidth * 1.5).isActive = true
        stackView4.topAnchor.constraint(equalTo: stackView3.bottomAnchor, constant: marginBetweenStackView).isActive = true
        stackView4.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        stackView4.distribution = .fillEqually
        stackView4.spacing = (bounds.width - (buttonWidth * CGFloat(buttonCountInStackView1))) / CGFloat(buttonCountInStackView1 - 4)
        let stackView5 = UIStackView(arrangedSubviews: stackedSubviews5)
        addSubview(stackView5)
        stackView5.translatesAutoresizingMaskIntoConstraints = false
        stackView5.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView5.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        stackView5.topAnchor.constraint(equalTo: stackView4.bottomAnchor, constant: marginBetweenStackView).isActive = true
        stackView5.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        stackView5.distribution = .fillEqually
        stackView5.spacing = spacingInStackView1
        
        addSubview(shift)
        shift.translatesAutoresizingMaskIntoConstraints = false
        shift.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        shift.trailingAnchor.constraint(equalTo: stackView4.leadingAnchor, constant: -buttonWidth * 0.25).isActive = true
        shift.topAnchor.constraint(equalTo: stackView4.topAnchor).isActive = true
        shift.bottomAnchor.constraint(equalTo: stackView5.topAnchor, constant: -marginBetweenStackView).isActive = true
        addSubview(enter)
        enter.translatesAutoresizingMaskIntoConstraints = false
        enter.leadingAnchor.constraint(equalTo: stackView4.trailingAnchor, constant: buttonWidth * 0.25).isActive = true
        enter.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        enter.topAnchor.constraint(equalTo: stackView4.topAnchor).isActive = true
        enter.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
    }
    
    private func setupSubviews() {
        let buttonBackgroundColor = UIColor.black
        let buttonTitleColor = UIColor.white
        let textPairs1 = [("1", "!"), ("2", "\""), ("3", "#"), ("4", "$"), ("5", "%"), ("6", "&"), ("7", "'"), ("8", "("), ("9", ")"), ("0", "0")]
        stackedSubviews1 = textPairs1.map { textPair in
            let keyboardAlphabetInputButton = KeyboardInputButton()
            keyboardAlphabetInputButton.text = textPair.0
            keyboardAlphabetInputButton.shiftedText = textPair.1
            keyboardAlphabetInputButton.backgroundColor = buttonBackgroundColor
            keyboardAlphabetInputButton.setTitle(textPair.0, for: .normal)
            keyboardAlphabetInputButton.setTitleColor(buttonTitleColor, for: .normal)
            return keyboardAlphabetInputButton
        }
        views += stackedSubviews1
        let textPairs2 = [("q", "Q"), ("w", "W"), ("e", "E"), ("r", "R"), ("t", "T"), ("y", "Y"), ("u", "U"), ("i", "I"), ("o", "O"), ("p", "P")]
        stackedSubviews2 = textPairs2.map { textPair in
            let keyboardAlphabetInputButton = KeyboardInputButton()
            keyboardAlphabetInputButton.text = textPair.0
            keyboardAlphabetInputButton.shiftedText = textPair.1
            keyboardAlphabetInputButton.backgroundColor = buttonBackgroundColor
            keyboardAlphabetInputButton.setTitle(textPair.0, for: .normal)
            keyboardAlphabetInputButton.setTitleColor(buttonTitleColor, for: .normal)
            return keyboardAlphabetInputButton
        }
        views += stackedSubviews2
        let textPairs3 = [("a", "A"), ("s", "S"), ("d", "D"), ("f", "F"), ("g", "G"), ("h", "H"), ("j", "J"), ("k", "K"), ("l", "L")]
        stackedSubviews3 = textPairs3.map { textPair in
            let keyboardAlphabetInputButton = KeyboardInputButton()
            keyboardAlphabetInputButton.text = textPair.0
            keyboardAlphabetInputButton.shiftedText = textPair.1
            keyboardAlphabetInputButton.backgroundColor = buttonBackgroundColor
            keyboardAlphabetInputButton.setTitle(textPair.0, for: .normal)
            keyboardAlphabetInputButton.setTitleColor(buttonTitleColor, for: .normal)
            return keyboardAlphabetInputButton
        }
        views += stackedSubviews3
        let textPairs4 = [("z", "Z"), ("x", "X"), ("c", "C"), ("v", "V"), ("b", "B"), ("n", "N"), ("m", "M")]
        stackedSubviews4 = textPairs4.map { textPair in
            let keyboardAlphabetInputButton = KeyboardInputButton()
            keyboardAlphabetInputButton.text = textPair.0
            keyboardAlphabetInputButton.shiftedText = textPair.1
            keyboardAlphabetInputButton.backgroundColor = buttonBackgroundColor
            keyboardAlphabetInputButton.setTitle(textPair.0, for: .normal)
            keyboardAlphabetInputButton.setTitleColor(buttonTitleColor, for: .normal)
            return keyboardAlphabetInputButton
        }
        views += stackedSubviews4
        let less = KeyboardInputButton()
        less.text = "<"
        less.shiftedText = "<"
        less.backgroundColor = buttonBackgroundColor
        less.setTitle(less.text, for: .normal)
        less.setTitleColor(buttonTitleColor, for: .normal)
        let greater = KeyboardInputButton()
        greater.text = ">"
        greater.shiftedText = ">"
        greater.backgroundColor = buttonBackgroundColor
        greater.setTitle(greater.text, for: .normal)
        greater.setTitleColor(buttonTitleColor, for: .normal)
        let doubleQuotation = KeyboardInputButton()
        doubleQuotation.text = "\""
        doubleQuotation.shiftedText = "\""
        doubleQuotation.backgroundColor = buttonBackgroundColor
        doubleQuotation.setTitle(doubleQuotation.text, for: .normal)
        doubleQuotation.setTitleColor(buttonTitleColor, for: .normal)
        let dollar = KeyboardInputButton()
        dollar.text = "$"
        dollar.shiftedText = "$"
        dollar.backgroundColor = buttonBackgroundColor
        dollar.setTitle(dollar.text, for: .normal)
        dollar.setTitleColor(buttonTitleColor, for: .normal)
        let space = KeyboardInputButton()
        space.text = " "
        space.shiftedText = " "
        space.backgroundColor = buttonBackgroundColor
        space.setTitle(space.text, for: .normal)
        space.setTitleColor(buttonTitleColor, for: .normal)
        let equal = KeyboardInputButton()
        equal.text = "="
        equal.shiftedText = "="
        equal.backgroundColor = buttonBackgroundColor
        equal.setTitle(equal.text, for: .normal)
        equal.setTitleColor(buttonTitleColor, for: .normal)
        let underBar = KeyboardInputButton()
        underBar.text = "_"
        underBar.shiftedText = "_"
        underBar.backgroundColor = buttonBackgroundColor
        underBar.setTitle(underBar.text, for: .normal)
        underBar.setTitleColor(buttonTitleColor, for: .normal)
        let left = KeyboardLeftControlButton()
        left.backgroundColor = buttonBackgroundColor
        left.setTitle("◀︎", for: .normal)
        let up = KeyboardUpControlButton()
        up.backgroundColor = buttonBackgroundColor
        up.setTitle("▲", for: .normal)
        let down = KeyboardDownControlButton()
        down.backgroundColor = buttonBackgroundColor
        down.setTitle("▼", for: .normal)
        let upDownControlButtonsStackView = UIStackView(arrangedSubviews: [up, down])
        upDownControlButtonsStackView.axis = .vertical
        upDownControlButtonsStackView.distribution = .fillEqually
        upDownControlButtonsStackView.spacing = 2
        let right = KeyboardRightControlButton()
        right.backgroundColor = buttonBackgroundColor
        right.setTitle("▶︎", for: .normal)
        stackedSubviews5 = [less, greater, doubleQuotation, dollar, space, equal, underBar, left, upDownControlButtonsStackView, right]
        views += stackedSubviews5
        
        shift.backgroundColor = buttonBackgroundColor
        shift.setTitle("!", for: .normal)
        views += [shift]
        enter.text = "\n"
        enter.shiftedText = "\n"
        enter.title = "↩︎"
        enter.shiftedTitle = "↩︎"
        enter.backgroundColor = buttonBackgroundColor
        enter.setTitle("↩︎", for: .normal)
        enter.setTitleColor(buttonTitleColor, for: .normal)
        views += [enter]
    }
    
    
}
