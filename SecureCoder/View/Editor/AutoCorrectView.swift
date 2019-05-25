//import UIKit
//
//class AutoCorrectView: UIView {
//    
//    var suggestions: [AutoCorrectSuggestion.Literal]? {
//        didSet {
//            guard let suggestions = suggestions else {
//                return
//            }
//            clear()
//            var contentWidth: CGFloat = 0
//            for suggestion in suggestions {
//                let button = AutoCorrectButton(word: suggestion.word, replacementWord: suggestion.replacementWord, color: suggestion.color)
//                scrollView.addSubview(button)
//                buttons.append(button)
//                var size = button.sizeThatFits(CGSize(width: CGFloat.infinity, height: .infinity))
//                let padding: CGFloat = bounds.width * 0.05
//                let minWidth = bounds.width * 0.25
//                size.width = max(size.width + padding, minWidth)
//                button.frame = CGRect(x: contentWidth, y: 0, width: size.width, height: bounds.height)
//                contentWidth += size.width
//                let separator = UIView(frame: CGRect(x: button.frame.origin.x + button.bounds.size.width, y: 0, width: 1, height: bounds.height))
//                separator.backgroundColor = .white
//                scrollView.addSubview(separator)
//                separators.append(separator)
//                contentWidth += separator.bounds.size.width
//            }
//            scrollView.frame = frame
//            scrollView.contentSize.width = contentWidth
//            scrollView.contentOffset.x = 0
//        }
//    }
//    
//    private(set) var buttons = [UIButton]()
//    private var separators = [UIView]()
//    
//    private let scrollView = UIScrollView()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .black
//        setupSubviews()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func clear() {
//        buttons.forEach { $0.removeFromSuperview() }
//        buttons.removeAll()
//        separators.forEach { $0.removeFromSuperview() }
//        separators.removeAll()
//    }
//    
//    private func setupSubviews() {
//        addSubview(scrollView)
//        scrollView.frame = frame
//        scrollView.contentSize = bounds.size
//        scrollView.backgroundColor = .black
//    }
//    
//}
