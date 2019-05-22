//import UIKit
//
//class KeyboardView: UIView {
//    
//    private static func makeKeyboardInputButtons(_ textPairs: [(String, String?)]) -> [KeyboardButton] {
//        return textPairs.map { textPair -> KeyboardInputButton in
//            if let shiftedText = textPair.1 {
//                let keyboardInputButton = KeyboardInputButton(text: textPair.0, shiftedText: shiftedText)
//                keyboardInputButton.backgroundColor = .white
//                return keyboardInputButton
//            }
//            let keyboardInputButton = KeyboardInputButton(text: textPair.0)
//            keyboardInputButton.backgroundColor = .white
//            return keyboardInputButton
//        }
//    }
//    
//    var buttons = [KeyboardButton]()
//    
//    private let scrollView = UIScrollView()
//    
//    private let buttons1 = KeyboardView.makeKeyboardInputButtons([
//        ("1", "!"),
//        ("2", "\""),
//        ("3", "#"),
//        ("4", "$"),
//        ("5", "%"),
//        ("6", "&"),
//        ("7", "'"),
//        ("8", "("),
//        ("9", ")"),
//        ("0", "0"),
//        ("-", "="),
//        ("^", "~"),
//        ("¥", "|"),])
//        + [KeyboardBackSpaceControlButton()]
//        + KeyboardView.makeKeyboardInputButtons([
//            (" ", " "),
//            ("/", nil),
//            ("*", nil),])
//        + [KeyboardDeleteControlButton()]
//    
//    private let buttons2_1 = KeyboardView.makeKeyboardInputButtons([
//        ("q", "Q"),
//        ("w", "W"),
//        ("e", "E"),
//        ("r", "R"),
//        ("t", "T"),
//        ("y", "Y"),
//        ("u", "U"),
//        ("i", "I"),
//        ("o", "O"),
//        ("p", "P"),
//        ("@", "`"),
//        ("[", "{"),])
//    
//    private let buttons2_2 = KeyboardView.makeKeyboardInputButtons(
//        [("7", nil),
//         ("8", nil),
//         ("9", nil),
//         ("-", nil),]
//    )
//    
//    private let buttons3_1 = KeyboardView.makeKeyboardInputButtons([
//        ("a", "A"),
//        ("s", "S"),
//        ("d", "D"),
//        ("f", "F"),
//        ("g", "G"),
//        ("h", "H"),
//        ("j", "J"),
//        ("k", "K"),
//        ("l", "L"),
//        (";", "+"),
//        (":", "*"),
//        ("]", "}"),]
//    )
//    private let buttons3_2 = KeyboardView.makeKeyboardInputButtons([
//        ("4", nil),
//        ("5", nil),
//        ("6", nil),
//        ("+", nil),]
//    )
//    private let buttons4_1 = KeyboardView.makeKeyboardInputButtons([
//        ("z", "Z"),
//        ("x", "X"),
//        ("c", "C"),
//        ("v", "V"),
//        ("b", "B"),
//        ("n", "N"),
//        ("m", "M"),
//        (",", "<"),
//        (".", ">"),
//        ("/", "?"),
//        ("_", nil),]
//    )
//    private let buttons4_2 = KeyboardView.makeKeyboardInputButtons(
//        [("1", nil),
//         ("2", nil),
//         ("3", nil),]
//    )
//    private let buttons5_1: [KeyboardButton] = [
//        KeyboardHomeControlButton(type: .system),
//        KeyboardEndControlButton(type: .system),
//        KeyboardBackSpaceControlButton(type: .system),
//        KeyboardDeleteControlButton(type: .system),
//    ]
//    
//    private let pageUp = KeyboardPageUpControlButton()
//    private let pageDown = KeyboardPageDownControlButton()
//    private let home = KeyboardHomeControlButton()
//    private let end = KeyboardEndControlButton()
//    private let left = KeyboardLeftControlButton()
//    private let up = KeyboardUpControlButton()
//    private let down = KeyboardDownControlButton()
//    private let right = KeyboardRightControlButton()
//    
//
//    private let enter1 = KeyboardInputButton(text: "\n", title: "↩︎")
//    private let enter2 = KeyboardInputButton(text: "\n", title: "↩︎")
//    private let shift1 = KeyboardShiftControlButton(type: .system)
//    private let shift2 = KeyboardShiftControlButton(type: .system)
//    private let space1 = KeyboardInputButton(text: " ")
//    private let _0 = KeyboardInputButton(text: "0")
//    private let dot = KeyboardInputButton(text: ".")
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .lightGray
//        buttons = buttons1 + buttons2_1 + buttons2_2 + buttons3_1 + buttons3_2 + buttons4_1 + buttons4_2 + buttons5_1 + Array<KeyboardButton>([pageUp, pageDown, home, end, left, up, down, right, enter1, enter2, shift1, shift2, space1, _0, dot])
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        setupSubviews()
//    }
//    
//    private func setupSubviews() {
//        
//        let contentWidth = bounds.width - safeAreaInsets.left - safeAreaInsets.right
//        let contentHeight = (bounds.height - safeAreaInsets.top - safeAreaInsets.bottom)
//        
//        let marginBetweenButtons: CGFloat = 8
//        let marginBetweenStackViews: CGFloat = 8
//        let stackViewRowCount: CGFloat = 5
//        let stackViewHeight = (contentHeight - (stackViewRowCount - 1) * marginBetweenStackViews) / stackViewRowCount
//        let maxButtonCount: CGFloat = 18
//        let buttonWidth = (contentWidth * 3 - marginBetweenButtons * (maxButtonCount - 1)) / maxButtonCount
//        
//        let addButtons: ([UIView], CGFloat, CGFloat, CGFloat?, CGFloat?) -> UIStackView = { views, x, y, width, height in
//            let stackView = UIStackView(arrangedSubviews: views)
//            self.scrollView.addSubview(stackView)
//            stackView.frame = CGRect(
//                x: x,
//                y: y,
//                width: width ?? buttonWidth * CGFloat(views.count) + marginBetweenButtons * CGFloat(views.count - 1),
//                height: height ?? stackViewHeight
//            )
//            stackView.spacing = marginBetweenButtons
//            stackView.distribution = .fillEqually
//            return stackView
//        }
//        
//        scrollView.frame = CGRect(x: safeAreaInsets.left, y: safeAreaInsets.top, width: contentWidth, height: contentHeight)
//        addSubview(scrollView)
//        scrollView.clipsToBounds = false
//        scrollView.isPagingEnabled = true
//        scrollView.contentSize = CGSize(
//            width: buttonWidth * maxButtonCount + marginBetweenButtons * (maxButtonCount - 1),
//            height: contentHeight
//        )
//        
//        
//        _ = addButtons(buttons1, 0, 0, nil, nil)
//        
//        let stackView2_1 = addButtons(buttons2_1, buttonWidth * 0.5, stackViewHeight + marginBetweenStackViews, nil, nil)
//        
//        let enterStackView1 = addButtons(
//            [enter1],
//            stackView2_1.frame.origin.x + stackView2_1.bounds.width + marginBetweenButtons * 2 + buttonWidth * 0.5,
//            stackView2_1.frame.origin.y,
//            nil,
//            stackViewHeight * 2 + marginBetweenStackViews
//        )
//        
//        _ = addButtons(
//            buttons2_2,
//            enterStackView1.frame.origin.x + enterStackView1.bounds.width + marginBetweenButtons,
//            stackView2_1.frame.origin.y,
//            nil, nil
//        )
//        
//        _ = addButtons(buttons3_1, buttonWidth, (stackViewHeight + marginBetweenStackViews) * 2, nil, nil)
//        
//        _ = addButtons(
//            buttons3_2,
//            enterStackView1.frame.origin.x + enterStackView1.bounds.width + marginBetweenButtons,
//            (stackViewHeight + marginBetweenStackViews) * 2,
//            nil, nil
//        )
//        
//        let shiftStackView1 = addButtons(
//            [shift1],
//            0,
//            (stackViewHeight + marginBetweenStackViews) * 3,
//            buttonWidth * 1.5,
//            stackViewHeight
//        )
//        
//        let stackView4_1 = addButtons(
//            buttons4_1,
//            shiftStackView1.bounds.width + marginBetweenButtons,
//            shiftStackView1.frame.origin.y,
//            nil, nil
//        )
//        
//        let shiftStackView2 = addButtons(
//            [shift2],
//            stackView4_1.frame.origin.x + stackView4_1.bounds.width + marginBetweenButtons,
//            shiftStackView1.frame.origin.y,
//            buttonWidth * 1.5 + marginBetweenButtons,
//            nil
//        )
//        
//        let stackView4_2 = addButtons(
//            buttons4_2,
//            shiftStackView2.frame.origin.x + shiftStackView2.bounds.width + marginBetweenButtons,
//            shiftStackView1.frame.origin.y,
//            nil, nil
//        )
//        
//        _ = addButtons(
//            [enter2],
//            stackView4_2.frame.origin.x + stackView4_2.bounds.width + marginBetweenButtons,
//            shiftStackView1.frame.origin.y,
//            nil,
//            stackViewHeight * 2 + marginBetweenStackViews
//        )
//        
//        let stackView5_1 = addButtons(buttons5_1, 0, (stackViewHeight + marginBetweenStackViews) * 4, nil, nil)
//        
//        let updown = UIStackView(arrangedSubviews: [up, down])
//        updown.axis = .vertical
//        updown.distribution = .fillEqually
//        updown.spacing = marginBetweenButtons * 0.5
//        
//        let buttons5_2 = [pageUp, pageDown, home, end, left, updown, right]
//        let width5_2 = buttonWidth * CGFloat(buttons5_2.count) + marginBetweenButtons * CGFloat(buttons5_2.count - 1)
//        let stackView5_2 = addButtons(
//            buttons5_2,
//            enterStackView1.frame.origin.x + enterStackView1.bounds.width - width5_2,
//            stackView5_1.frame.origin.y,
//            nil,
//            nil
//        )
//        
//        _ = addButtons(
//            [space1],
//            stackView5_1.frame.origin.x + stackView5_1.bounds.width + marginBetweenButtons,
//            stackView5_1.frame.origin.y,
//            buttonWidth * 14 + marginBetweenButtons * 11 - stackView5_1.bounds.width - stackView5_2.bounds.width,
//            nil
//        )
//        
//        let _0StackView = addButtons(
//            [_0],
//            stackView5_2.frame.origin.x + stackView5_2.bounds.width + marginBetweenButtons,
//            stackView5_1.frame.origin.y,
//            buttonWidth * 2 + marginBetweenButtons,
//            nil
//        )
//        
//        _ = addButtons(
//            [dot],
//            _0StackView.frame.origin.x + _0StackView.bounds.width + marginBetweenButtons,
//            stackView5_1.frame.origin.y,
//            nil, nil
//        )
//    }
//    
//}
