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
        let toolsView = UIView()
        view.addSubview(toolsView)
        toolsView.backgroundColor = .white
        toolsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolsView.leadingAnchor.constraint(equalTo: containerView.trailingAnchor),
            toolsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            toolsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toolsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        let button = UIButton()
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(handleButton(_:)), for: .touchUpInside)
        let toolsStackView = UIStackView(arrangedSubviews: [button])
        toolsView.addSubview(toolsStackView)
        toolsStackView.axis = .vertical
        toolsStackView.distribution = .fillEqually
        toolsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolsStackView.leadingAnchor.constraint(equalTo: toolsView.safeAreaLayoutGuide.leadingAnchor),
            toolsStackView.trailingAnchor.constraint(equalTo: toolsView.safeAreaLayoutGuide.trailingAnchor),
            toolsStackView.topAnchor.constraint(equalTo: toolsView.safeAreaLayoutGuide.topAnchor),
            toolsStackView.bottomAnchor.constraint(equalTo: toolsView.safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
    @objc
    private func handleButton(_ sender: UIButton) {
        let profileViewController = UIViewController()
        profileViewController.view.backgroundColor = .blue
        setContentViewController(profileViewController, options: .transitionFlipFromLeft)
    }
    
}
