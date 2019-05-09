import UIKit

class KeyboardSymbolView: UIView {
    
    private(set) var views = [UIView]()
    
    private var stackedSubviews1 = [UIView]()
    private var stackedSubviews2 = [UIView]()
    private var stackedSubviews3 = [UIView]()
    private var stackedSubviews4 = [UIView]()
    private var stackedSubviews5 = [UIView]()
    
    private var numericKeypadStackedSubviews1 = [UIView]()
    private var numericKeypadStackedSubviews2 = [UIView]()
    private var numericKeypadStackedSubviews3 = [UIView]()
    private var numericKeypadStackedSubviews4 = [UIView]()
    private var numericKeypadStackedSubviews5 = [UIView]()
    
    private let enter1 = KeyboardInputButton()
    private let enter2 = KeyboardInputButton()
    
    private let _0 = KeyboardInputButton()
    private let dot = KeyboardInputButton()
    
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
        let spacing: CGFloat = 8
        let maxButtonCountInStackView = 10
        let buttonWidth = (bounds.width - spacing * CGFloat(maxButtonCountInStackView - 1)) / CGFloat(maxButtonCountInStackView)
        let buttonCountInStackview1 = stackedSubviews1.count
        let buttonCountInStackview2 = stackedSubviews2.count
        let buttonCountInStackview3 = stackedSubviews3.count
        let buttonCountInStackview4 = stackedSubviews4.count
        let buttonCountInStackview5 = stackedSubviews5.count
        let buttonCountInNumericKeypadStackView4 = numericKeypadStackedSubviews4.count
        let stackView1 = UIStackView(arrangedSubviews: stackedSubviews1)
        let stackView2 = UIStackView(arrangedSubviews: stackedSubviews2)
        let stackView3 = UIStackView(arrangedSubviews: stackedSubviews3)
        let stackView4 = UIStackView(arrangedSubviews: stackedSubviews4)
        let stackView5 = UIStackView(arrangedSubviews: stackedSubviews5)
        let numericKeypadStackView1 = UIStackView(arrangedSubviews: numericKeypadStackedSubviews1)
        let numericKeypadStackView2 = UIStackView(arrangedSubviews: numericKeypadStackedSubviews2)
        let numericKeypadStackView3 = UIStackView(arrangedSubviews: numericKeypadStackedSubviews3)
        let numericKeypadStackView4 = UIStackView(arrangedSubviews: numericKeypadStackedSubviews4)
        addSubview(stackView1)
        addSubview(enter1)
        addSubview(stackView2)
        addSubview(stackView3)
        addSubview(stackView4)
        addSubview(stackView5)
        addSubview(numericKeypadStackView1)
        addSubview(numericKeypadStackView2)
        addSubview(numericKeypadStackView3)
        addSubview(numericKeypadStackView4)
        addSubview(enter2)
        addSubview(_0)
        addSubview(dot)
        
        stackView1.translatesAutoresizingMaskIntoConstraints = false
        stackView1.trailingAnchor.constraint(equalTo: stackView4.trailingAnchor).isActive = true
        stackView1.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        stackView1.widthAnchor.constraint(equalToConstant: buttonWidth * CGFloat(buttonCountInStackview1) + spacing * CGFloat(buttonCountInStackview1 - 1)).isActive = true
        stackView1.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        stackView1.spacing = spacing
        stackView1.distribution = .fillEqually
        
        enter1.translatesAutoresizingMaskIntoConstraints = false
        enter1.trailingAnchor.constraint(equalTo: stackView4.trailingAnchor).isActive = true
        enter1.topAnchor.constraint(equalTo: stackView1.bottomAnchor, constant: marginBetweenStackView).isActive = true
        enter1.widthAnchor.constraint(equalToConstant: buttonWidth * 1.5).isActive = true
        enter1.heightAnchor.constraint(equalToConstant: stackViewHeight * 2 + marginBetweenStackView).isActive = true
        
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        stackView2.trailingAnchor.constraint(equalTo: enter1.leadingAnchor, constant: -4).isActive = true
        stackView2.topAnchor.constraint(equalTo: stackView1.bottomAnchor, constant: marginBetweenStackView).isActive = true
        stackView2.widthAnchor.constraint(equalToConstant: buttonWidth * CGFloat(buttonCountInStackview2) + spacing * CGFloat(buttonCountInStackview2 - 1)).isActive = true
        stackView2.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        stackView2.spacing = spacing
        stackView2.distribution = .fillEqually
        
        stackView3.translatesAutoresizingMaskIntoConstraints = false
        stackView3.trailingAnchor.constraint(equalTo: enter1.leadingAnchor, constant: -4).isActive = true
        stackView3.topAnchor.constraint(equalTo: stackView2.bottomAnchor, constant: marginBetweenStackView).isActive = true
        stackView3.widthAnchor.constraint(equalToConstant: buttonWidth * CGFloat(buttonCountInStackview3) + spacing * CGFloat(buttonCountInStackview3 - 1)).isActive = true
        stackView3.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        stackView3.spacing = spacing
        stackView3.distribution = .fillEqually
        
        stackView4.translatesAutoresizingMaskIntoConstraints = false
        stackView4.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView4.topAnchor.constraint(equalTo: stackView3.bottomAnchor, constant: marginBetweenStackView).isActive = true
        stackView4.widthAnchor.constraint(equalToConstant: buttonWidth * CGFloat(buttonCountInStackview4) + spacing * CGFloat(buttonCountInStackview4 - 1)).isActive = true
        stackView4.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        stackView4.spacing = spacing
        stackView4.distribution = .fillEqually
        
        stackView5.translatesAutoresizingMaskIntoConstraints = false
        stackView5.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView5.topAnchor.constraint(equalTo: stackView4.bottomAnchor, constant: marginBetweenStackView).isActive = true
        stackView5.widthAnchor.constraint(equalToConstant: buttonWidth * CGFloat(buttonCountInStackview5) + spacing * CGFloat(buttonCountInStackview5 - 1)).isActive = true
        stackView5.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        stackView5.spacing = spacing
        stackView5.distribution = .fillEqually
        
        numericKeypadStackView1.translatesAutoresizingMaskIntoConstraints = false
        numericKeypadStackView1.leadingAnchor.constraint(equalTo: stackView1.trailingAnchor, constant: spacing).isActive = true
        numericKeypadStackView1.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        numericKeypadStackView1.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        numericKeypadStackView1.bottomAnchor.constraint(equalTo: stackView1.bottomAnchor).isActive = true
        numericKeypadStackView1.spacing = spacing
        numericKeypadStackView1.distribution = .fillEqually
        
        numericKeypadStackView2.translatesAutoresizingMaskIntoConstraints = false
        numericKeypadStackView2.leadingAnchor.constraint(equalTo: enter1.trailingAnchor, constant: spacing).isActive = true
        numericKeypadStackView2.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        numericKeypadStackView2.topAnchor.constraint(equalTo: numericKeypadStackView1.bottomAnchor, constant: marginBetweenStackView).isActive = true
        numericKeypadStackView2.bottomAnchor.constraint(equalTo: stackView2.bottomAnchor).isActive = true
        numericKeypadStackView2.spacing = spacing
        numericKeypadStackView2.distribution = .fillEqually
        
        numericKeypadStackView3.translatesAutoresizingMaskIntoConstraints = false
        numericKeypadStackView3.leadingAnchor.constraint(equalTo: enter1.trailingAnchor, constant: spacing).isActive = true
        numericKeypadStackView3.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        numericKeypadStackView3.topAnchor.constraint(equalTo: numericKeypadStackView2.bottomAnchor, constant: marginBetweenStackView).isActive = true
        numericKeypadStackView3.bottomAnchor.constraint(equalTo: stackView3.bottomAnchor).isActive = true
        numericKeypadStackView3.spacing = spacing
        numericKeypadStackView3.distribution = .fillEqually
        
        numericKeypadStackView4.translatesAutoresizingMaskIntoConstraints = false
        numericKeypadStackView4.leadingAnchor.constraint(equalTo: stackView4.trailingAnchor, constant: spacing).isActive = true
        numericKeypadStackView4.topAnchor.constraint(equalTo: numericKeypadStackView3.bottomAnchor, constant: marginBetweenStackView).isActive = true
        numericKeypadStackView4.bottomAnchor.constraint(equalTo: stackView4.bottomAnchor).isActive = true
        numericKeypadStackView4.widthAnchor.constraint(equalToConstant: buttonWidth * CGFloat(buttonCountInNumericKeypadStackView4) + spacing * CGFloat(buttonCountInNumericKeypadStackView4 - 1)).isActive = true
        numericKeypadStackView4.spacing = spacing
        numericKeypadStackView4.distribution = .fillEqually
        
        enter2.translatesAutoresizingMaskIntoConstraints = false
        enter2.leadingAnchor.constraint(equalTo: numericKeypadStackView4.trailingAnchor, constant: spacing).isActive = true
        enter2.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        enter2.topAnchor.constraint(equalTo: stackView4.topAnchor).isActive = true
        enter2.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        _0.translatesAutoresizingMaskIntoConstraints = false
        _0.leadingAnchor.constraint(equalTo: stackView5.trailingAnchor, constant: spacing).isActive = true
        _0.topAnchor.constraint(equalTo: numericKeypadStackView4.bottomAnchor, constant: marginBetweenStackView).isActive = true
        _0.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        _0.widthAnchor.constraint(equalToConstant: buttonWidth * 2 + spacing).isActive = true
        
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.leadingAnchor.constraint(equalTo: _0.trailingAnchor, constant: spacing).isActive = true
        dot.trailingAnchor.constraint(equalTo: enter2.leadingAnchor, constant: -spacing).isActive = true
        dot.topAnchor.constraint(equalTo: numericKeypadStackView4.bottomAnchor, constant: marginBetweenStackView).isActive = true
        dot.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupSubviews() {
        let buttonBackgroundColor = UIColor.black
        let buttonTitleColor = UIColor.white
        let textPairs1 = [("-", "="), ("^", "~"), ("¥", "|")]
        stackedSubviews1 = textPairs1.map { textPair in
            let keyboardInputButton = KeyboardInputButton()
            keyboardInputButton.text = textPair.0
            keyboardInputButton.shiftedText = textPair.1
            keyboardInputButton.backgroundColor = buttonBackgroundColor
            keyboardInputButton.setTitle(textPair.0, for: .normal)
            keyboardInputButton.setTitleColor(buttonTitleColor, for: .normal)
            return keyboardInputButton
        }
        let backSpace = KeyboardBackSpaceControlButton()
        backSpace.backgroundColor = buttonBackgroundColor
        backSpace.setImage(#imageLiteral(resourceName: "BackSpaceIcon"), for: .normal)
        stackedSubviews1 += [backSpace]
        views += stackedSubviews1
        
        let textPairs2 = [("@", "`"), ("[", "{")]
        stackedSubviews2 = textPairs2.map { textPair in
            let keyboardInputButton = KeyboardInputButton()
            keyboardInputButton.text = textPair.0
            keyboardInputButton.shiftedText = textPair.1
            keyboardInputButton.backgroundColor = buttonBackgroundColor
            keyboardInputButton.setTitle(textPair.0, for: .normal)
            keyboardInputButton.setTitleColor(buttonTitleColor, for: .normal)
            return keyboardInputButton
        }
        views += stackedSubviews2
        
        let textPairs3 = [(";", "+"), (":", "*"), ("]", "}")]
        stackedSubviews3 = textPairs3.map { textPair in
            let keyboardInputButton = KeyboardInputButton()
            keyboardInputButton.text = textPair.0
            keyboardInputButton.shiftedText = textPair.1
            keyboardInputButton.backgroundColor = buttonBackgroundColor
            keyboardInputButton.setTitle(textPair.0, for: .normal)
            keyboardInputButton.setTitleColor(buttonTitleColor, for: .normal)
            return keyboardInputButton
        }
        views += stackedSubviews3
        
        let textPairs4 = [(",", "<"), (".", ">"), ("/", "?"), ("_", "_")]
        stackedSubviews4 = textPairs4.map { textPair in
            let keyboardInputButton = KeyboardInputButton()
            keyboardInputButton.text = textPair.0
            keyboardInputButton.shiftedText = textPair.1
            keyboardInputButton.backgroundColor = buttonBackgroundColor
            keyboardInputButton.setTitle(textPair.0, for: .normal)
            keyboardInputButton.setTitleColor(buttonTitleColor, for: .normal)
            return keyboardInputButton
        }
        let shift = KeyboardShiftControlButton()
        shift.backgroundColor = buttonBackgroundColor
        shift.setTitle("!", for: .normal)
        shift.setTitleColor(buttonTitleColor, for: .normal)
        stackedSubviews4 += [shift]
        views += stackedSubviews4
        
        let home = KeyboardHomeControlButton()
        home.backgroundColor = buttonBackgroundColor
        home.setImage(#imageLiteral(resourceName: "HomeIcon"), for: .normal)
        let end = KeyboardEndControlButton()
        end.backgroundColor = buttonBackgroundColor
        end.setImage(#imageLiteral(resourceName: "EndIcon"), for: .normal)
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
        stackedSubviews5 = [home, end, left, upDownControlButtonsStackView, right]
        views += stackedSubviews5
        
        enter1.text = "\n"
        enter1.shiftedText = "\n"
        enter1.title = "↩︎"
        enter1.shiftedTitle = "↩︎"
        enter1.backgroundColor = buttonBackgroundColor
        enter1.setTitleColor(buttonTitleColor, for: .normal)
        views += [enter1]
        
        let delete = KeyboardDeleteControlButton()
        delete.backgroundColor = buttonBackgroundColor
        delete.setImage(#imageLiteral(resourceName: "DeleteIcon"), for: .normal)
        numericKeypadStackedSubviews1 = [delete]
        let numericKeypadTextPairs1 = [("=", "="), ("/", "/"), ("*", "*"), ("(", "(")]
        numericKeypadStackedSubviews1 += numericKeypadTextPairs1.map { textPair in
            let keyboardInputButton = KeyboardInputButton()
            keyboardInputButton.text = textPair.0
            keyboardInputButton.shiftedText = textPair.1
            keyboardInputButton.backgroundColor = buttonBackgroundColor
            keyboardInputButton.setTitle(textPair.0, for: .normal)
            keyboardInputButton.setTitleColor(buttonTitleColor, for: .normal)
            return keyboardInputButton
        }
        views += numericKeypadStackedSubviews1
        
        let numericKeypadTextPairs2 = [("7", "7"), ("8", "8"), ("9", "9"), ("-", "-"), (")", ")")]
        numericKeypadStackedSubviews2 += numericKeypadTextPairs2.map { textPair in
            let keyboardInputButton = KeyboardInputButton()
            keyboardInputButton.text = textPair.0
            keyboardInputButton.shiftedText = textPair.1
            keyboardInputButton.backgroundColor = buttonBackgroundColor
            keyboardInputButton.setTitle(textPair.0, for: .normal)
            keyboardInputButton.setTitleColor(buttonTitleColor, for: .normal)
            return keyboardInputButton
        }
        views += numericKeypadStackedSubviews2
        
        let numericKeypadTextPairs3 = [("4", "4"), ("5", "5"), ("6", "6"), ("+", "+"), (" ", " ")]
        numericKeypadStackedSubviews3 += numericKeypadTextPairs3.map { textPair in
            let keyboardInputButton = KeyboardInputButton()
            keyboardInputButton.text = textPair.0
            keyboardInputButton.shiftedText = textPair.1
            keyboardInputButton.backgroundColor = buttonBackgroundColor
            keyboardInputButton.setTitle(textPair.0, for: .normal)
            keyboardInputButton.setTitleColor(buttonTitleColor, for: .normal)
            return keyboardInputButton
        }
        views += numericKeypadStackedSubviews3
        
        let numericKeypadTextPairs4 = [("1", "1"), ("2", "2"), ("3", "3")]
        numericKeypadStackedSubviews4 += numericKeypadTextPairs4.map { textPair in
            let keyboardInputButton = KeyboardInputButton()
            keyboardInputButton.text = textPair.0
            keyboardInputButton.shiftedText = textPair.1
            keyboardInputButton.backgroundColor = buttonBackgroundColor
            keyboardInputButton.setTitle(textPair.0, for: .normal)
            keyboardInputButton.setTitleColor(buttonTitleColor, for: .normal)
            return keyboardInputButton
        }
        views += numericKeypadStackedSubviews4
        
        enter2.text = "\n"
        enter2.shiftedText = "\n"
        enter2.title = "↩︎"
        enter2.shiftedTitle = "↩︎"
        enter2.backgroundColor = buttonBackgroundColor
        enter2.setTitleColor(buttonTitleColor, for: .normal)
        views += [enter2]
        
        _0.text = "0"
        _0.shiftedText = "0"
        _0.backgroundColor = buttonBackgroundColor
        _0.setTitleColor(buttonTitleColor, for: .normal)
        views += [_0]
        
        dot.text = "."
        dot.shiftedText = "."
        dot.backgroundColor = buttonBackgroundColor
        dot.setTitleColor(buttonTitleColor, for: .normal)
        views += [dot]
    }
    
}
