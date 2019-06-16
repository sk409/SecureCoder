import UIKit

class KeyboardView: UIView {
    
    private(set) var buttons = [UIButton]()
    
    func build(with characters: [Character]) {
        //let characterSet = characters.reduce([Character]()) { $0.contains($1) ? $0 : $0 + [$1] }.shuffled()
        buttons.removeAll(keepingCapacity: true)
        let rowCount = Int(min(3, ceil(sqrt(CGFloat(characters.count)))))
        let columnCount = Int(ceil(CGFloat(characters.count) / CGFloat(rowCount)))
        let rowSpacing: CGFloat = 8
        let columnSpacing: CGFloat = 8
        let containerStackView = UIStackView()
        addSubview(containerStackView)
        containerStackView.axis = .vertical
        containerStackView.distribution = .fillEqually
        containerStackView.spacing = rowSpacing
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
        let shuffledCharacters = characters.shuffled()
        for rowIndex in 0..<rowCount {
            let buttonsStackView = UIStackView()
            buttonsStackView.axis = .horizontal
            buttonsStackView.distribution = .fillEqually
            buttonsStackView.spacing = columnSpacing
            for columnIndex in 0..<columnCount {
                let characterIndex = rowIndex * columnCount + columnIndex
                if characterIndex < shuffledCharacters.count {
                    let button = UIButton()
                    buttons.append(button)
                    buttonsStackView.addArrangedSubview(button)
                    button.setTitle(String(shuffledCharacters[characterIndex]), for: .normal)
                } else {
                    let dummy = UIView()
                    buttonsStackView.addArrangedSubview(dummy)
                }
            }
            containerStackView.addArrangedSubview(buttonsStackView)
        }
        let buttonSize: CGFloat = 44
        bounds.size = CGSize(
            width: CGFloat(columnCount) * buttonSize + CGFloat(columnCount - 1) * columnSpacing,
            height: CGFloat(rowCount) * buttonSize + CGFloat(rowCount - 1) * rowSpacing)
    }
    
}
