import UIKit

class KeyboardView: UIView {
    
    static let rowCount = 3
    static let columnCount = 3
    
    let contentView = UIStackView()
    
    private(set) var buttons = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    func setTitlesRandom(answer: String) {
        var selectedCharacters = [answer]
        let candidates = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "!", "\"", "#", "$", "%", "&", "'", "(", ")", "-", "=", "^", "~", "¥", "|", "@", "`", "[", "{", ";", "+", ":", "+", "]", "}", ",", "<", ".", ">", "/", "?", "_",]
        let answerRowIndex = Int.random(in: 0...(KeyboardView.rowCount - 1))
        let answerColumnIndex = Int.random(in: 0...(KeyboardView.columnCount - 1))
        for rowIndex in 0...(KeyboardView.rowCount - 1) {
            for columnIndex in 0...(KeyboardView.columnCount - 1) {
                let button = buttons[rowIndex * KeyboardView.columnCount + columnIndex]
                button.alpha = 1
                var title = answer
                if rowIndex != answerRowIndex || columnIndex != answerColumnIndex {
                    while selectedCharacters.contains(title) {
                        title = candidates[Int.random(in: 0...(candidates.count - 1))]
                    }
                }
                selectedCharacters.append(title)
                button.setTitle(title, for: .normal)
            }
        }
    }
    
    func setTitle(rowIndex: Int, columnIndex: Int, title: String) {
        for i in 0...(KeyboardView.rowCount - 1) {
            for j in 0...(KeyboardView.columnCount - 1) {
                let button = buttons[i * KeyboardView.columnCount + j]
                if i == rowIndex && j == columnIndex {
                    button.setTitle(title, for: .normal)
                } else {
                    button.alpha = 0
                }
            }
        }
    }
    
    private func setupSubviews() {
        addSubview(contentView)
        contentView.distribution = .fillEqually
        contentView.axis = .vertical
        contentView.spacing = 8
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            contentView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
            ])
        for _ in 0...(KeyboardView.rowCount - 1) {
            let row = UIStackView()
            contentView.addArrangedSubview(row)
            row.distribution = .fillEqually
            row.axis = .horizontal
            row.spacing = 8
            for _ in 0...(KeyboardView.columnCount - 1) {
                let button = UIButton()
                buttons.append(button)
                row.addArrangedSubview(button)
                button.backgroundColor = UIColor(white: 0.35, alpha: 1)
                button.layer.borderColor = UIColor.white.cgColor
                button.layer.borderWidth = 0.25
                //button.layer.cornerRadius = 22
                button.setTitleColor(.white, for: .normal)
            }
        }
    }
    
}
