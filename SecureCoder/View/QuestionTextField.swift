import UIKit

class QuestionTextField: UITextField {
    
//    weak var editorView: CodeEditorView?
//
    
    let index: Int
    let answer: String
    let language: ProgramingLanguage
    let caret = CaretView()
    var keyboardView: KeyboardView?
    
    private(set) var isActive = false

    init(index: Int, answer: String, language: ProgramingLanguage) {
        self.index = index
        self.answer = answer
        self.language = language
        super.init(frame: .zero)
        //keyboardView.build(with: answer.map { $0 })
    }
//
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveCaret() {
        let size = text!.size(withAttributes: [.font: font!])
        caret.frame.origin.x = size.width
    }
    
    func activate(isActive: Bool, keyboardViewDidShow: (() -> Void)?, keyboardViewDidHide: (() -> Void)?) {
        self.isActive = isActive
        if isActive {
            addSubview(caret)
            caret.backgroundColor = .white
            caret.startAnimation()
            caret.frame = CGRect(x: 0, y: 0, width: 2, height: safeAreaLayoutGuide.layoutFrame.height)
            if let window = UIApplication.shared.keyWindow, let keyboardView = keyboardView {
                window.addSubview(keyboardView)
//                let keyboardViewSize = CGSize(width: window.bounds.size.width * 0.5, height: window.bounds.size.width * 0.25)
                keyboardView.alpha = 0
                keyboardView.frame.origin = CGPoint(
                    x: window.safeAreaLayoutGuide.layoutFrame.maxX - keyboardView.bounds.width,
                    y: window.safeAreaLayoutGuide.layoutFrame.maxY - keyboardView.bounds.height
                )
                UIView.animate(withDuration: 0.5, animations: {
                    self.keyboardView?.alpha = 1
                }) { _ in
                    keyboardViewDidShow?()
                }
            }
        } else {
            caret.removeFromSuperview()
            caret.stopAnimation()
            UIView.animate(withDuration: 0.5, animations: {
                self.keyboardView?.alpha = 0
            }) { _ in
                keyboardViewDidHide?()
            }
        }
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.delegate = self
        borderColorAnimation.toValue = isActive ? UIColor.green.cgColor : UIColor.white.cgColor
        borderColorAnimation.duration = 0.5
        borderColorAnimation.isRemovedOnCompletion = false
        borderColorAnimation.fillMode = .forwards
        layer.add(borderColorAnimation, forKey: "borderColorAnimation")
    }
    
    
//    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        setupSubviews()
//    }
//    
//    func activate(_ active: Bool) {
//        if active {
//            caret.alpha = 1
//            caret.startAnimation()
//            isUserInteractionEnabled = true
//        } else {
//            caret.alpha = 0
//            caret.stopAnimation()
//            isUserInteractionEnabled = false
//        }
//    }
//    
//    private func setupSubviews() {
//        addSubview(caret)
//        caret.frame = CGRect(origin: caret.frame.origin, size: CGSize(width: 1, height: bounds.height))
//        caret.backgroundColor = .turquoiseBlue
//    }
    
}

extension QuestionTextField: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        layer.removeAnimation(forKey: "borderColor")
    }
    
}
