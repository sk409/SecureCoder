import UIKit

class KeyboardView: UIView {
    
    enum `Type` {
        case lowercasedAlphabet
        case uppercasedAlphabet
        case symbol1
        case symbol2
        case symbol3
        case symbol4
        case number1
        case number2
        case space
    }
    
    static var size: CGSize {
        let columnCount = 3
        let rowCount = 3
        return CGSize(
            width: KeyboardView.buttonSize * CGFloat(columnCount) + KeyboardView.spacing * CGFloat(columnCount - 1),
            height: KeyboardView.buttonSize * CGFloat(rowCount) + KeyboardView.spacing * CGFloat(rowCount - 1)
        )
    }
    
    static let buttonSize: CGFloat = 44
    static let symbols1 = ["!", "\"", "#", "$", "%", "&", "'", "(", ")",]
    static let symbols2 = ["+", "-", "*", "/", "=", "^", "~", "¥", "|",]
    static let symbols3 = ["@", "`", "[", "]", "{", "}", "<", ">", "_",]
    static let symbols4 = [",", ".", ";", ":", "?", nil, nil, nil, nil]
    static let numbers1 = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    static let numbers2 = [nil, nil, nil, nil, "0", nil, nil, nil, nil]
    
    private static let spacing: CGFloat = buttonSize
    private static let buttonBackgroundColor = UIColor(white: 0.35, alpha: 1)
    private static let buttonBorderWidth: CGFloat = 0.25
    private static let buttonBorderColor = UIColor.white.cgColor
    
    private static func makeFlickButton(title: String, componentTitles: [FlickButton.Position: String]) -> FlickButton {
        let font = UIFont.boldSystemFont(ofSize: 18)
        let button = FlickButton()
        button.setTitle(title, for: .normal)
        button.defaultColor = buttonBackgroundColor
        button.activeColor = .cyan
        button.titleLabel?.font = font
        button.layer.cornerRadius = buttonSize * 0.5
        button.layer.borderWidth = buttonBorderWidth
        button.layer.borderColor = buttonBorderColor
        for (location, componentTitle) in componentTitles {
            let component = UILabel()
            component.clipsToBounds = true
            component.text = componentTitle
            component.textColor = .white
            component.textAlignment = .center
            component.font = font
            component.layer.cornerRadius = buttonSize * 0.5
            switch location {
            case .top:
                button.topView = component
            case .bottom:
                button.bottomView = component
            case .left:
                button.leftView = component
            case .right:
                button.rightView = component
            }
        }
        return button
    }
    
    private static func makeStackView(_ arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.spacing = KeyboardView.spacing
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }
    
    
    private(set) var buttons = [UIButton]()
    
    private let container = UIStackView()
    private let space = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    func change(to type: Type) {
        switch type {
        case .lowercasedAlphabet:
            changeToAlphabetKeyboard(isUppercase: false)
        case .uppercasedAlphabet:
            changeToAlphabetKeyboard(isUppercase: true)
        case .symbol1:
            changeKeyboard(with: KeyboardView.symbols1)
        case .symbol2:
            changeKeyboard(with: KeyboardView.symbols2)
        case .symbol3:
            changeKeyboard(with: KeyboardView.symbols3)
        case .symbol4:
            changeKeyboard(with: KeyboardView.symbols4)
        case .number1:
            changeKeyboard(with: KeyboardView.numbers1)
        case .number2:
            changeKeyboard(with: KeyboardView.numbers2)
        case .space:
            changeToSpaceKeyboard()
        }
    }
    
    private func changeToAlphabetKeyboard(isUppercase: Bool) {
        space.removeFromSuperview()
        container.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        let abc = KeyboardView.makeFlickButton(title: "a", componentTitles: [.left: "b", .top: "c"])
        buttons.append(abc)
        let def = KeyboardView.makeFlickButton(title: "d", componentTitles: [.left: "e", .top: "f"])
        buttons.append(def)
        let ghi = KeyboardView.makeFlickButton(title: "g", componentTitles: [.left: "h", .top: "i"])
        buttons.append(ghi)
        let jkl = KeyboardView.makeFlickButton(title: "j", componentTitles: [.left: "k", .top: "l"])
        buttons.append(jkl)
        let mno = KeyboardView.makeFlickButton(title: "m", componentTitles: [.left: "n", .top: "o"])
        buttons.append(mno)
        let pqrs = KeyboardView.makeFlickButton(title: "p", componentTitles: [.left: "q", .top: "r", .right: "s"])
        buttons.append(pqrs)
        let tuv = KeyboardView.makeFlickButton(title: "t", componentTitles: [.left: "u", .top: "v"])
        buttons.append(tuv)
        let wxyz = KeyboardView.makeFlickButton(title: "w", componentTitles: [.left: "x", .top: "y", .right: "z"])
        buttons.append(wxyz)
        container.addArrangedSubview(KeyboardView.makeStackView([UIView(), abc, def]))
        container.addArrangedSubview(KeyboardView.makeStackView([ghi, jkl, mno]))
        container.addArrangedSubview(KeyboardView.makeStackView([pqrs, tuv, wxyz]))
        if isUppercase {
            buttons.forEach { button in
                guard let flickButton = button as? FlickButton else {
                    return
                }
                flickButton.setTitle(flickButton.title(for: .normal)?.uppercased(), for: .normal)
                flickButton.componentViews.values.forEach { componentView in
                    guard let label = componentView as? UILabel else {
                        return
                    }
                    label.text = label.text?.uppercased()
                }
            }
        }
    }
    
    private func changeKeyboard(with titles: [String?]) {
        space.removeFromSuperview()
        container.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        var arrangedSubviews = [UIView]()
        for (index, title) in titles.enumerated() {
            if let title = title {
                let button = UIButton()
                buttons.append(button)
                button.setTitle(title, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = KeyboardView.buttonBackgroundColor
                button.layer.borderWidth = KeyboardView.buttonBorderWidth
                button.layer.borderColor = KeyboardView.buttonBorderColor
                arrangedSubviews.append(button)
            } else {
                arrangedSubviews.append(UIView())
            }
            if (index + 1).isMultiple(of: 3) {
                container.addArrangedSubview(KeyboardView.makeStackView(arrangedSubviews))
                arrangedSubviews.removeAll()
            }
        }
    }
    
    private func changeToSpaceKeyboard() {
        container.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        addSubview(space)
        space.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        space.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        space.widthAnchor.constraint(equalToConstant: KeyboardView.buttonSize).isActive = true
        space.heightAnchor.constraint(equalToConstant: KeyboardView.buttonSize).isActive = true
        buttons.append(space)
    }

    private func setupSubviews() {
        
        addSubview(container)
        container.distribution = .fillEqually
        container.axis = .vertical
        container.spacing = KeyboardView.spacing
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        container.widthAnchor.constraint(equalToConstant: KeyboardView.size.width).isActive = true
        container.heightAnchor.constraint(equalToConstant: KeyboardView.size.height).isActive = true
        
        space.setTitle(" ", for: .normal)
        space.backgroundColor = KeyboardView.buttonBackgroundColor
        space.layer.borderColor = KeyboardView.buttonBorderColor
        space.layer.borderWidth = KeyboardView.buttonBorderWidth
        space.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
}
