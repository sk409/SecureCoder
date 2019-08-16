import UIKit

class IFrame: WebElementView {
    
    var webElementContainerView: WebElementContainerView? {
        willSet {
            webElementContainerView?.removeFromSuperview()
        }
        didSet {
            guard let webSimulatorView = webElementContainerView else {
                return
            }
            addSubview(webSimulatorView)
            webSimulatorView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                webSimulatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                webSimulatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                webSimulatorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                webSimulatorView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                ])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        frame.size = CGSize(width: 300, height: 150)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        margin = .zero
        display = .inline
    }
    
}
