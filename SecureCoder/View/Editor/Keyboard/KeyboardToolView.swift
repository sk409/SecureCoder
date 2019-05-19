import UIKit

class KeyboardToolView: UIView {
    
    let autoCorrectView = AutoCorrectView()
    let toggleKeyboardButton = UIButton(type: .system)
    let doneButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let buttonWidth: CGFloat = 44
        addSubview(autoCorrectView)
        autoCorrectView.translatesAutoresizingMaskIntoConstraints = false
        autoCorrectView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        autoCorrectView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        autoCorrectView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        autoCorrectView.widthAnchor.constraint(equalToConstant: bounds.width - (buttonWidth * 2)).isActive = true
        addSubview(toggleKeyboardButton)
        toggleKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        toggleKeyboardButton.leadingAnchor.constraint(equalTo: autoCorrectView.trailingAnchor).isActive = true
        toggleKeyboardButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        toggleKeyboardButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        toggleKeyboardButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        toggleKeyboardButton.backgroundColor = .red
        addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.leadingAnchor.constraint(equalTo: toggleKeyboardButton.trailingAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        doneButton.backgroundColor = .blue
    }
    
}
