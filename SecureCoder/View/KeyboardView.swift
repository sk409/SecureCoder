import UIKit

class KeyboardView: UIView {
    
    var buttonMargins = CGSize(width: 8, height: 8)
    var contentInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    private(set) var buttons = [UIButton]()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layoutButtons()
    }
    
    func setWords(_ words: [String]) {
        buttons.removeAll(keepingCapacity: true)
        var pointer = CGPoint(x: contentInsets.left, y: contentInsets.top)
        var maxHeightInRow: CGFloat = 0
        let shuffledWords = words.shuffled()
        for word in shuffledWords {
            let button = UIButton()
            addSubview(button)
            buttons.append(button)
            button.frame.origin = pointer
            button.setTitle(word, for: .normal)
            let size = button.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
            pointer.x += size.width
            maxHeightInRow = max(maxHeightInRow, size.height)
            if safeAreaLayoutGuide.layoutFrame.maxX < pointer.x {
                pointer.x = 0
                pointer.y += maxHeightInRow
            }
        }
    }
    
    func layoutButtons() {
        var pointer = CGPoint(x: contentInsets.left, y: contentInsets.top)
        var maxHeightInRow: CGFloat = 0
        for button in buttons {
            let size = button.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
            if safeAreaLayoutGuide.layoutFrame.maxX < (pointer.x + size.width + contentInsets.right) {
                pointer.x = contentInsets.left
                pointer.y += (maxHeightInRow + buttonMargins.height)
            }
            button.frame = CGRect(origin: pointer, size: size)
            pointer.x += (size.width + buttonMargins.width)
            maxHeightInRow = max(maxHeightInRow, size.height)
        }
    }
    
}
