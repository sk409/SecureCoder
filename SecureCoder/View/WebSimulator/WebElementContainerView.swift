import UIKit

class WebElementContainerView: WebElementView {
    
    override var margin: UIEdgeInsets {
        didSet {
            pointer.x = margin.left
            pointer.y = margin.top
        }
    }
    var elements: [WebElementView] {
        return elementsPerLine.flatMap({ $0 })
    }
    
    let scrollView = UIScrollView()
    
    private(set) var elementsPerLine = [[WebElementView]]()
    
    private var pointer = CGPoint.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func clear() {
        pointer = CGPoint(x: margin.left, y: margin.top)
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        scrollView.contentOffset = .zero
        scrollView.contentSize = .zero
    }
    
    func seekToTop() {
        pointer.x = margin.left
        pointer.y = margin.top
    }
    
    func append(element: WebElementView) {
        elementsPerLine[elementsPerLine.count - 1].append(element)
        scrollView.addSubview(element)
        element.frame.origin = pointer
        if element.frame.width == 0 && element.display == .block {
            element.frame.size.width = max(frame.width, element.fitSize.width)
        }
        element.frame.origin.x += element.margin.left
        element.frame.origin.y += element.margin.top
        scrollView.contentSize.width = max(element.frame.maxX + element.margin.right, scrollView.contentSize.width)
        scrollView.contentSize.height = max(element.frame.maxY + element.margin.bottom, scrollView.contentSize.height)
        let isNewLine = (frame.width <= (element.frame.maxX + element.margin.right))
        if isNewLine {
            appendBreak()
        } else {
            pointer.x = element.frame.maxX + element.margin.right
        }
        frame.size.width = max(frame.size.width, element.frame.size.width)
        frame.size.height = element.frame.maxY
    }
    
    func appendBreak() {
        pointer.x = margin.left
        if elementsPerLine.isEmpty || elementsPerLine.last!.isEmpty {
            pointer.y += 16
        } else {
            elementsPerLine.last?.forEach { pointer.y = max(pointer.y, $0.frame.maxY + $0.margin.bottom) }
        }
        elementsPerLine.append([])
        frame.size.height = pointer.y
    }
    
    private func setup() {
        elementsPerLine.append([])
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
}
