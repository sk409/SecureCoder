import UIKit

class AutoCorrectView: UIView {
    
    var texts: [String]? {
        didSet {
            guard let texts = texts else {
                return
            }
            var contentWidth: CGFloat = 0
            for text in texts {
                let button = UIButton(type: .system)
                scrollView.addSubview(button)
                button.backgroundColor = .white
                button.layer.borderWidth = 0.2
                button.layer.borderColor = UIColor.lightGray.cgColor
                button.setTitle(text, for: .normal)
                var size = button.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
                let padding: CGFloat = bounds.width * 0.05
                let minWidth = bounds.width * 0.25
                size.width = max(size.width + padding, minWidth)
                button.frame = CGRect(x: contentWidth, y: 0, width: size.width, height: bounds.height)
                contentWidth += size.width
            }
            scrollView.frame = frame
            scrollView.contentSize.width = contentWidth
        }
    }
    
    private let scrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .white
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.frame = frame
        scrollView.contentSize = bounds.size
    }
    
}
