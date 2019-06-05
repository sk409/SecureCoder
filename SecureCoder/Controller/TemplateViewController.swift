import UIKit

class TemplateViewController: UIViewController {
    
    private let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    func setContentViewController(_ contentViewController: UIViewController, options: UIView.AnimationOptions?) {
        children.forEach { $0.removeFromParent() }
        addChild(contentViewController)
        contentViewController.didMove(toParent: self)
        contentViewController.view.frame = containerView.bounds
        if let options = options {
            UIView.transition(with: containerView, duration: 0.5, options: options, animations: {
                self.containerView.addSubview(contentViewController.view)
            })
        } else {
            self.containerView.addSubview(contentViewController.view)
        }
    }
    
    private func setupSubviews() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85)
            ])
    }
    
}
