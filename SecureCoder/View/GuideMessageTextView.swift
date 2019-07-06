import UIKit

class GuideMessageTextView: UITextView {
    
    var explainers: [Explainer]? {
        didSet {
            messageIndex = 0
            explainerIndex = 0
            settingNewExplainerHandler?(self)
            setMessage()
        }
    }
    var explainer: Explainer? {
        guard let explainers = explainers else {
            return nil
        }
        return explainerIndex < explainers.count ? explainers[explainerIndex] : nil
    }
    
    var settingNewExplainerHandler: ((GuideMessageTextView) -> Void)?
    var endNotificationHandler: ((GuideMessageTextView) -> Void)?
    var questionIndices = [Int]()
    
    private var explainerIndex = 0
    private var messageIndex = 0
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupGestureRecognizers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGestureRecognizers()
    }
    
    func setMessage() {
        guard let messages = explainer?.texts else {
            return
        }
        var syntaxHighlighter = SyntaxHighlighter(tintColor: .black, font: .boldSystemFont(ofSize: 16), lineSpacing: 8)
        syntaxHighlighter.delegate = GuideTextSyntaxHighlighter()
        var syntaxHighlighted = syntaxHighlighter.syntaxHighlight(messages[messageIndex])
        syntaxHighlighter.programingLanguage = .html
        syntaxHighlighted = syntaxHighlighter.syntaxHighlight(syntaxHighlighted)
        attributedText = syntaxHighlighted
    }
    
    private func setupGestureRecognizers() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:))))
    }
    
    @objc
    private func handleTapGesture(_ sender: UITapGestureRecognizer) {
        guard let explainers = explainers else {
            return
        }
        messageIndex += 1
        if explainerIndex < explainers.count {
            if messageIndex < explainers[explainerIndex].texts.count {
                setMessage()
            } else {
                questionIndices = explainers[explainerIndex].questionIndices
                messageIndex = 0
                explainerIndex += 1
                if explainerIndex < explainers.count {
                    settingNewExplainerHandler?(self)
                } else {
                    endNotificationHandler?(self)
                }
            }
        }
    }
    
}
