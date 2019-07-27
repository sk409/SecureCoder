import UIKit

class CodeEditorView: UIView {
    
    var components: [UIView]? {
        didSet {
            questions = []
            templates = []
            fit()
            components?.forEach { component in
                scrollView.addSubview(component)
                if let questionTextField = component as? QuestionTextField {
                    self.questions?.append(questionTextField)
                } else if let templateLabel = component as? TemplateLabel {
                    self.templates?.append(templateLabel)
                }
            }
            if let scrollBuffer = scrollBuffer {
                scrollView.contentSize.width += scrollBuffer.width
                scrollView.contentSize.height += scrollBuffer.height
            }
        }
    }
    
    var file: File?
    var scrollBuffer: CGSize?
    
    var text: String {
        guard let components = components else {
            return ""
        }
        var text = ""
        for component in components {
            if let templateLabel = (component as? TemplateLabel), let labelText = templateLabel.text {
                text += labelText
            } else if let questionTextField = (component as? QuestionTextField),
                let textFieldText = questionTextField.text
            {
                text += textFieldText
            }
        }
        return text
    }
    //************************************************
    // 未テスト
    var answer: String {
        guard let components = components else {
            return ""
        }
        return components.reduce("") { result, view in
            if let templateLabel = (view as? TemplateLabel), let labelText = templateLabel.text {
                return result + labelText
            } else if let questionTextField = (view as? QuestionTextField) {
                return result + questionTextField.answer
            }
            return result
        }
    }
    //************************************************
    
    let scrollView = UIScrollView()
    
    private(set) var question: QuestionTextField? {
        willSet {
            question?.activate(isActive: false, keyboardViewDidShow: nil, keyboardViewDidHide: nil)
        }
    }
    private(set) var questions: [QuestionTextField]?
    private(set) var templates: [TemplateLabel]?
    
    private var focusableViews = [FocusableView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func focus(labelTexts: [String], componentIndices: [[Int]]) {
        guard let components = components else {
            return
        }
        var focuseViews = [UIView]()
        for component in components {
            guard let templateLabel = component as? TemplateLabel,
                  let labelText = templateLabel.text
            else {
                continue
            }
//            print(labelTexts.first)
//            print(labelText)
            if labelTexts.contains(labelText) {
//                templateLabel.focus(with: 0.5, borderWidth: 1, borderColor: UIColor.red.cgColor, backgroundColor: .white)
                focuseViews.append(component)
            }
        }
        for component in components {
            guard let templateLabel = component as? TemplateLabel,
                  !focuseViews.contains(component) else {
                continue
            }
            templateLabel.unfocus(with: 0.5)
        }
        for componentIndexArray in componentIndices {
            guard !componentIndexArray.isEmpty else {
                continue
            }
            let focusableView = FocusableView()
            scrollView.addSubview(focusableView)
            focusableViews.append(focusableView)
            focuseViews.append(focusableView)
            focusableView.frame.origin = CGPoint(x: CGFloat.infinity, y: .infinity)
            for componentIndex in componentIndexArray {
                focusableView.frame.origin.x = min(focusableView.frame.origin.x, components[componentIndex].frame.origin.x)
                focusableView.frame.origin.y = min(focusableView.frame.origin.y,
                                                   components[componentIndex].frame.origin.y)
            }
            for componentIndex in componentIndexArray {
                focusableView.frame.size.width = max(focusableView.bounds.size.width, components[componentIndex].frame.maxX)
                focusableView.frame.size.height = max(focusableView.bounds.size.height,
                                                      components[componentIndex].frame.maxY)
            }
            focusableView.frame.size.width -= focusableView.frame.origin.x
            focusableView.frame.size.height -= focusableView.frame.origin.y
            let buffer = CGSize(width: 0, height: 10)
            focusableView.frame.origin.x -= buffer.width / 2
            focusableView.frame.origin.y -= buffer.height / 2
            focusableView.frame.size.width += buffer.width
            focusableView.frame.size.height += buffer.height
//            focusableView.focus(with: 0.5, borderWidth: 1, borderColor: UIColor.red.cgColor, backgroundColor: .white)
        }
        guard !focuseViews.isEmpty else {
            return
        }
        var maxX: CGFloat = 0
        var minOriginX: CGFloat = CGFloat.infinity
        var maxOriginX: CGFloat = 0
        var minOriginY = CGFloat.infinity
        var maxOriginY: CGFloat = 0
        for focusedView in focuseViews {
//            if focusedView.frame.origin.y < minY {
//                minY = focusedView.frame.origin.y
//                topFocusedView = focusedView
//            }
            maxX = max(maxX, focusedView.frame.maxX)
            minOriginX = min(minOriginX, focusedView.frame.origin.x)
            maxOriginX = max(maxOriginX, focusedView.frame.origin.x)
            minOriginY = min(minOriginY, focusedView.frame.origin.y)
            maxOriginY = max(maxOriginY, focusedView.frame.origin.y)
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            if (self.scrollView.contentOffset.x + self.scrollView.bounds.width) <= maxX && (maxX - self.scrollView.bounds.width) <= minOriginX  {
                self.scrollView.contentOffset.x = (maxX - self.scrollView.bounds.width)
            }
            if minOriginX < self.scrollView.contentOffset.x {
                self.scrollView.contentOffset.x = minOriginX
            }
            self.scrollView.contentOffset.y = minOriginY
        }) { _ in
            for focusView in focuseViews {
                (focusView as? Focusable)?.focus(with: 0.3, borderWidth: 1, borderColor: UIColor.red.cgColor, backgroundColor: .clear)
            }
        }
        fit()
        scrollView.contentSize.width = max(scrollView.contentSize.width, maxOriginX + scrollView.bounds.width)
        scrollView.contentSize.height = max(scrollView.contentSize.height, maxOriginY + scrollView.bounds.height)
    }
    
    func removeAllFocusableViews() {
        focusableViews.forEach { $0.removeFromSuperview() }
    }
    
    func scroll(to component: UIView?) {
        guard let component = component, let components = components, components.contains(component) else {
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.scrollView.contentOffset.y = component.frame.origin.y
            if self.bounds.width <= component.frame.origin.x {
                self.scrollView.contentOffset.x = component.frame.origin.x
            } else {
                self.scrollView.contentOffset.x = 0
            }
        }, completion: nil)
    }
    
    func setNextQuestion() {
        if let question = question, let questions = questions, let questionIndex = questions.firstIndex(of: question) {
            let nextQuestionIndex = (questionIndex + 1)
            self.question = (nextQuestionIndex < questions.count) ? questions[nextQuestionIndex] : nil
        } else {
            self.question = self.questions?.first
        }
    }
    
    func range(of componentView: UIView) -> NSRange? {
        guard let components = components,
            components.contains(componentView) else {
            return nil
        }
        var range = NSRange(location: 0, length: 0)
        for component in components {
            var componentText = ""
            if let templateLabel = (component as? TemplateLabel), let labelText = templateLabel.text {
                componentText = labelText
            } else if let questionTextField = (component as? QuestionTextField), let textFieldText = questionTextField.text
            {
                componentText = textFieldText
            }
            range = NSRange(location: range.location + range.length, length: componentText.count)
            if component == componentView {
                break
            }
        }
        return range
    }
    
    func fit() {
        components?.forEach { component in
            self.scrollView.contentSize = CGSize(
                width: max(self.scrollView.contentSize.width, component.frame.maxX),
                height: max(self.scrollView.contentSize.height, component.frame.maxY)
            )
        }
    }
    
    private func setupViews() {
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
