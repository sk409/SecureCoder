import UIKit

class GuideMessageCollectionView: UICollectionView {
    
//    var explainers: [Explainer]? {
//        didSet {
//            messageIndex = 0
//            explainerIndex = 0
//            settingNewExplainerHandler?(self)
//            setMessage()
//        }
//    }
//    var explainer: Explainer? {
//        guard let explainers = explainers else {
//            return nil
//        }
//        return explainerIndex < explainers.count ? explainers[explainerIndex] : nil
//    }
//    var message: NSAttributedString? {
//        var syntaxHighlighter = SyntaxHighlighter(tintColor: .white, font: .boldSystemFont(ofSize: 16), lineSpacing: 8)
//        syntaxHighlighter.delegate = GuideTextSyntaxHighlighter()
//        var syntaxHighlighted = syntaxHighlighter.syntaxHighlight(messages[messageIndex].text)
//        explainer?.messages[messageIndex].languages.forEach { language in
//            syntaxHighlighter.programingLanguage = language
//            if language == .php {
//                var phpSyntaxHighlighter = PHPSyntaxHighlighter()
//                phpSyntaxHighlighter.force = true
//                syntaxHighlighter.delegate = phpSyntaxHighlighter
//            }
//            syntaxHighlighted = syntaxHighlighter.syntaxHighlight(syntaxHighlighted)
//        }
//        attributedText = syntaxHighlighted
//    }
    
//    var settingNewExplainerHandler: ((GuideMessageCollectionView) -> Void)?
//    var endNotificationHandler: ((GuideMessageCollectionView) -> Void)?
//    var questionIndices = [Int]()
    
    let separator = UIView()
    
//    private var explainerIndex = 0
//    private var messageIndex = 0
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
//    func setMessage() {
//        guard let messages = explainer?.messages else {
//            return
//        }
//        var syntaxHighlighter = SyntaxHighlighter(tintColor: .white, font: .boldSystemFont(ofSize: 16), lineSpacing: 8)
//        syntaxHighlighter.delegate = GuideTextSyntaxHighlighter()
//        var syntaxHighlighted = syntaxHighlighter.syntaxHighlight(messages[messageIndex].text)
//        explainer?.messages[messageIndex].languages.forEach { language in
//            syntaxHighlighter.programingLanguage = language
//            if language == .php {
//                var phpSyntaxHighlighter = PHPSyntaxHighlighter()
//                phpSyntaxHighlighter.force = true
//                syntaxHighlighter.delegate = phpSyntaxHighlighter
//            }
//            syntaxHighlighted = syntaxHighlighter.syntaxHighlight(syntaxHighlighted)
//        }
//        attributedText = syntaxHighlighted
//    }
    
    private func setupViews() {
        backgroundColor = .black
        //textContainerInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        addSubview(separator)
        separator.backgroundColor = UIColor(white: 0.75, alpha: 1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            separator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            separator.heightAnchor.constraint(equalToConstant: 3),
            ])
    }
    
//    @objc
//    private func handleSwipeGestureRecognizer(_ sender: UISwipeGestureRecognizer) {
//        guard let explainers = explainers else {
//            return
//        }
//        if sender.direction == .left {
//            guard 0 < explainerIndex || 0 < messageIndex else {
//                return
//            }
//            messageIndex -= 1
//        } else {
//            messageIndex += 1
//        }
//        if explainerIndex < explainers.count {
//            if 0 <= messageIndex && messageIndex < explainers[explainerIndex].messages.count {
//                setMessage()
//            } else {
//                if messageIndex < 0 {
//                    explainerIndex -= 1
//                } else {
//                    explainerIndex += 1
//                }
//                messageIndex = 0
//                if explainerIndex < explainers.count {
//                    questionIndices = explainers[explainerIndex].questionIndices
//                    settingNewExplainerHandler?(self)
//                } else {
//                    endNotificationHandler?(self)
//                }
//            }
//        }
//    }
    
}
