import UIKit

class WebSimulatorView: UIView {
    
    var margins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    var elements: [WebElementView] {
        return elementsPerLine.flatMap({ $0 })
    }
    
    let contentView = UIScrollView()
    
    private(set) var elementsPerLine = [[WebElementView]]()
    
    private var pointer = CGPoint.zero
    private let bodyView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func clear() {
        pointer = CGPoint(x: margins.left, y: margins.top)
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func appendElement(_ elementView: WebElementView) {
        elementsPerLine[elementsPerLine.count - 1].append(elementView)
        contentView.addSubview(elementView)
        elementView.frame.origin = pointer
        if elementView.frame.width == 0 {
            elementView.frame.size.width = elementView.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity)).width
            if elementView.display == .block {
                elementView.frame.size.width = max(elementView.frame.size.width, safeAreaLayoutGuide.layoutFrame.width)
            }
        }
        elementView.frame.origin.x += elementView.margin.left
        elementView.frame.origin.y += elementView.margin.top
        contentView.contentSize.width = max(elementView.frame.maxX + elementView.margin.right, contentView.contentSize.width)
        contentView.contentSize.height = max(elementView.frame.maxY + elementView.margin.bottom, contentView.contentSize.height)
        let isNewLine = (safeAreaLayoutGuide.layoutFrame.width <= (elementView.frame.maxX + elementView.margin.right))
        if isNewLine {
            pointer.x = margins.left
            elementsPerLine.append([])
        } else {
            pointer.x = elementView.frame.maxX + elementView.margin.right
        }
        pointer.y = elementView.frame.maxY + elementView.margin.bottom
    }
    
    func appendBreak() {
        guard let lastLine = elementsPerLine.last else {
            return
        }
        pointer.x = margins.left
        var maxY: CGFloat = 0
        for elementView in lastLine {
            maxY = max(maxY, elementView.frame.maxY)
        }
        pointer.y = maxY
        elementsPerLine.append([])
    }
    
    private func setup() {
        elementsPerLine.append([])
        pointer.x = margins.left
        pointer.y = margins.top
        addSubview(bodyView)
        addSubview(contentView)
        bodyView.backgroundColor = .white
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            bodyView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
}
