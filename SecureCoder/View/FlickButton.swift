import UIKit

class FlickButton: UIButton {
    
    var delegate: FlickButtonDelegate?
    
    
    var centerViewActiveColor: UIColor?
    var centerViewInactiveColor: UIColor?
    var topViewActiveColor: UIColor?
    var topViewInactiveColor: UIColor?
    var bottomViewActiveColor: UIColor?
    var bottomViewInactiveColor: UIColor?
    var leftViewActiveColor: UIColor?
    var leftViewInactiveColor: UIColor?
    var rightViewActiveColor: UIColor?
    var rightViewInactiveColor: UIColor?
    
    var activeColor: UIColor? {
        didSet {
            centerViewActiveColor = activeColor
            topViewActiveColor = activeColor
            bottomViewActiveColor = activeColor
            leftViewActiveColor = activeColor
            rightViewActiveColor = activeColor
        }
    }
    var inactiveColor: UIColor? {
        didSet {
            centerViewInactiveColor = inactiveColor
            topViewInactiveColor = inactiveColor
            bottomViewInactiveColor = inactiveColor
            leftViewInactiveColor = inactiveColor
            rightViewInactiveColor = inactiveColor
        }
    }
    
    var centerView: UIView? {
        willSet {
            guard let centerView = centerView else {
                return
            }
            centerView.removeFromSuperview()
        }
        didSet {
            guard let centerView = centerView else {
                return
            }
            addSubview(centerView)
            centerView.isHidden = true
            centerView.translatesAutoresizingMaskIntoConstraints = false
            centerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            centerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            centerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            centerView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        }
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
            addSubview(topView)
            topView.isHidden = true
            topView.translatesAutoresizingMaskIntoConstraints = false
            topView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            topView.bottomAnchor.constraint(equalTo: topAnchor).isActive = true
            topView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            topView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
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
            addSubview(bottomView)
            bottomView.isHidden = true
            bottomView.translatesAutoresizingMaskIntoConstraints = false
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            bottomView.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
            bottomView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            bottomView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
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
            addSubview(leftView)
            leftView.isHidden = true
            leftView.translatesAutoresizingMaskIntoConstraints = false
            leftView.trailingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            leftView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            leftView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            leftView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
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
            addSubview(rightView)
            rightView.isHidden = true
            rightView.translatesAutoresizingMaskIntoConstraints = false
            rightView.leadingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            rightView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            rightView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            rightView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        }
    }
    
    private(set) var activeView: UIView?
    
    private var isBeingShowedPopUpViews = false
    
    let longPressGestureRecognizer = UILongPressGestureRecognizer()
    let panGestureRecognizer = UIPanGestureRecognizer()
    let upSwipeGestureRecognizer = UISwipeGestureRecognizer()
    let downSwipeGestureRecognizer = UISwipeGestureRecognizer()
    let leftSwipeGestureRecognizer = UISwipeGestureRecognizer()
    let rightSwipeGestureRecognizer = UISwipeGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGestureRecognizers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.minimumPressDuration = 0.2
        longPressGestureRecognizer.addTarget(self, action: #selector(handleLongPressGesture(_:)))
        addGestureRecognizer(longPressGestureRecognizer)
        panGestureRecognizer.delegate = self
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGestureRecognizer)
        upSwipeGestureRecognizer.delegate = self
        upSwipeGestureRecognizer.direction = .up
        upSwipeGestureRecognizer.addTarget(self, action: #selector(handleSwipeGesture(_:)))
        addGestureRecognizer(upSwipeGestureRecognizer)
        downSwipeGestureRecognizer.delegate = self
        downSwipeGestureRecognizer.direction = .down
        downSwipeGestureRecognizer.addTarget(self, action: #selector(handleSwipeGesture(_:)))
        addGestureRecognizer(downSwipeGestureRecognizer)
        leftSwipeGestureRecognizer.delegate = self
        leftSwipeGestureRecognizer.direction = .left
        leftSwipeGestureRecognizer.addTarget(self, action: #selector(handleSwipeGesture(_:)))
        rightSwipeGestureRecognizer.delegate = self
        rightSwipeGestureRecognizer.direction = .right
        rightSwipeGestureRecognizer.addTarget(self, action: #selector(handleSwipeGesture(_:)))
        addGestureRecognizer(rightSwipeGestureRecognizer)
    }
    
    @objc
    private func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            handleLongPressGestureBegan(sender)
        } else if sender.state == .ended {
            handleLongPressGestureEnded(sender)
        }
    }
    
    @objc
    private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard isBeingShowedPopUpViews else {
            return
        }
        activeView = nil
        let location = sender.location(in: self)
        if location.x < 0 && (0 <= location.y && location.y <= bounds.height || abs(location.y) <= abs(location.x)) {
            activeView = leftView
        } else if bounds.width < location.x && (0 <= location.y && location.y <= bounds.height || abs(location.y) <= abs(location.x)) {
            activeView = rightView
        } else if location.y < 0 && (0 <= location.x && location.x <= bounds.height || abs(location.x) <= abs(location.y)) {
            activeView = topView
        } else if bounds.height < location.y && (0 <= location.x && location.x <= bounds.height || abs(location.x) <= abs(location.y)) {
            activeView = bottomView
        } else {
            activeView = centerView
        }
        let popUpViews = [centerView, topView, bottomView, leftView, rightView]
        let activeBackgroundColors = [centerViewActiveColor, topViewActiveColor, bottomViewActiveColor, leftViewActiveColor, rightViewActiveColor]
        let inactiveBackgroundColors = [centerViewInactiveColor, topViewInactiveColor, bottomViewInactiveColor, leftViewInactiveColor, rightViewInactiveColor]
        for (index, popUpView) in popUpViews.enumerated() {
            guard let popUpView = popUpView else {
                continue
            }
            popUpView.backgroundColor = (popUpView == activeView) ? activeBackgroundColors[index] : inactiveBackgroundColors[index]
        }
//        if isBeingShowedPopUpViews {
//            activeView = nil
//            let location = sender.location(in: self)
//            if location.x < 0 && (0 <= location.y && location.y <= bounds.height || abs(location.y) <= abs(location.x)) {
//                activeView = leftView
//            } else if bounds.width < location.x && (0 <= location.y && location.y <= bounds.height || abs(location.y) <= abs(location.x)) {
//                activeView = rightView
//            } else if location.y < 0 && (0 <= location.x && location.x <= bounds.height || abs(location.x) <= abs(location.y)) {
//                activeView = topView
//            } else if bounds.height < location.y && (0 <= location.x && location.x <= bounds.height || abs(location.x) <= abs(location.y)) {
//                activeView = bottomView
//            } else {
//                activeView = centerView
//            }
//            let popUpViews = [centerView, topView, bottomView, leftView, rightView]
//            let activeBackgroundColors = [centerViewActiveColor, topViewActiveColor, bottomViewActiveColor, leftViewActiveColor, rightViewActiveColor]
//            let inactiveBackgroundColors = [centerViewInactiveColor, topViewInactiveColor, bottomViewInactiveColor, leftViewInactiveColor, rightViewInactiveColor]
//            for (index, popUpView) in popUpViews.enumerated() {
//                guard let popUpView = popUpView else {
//                    continue
//                }
//                popUpView.backgroundColor = (popUpView == activeView) ? activeBackgroundColors[index] : inactiveBackgroundColors[index]
//            }
//        } else {
//            guard sender.state == .ended else {
//                return
//            }
//            guard let delegate = delegate else {
//                return
//            }
//            delegate.flickButtonWillFlick(self)
//            let velocity = sender.velocity(in: self)
//            var selectedView: UIView?
//            if velocity.x <= 0 && abs(velocity.y) <= abs(velocity.x) {
//                selectedView = leftView
//            } else if 0 <= velocity.x && abs(velocity.y) <= abs(velocity.x) {
//                selectedView = rightView
//            } else if velocity.y <= 0 && abs(velocity.x) <= abs(velocity.y) {
//                selectedView = topView
//            } else if 0 <= velocity.y && abs(velocity.x) <= abs(velocity.y) {
//                selectedView = bottomView
//            }
//            delegate.flickButton(self, didFlick: selectedView)
//        }
    }
    
    @objc
    private func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }
        guard let delegate = delegate else {
            return
        }
        delegate.flickButtonWillFlick(self)
        var selectedView: UIView?
        switch sender.direction {
        case .up:
            selectedView = topView
        case .down:
            selectedView = bottomView
        case .left:
            selectedView = leftView
        case .right:
            selectedView = rightView
        default:
            selectedView = centerView
        }
        delegate.flickButton(self, didFlick: selectedView)
    }
    
    private func handleLongPressGestureBegan(_ sender: UILongPressGestureRecognizer) {
        let popUpViews = [centerView, topView, bottomView, leftView, rightView]
        if let delegate = delegate {
            delegate.flickButtonPopUpViewsWillShow(self)
        }
        for popUpView in popUpViews {
            guard let popUpView = popUpView else {
                continue
            }
            popUpView.isHidden = false
        }
        if let delegate = delegate {
            delegate.flickButtonPopUpViewsDidShow(self)
        }
        centerView?.backgroundColor = centerViewActiveColor
        topView?.backgroundColor = topViewInactiveColor
        bottomView?.backgroundColor = bottomViewInactiveColor
        leftView?.backgroundColor = leftViewInactiveColor
        rightView?.backgroundColor = rightViewInactiveColor
        activeView = centerView
        isBeingShowedPopUpViews = true
        if let gestureRecognizers = gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                guard gestureRecognizer is UISwipeGestureRecognizer else {
                    continue
                }
                removeGestureRecognizer(gestureRecognizer)
            }
        }
    }
    
    private func handleLongPressGestureEnded(_ sender: UILongPressGestureRecognizer) {
        let popUpViews = [centerView, topView, bottomView, leftView, rightView]
        let inactiveBackgroundColors = [centerViewInactiveColor, topViewInactiveColor, bottomViewInactiveColor, leftViewInactiveColor, rightViewInactiveColor]
        if let delegate = delegate {
            delegate.flickButton(self, popUpViewsWillHide: activeView)
        }
        for (index, popUpView) in popUpViews.enumerated() {
            guard let popUpView = popUpView else {
                continue
            }
            popUpView.isHidden = true
            popUpView.backgroundColor = inactiveBackgroundColors[index]
        }
        if let delegate = delegate {
            delegate.flickButton(self, popUpViewsDidHide: activeView)
        }
        activeView = nil
        isBeingShowedPopUpViews = false
        if let gestureRecognizers = gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                guard gestureRecognizer is UISwipeGestureRecognizer else {
                    continue
                }
                addGestureRecognizer(gestureRecognizer)
            }
        }
    }
    
}

extension FlickButton: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == longPressGestureRecognizer && otherGestureRecognizer == panGestureRecognizer) ||
           (gestureRecognizer == panGestureRecognizer && otherGestureRecognizer == panGestureRecognizer)
        {
            return true
        }
        if gestureRecognizer == upSwipeGestureRecognizer {
            return true
        }
        if gestureRecognizer == leftSwipeGestureRecognizer {
            return true
        }
        if otherGestureRecognizer == leftSwipeGestureRecognizer {
            return true
        }
        return false
    }
    
}
