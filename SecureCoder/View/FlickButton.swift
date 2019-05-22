import UIKit

protocol FlickButtonDelegate {
    
    func flickButton(_ flickButton: FlickButton, componentsWillAppear: [FlickButton.Position: UIView])
    func flickButton(_ flickButton: FlickButton, componentsDidAppear: [FlickButton.Position: UIView])
    func flickButton(_ flickButton: FlickButton, didFlick view: UIView)
    func flickButton(_ flickButton: FlickButton, componentsWillDisappear: [FlickButton.Position: UIView])
    func flickButton(_ flickButton: FlickButton, componentsDidDisappear: [FlickButton.Position: UIView])
    
}

extension FlickButtonDelegate {
    func flickButton(_ flickButton: FlickButton, componentsWillAppear: [FlickButton.Position: UIView]) {}
    func flickButton(_ flickButton: FlickButton, componentsDidAppear: [FlickButton.Position: UIView]) {}
    func flickButton(_ flickButton: FlickButton, didFlick view: UIView) {}
    func flickButton(_ flickButton: FlickButton, componentsWillDisappear: [FlickButton.Position: UIView]) {}
    func flickButton(_ flickButton: FlickButton, componentsDidDisappear: [FlickButton.Position: UIView]) {}
}

class FlickButton: UIButton {
    
    enum Position {
        case top
        case bottom
        case left
        case right
    }
    
    var topView: UIView? {
        willSet {
            guard let topView = topView else {
                return
            }
            topView.removeFromSuperview()
        }
        didSet {
            guard let topView = topView else {
                return
            }
            componentViews[.top] = topView
        }
    }
    
    var bottomView: UIView? {
        willSet {
            guard let bottomView = bottomView else {
                return
            }
            bottomView.removeFromSuperview()
        }
        didSet {
            guard let bottomView = bottomView else {
                return
            }
            componentViews[.bottom] = bottomView
        }
    }
    
    var leftView: UIView? {
        willSet {
            guard let leftView = leftView else {
                return
            }
            leftView.removeFromSuperview()
        }
        didSet {
            guard let leftView = leftView else {
                return
            }
            componentViews[.left] = leftView
        }
    }
    
    var rightView: UIView? {
        willSet {
            guard let rightView = rightView else {
                return
            }
            rightView.removeFromSuperview()
        }
        didSet {
            guard let rightView = rightView else {
                return
            }
            componentViews[.right] = rightView
        }
    }
    
    var defaultColor: UIColor? {
        didSet {
            backgroundColor = defaultColor
        }
    }
    
    var activeColor: UIColor?
    var delegate: FlickButtonDelegate?
    var componentMargins = UIEdgeInsets.zero
    
    private(set) var componentViews = [Position: UIView]()
    
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGestureRecognizers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.minimumPressDuration = 0.25
        addGestureRecognizer(longPressGestureRecognizer)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
    }
    
    private func addComponentViews() {
        delegate?.flickButton(self, componentsWillAppear: componentViews)
        for (location, componentView) in componentViews {
            componentView.backgroundColor = defaultColor
            addSubview(componentView)
            let safeAreaFrame = safeAreaLayoutGuide.layoutFrame
            switch location {
            case .top:
                componentView.frame = CGRect(
                    x: safeAreaFrame.origin.x,
                    y: safeAreaFrame.origin.y - safeAreaFrame.height - componentMargins.top,
                    width: safeAreaFrame.width,
                    height: safeAreaFrame.height
                )
            case .bottom:
                componentView.frame = CGRect(
                    x: safeAreaFrame.origin.x,
                    y: safeAreaFrame.origin.y + safeAreaFrame.height + componentMargins.bottom,
                    width: safeAreaFrame.width,
                    height: safeAreaFrame.height
                )
            case .left:
                componentView.frame = CGRect(
                    x: safeAreaFrame.origin.x - safeAreaFrame.width - componentMargins.left,
                    y: safeAreaFrame.origin.y,
                    width: safeAreaFrame.width,
                    height: safeAreaFrame.height
                )
            case .right:
                componentView.frame = CGRect(
                    x: safeAreaFrame.origin.x + safeAreaFrame.width + componentMargins.right,
                    y: safeAreaFrame.origin.y,
                    width: safeAreaFrame.width,
                    height: safeAreaFrame.height
                )
            }
        }
        delegate?.flickButton(self, componentsDidAppear: componentViews)
    }
    
    private func removeComponentViews() {
        delegate?.flickButton(self, componentsWillDisappear: componentViews)
        for componentView in componentViews.values {
            componentView.backgroundColor = defaultColor
            componentView.removeFromSuperview()
        }
        delegate?.flickButton(self, componentsDidDisappear: componentViews)
    }
    
    private func handlePanGestureChanged(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self)
        let activatedView = activeView(at: location)
        ([self] + componentViews.values).forEach { componentView in
            componentView.backgroundColor = (activatedView == componentView) ? activeColor : defaultColor
        }
    }
    
    private func activeView(at location: CGPoint) -> UIView {
        let width = safeAreaLayoutGuide.layoutFrame.width
        let height = safeAreaLayoutGuide.layoutFrame.height
        if let topView = topView, location.y < 0 && ((0 <= location.x && location.x <= width) || abs(location.x) <= abs(location.y)) {
            return topView
        } else if let bottomView = bottomView, height < location.y && ((0 <= location.x && location.x <= width) || abs(location.x) <= abs(location.y)) {
            return bottomView
        } else if let leftView = leftView, location.x < 0 && ((0 <= location.y && location.y <= height) || abs(location.y) <= abs(location.x)) {
            return leftView
        } else if let rightView = rightView, width < location.x && ((0 <= location.y && location.y <= height) || abs(location.y) <= abs(location.x)) {
            return rightView
        }
        return self
    }
    
    private func handlePanGestureEnded(_ sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: self)
        let activatedView = activeView(at: location)
        delegate?.flickButton(self, didFlick: activatedView)
        
        backgroundColor = defaultColor
        removeComponentViews()
        if activatedView != self {
            addSubview(activatedView)
            activatedView.backgroundColor = activeColor
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(handleRemovingActivatedViewEvent(_:)), userInfo: activatedView, repeats: false)
        }
    }
    
    @objc
    private func handleRemovingActivatedViewEvent(_ timer: Timer) {
        guard let activatedView = timer.userInfo as? UIView else {
            return
        }
        activatedView.removeFromSuperview()
    }
    
    @objc
    private func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            addComponentViews()
        } else if sender.state == .ended {
            removeComponentViews()
        }
    }
    
    @objc
    private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            backgroundColor = activeColor
            addComponentViews()
        } else if sender.state == .changed {
            handlePanGestureChanged(sender)
        } else if sender.state == .ended {
            handlePanGestureEnded(sender)
        }
    }
    
}

extension FlickButton: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
