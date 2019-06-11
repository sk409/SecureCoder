import UIKit

class TabView: UIView {
    
    var activeTabIndex: Int? {
        didSet {
            guard let activeTabIndex = activeTabIndex else {
                return
            }
            guard activeTabIndex < headViews.count else {
                return
            }
            bodyViewContainer.subviews.forEach { $0.removeFromSuperview() }
            let bodyView = bodyViews[activeTabIndex]
            bodyViewContainer.addSubview(bodyView)
            bodyView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bodyView.leadingAnchor.constraint(equalTo: bodyViewContainer.leadingAnchor),
                bodyView.trailingAnchor.constraint(equalTo: bodyViewContainer.trailingAnchor),
                bodyView.topAnchor.constraint(equalTo: bodyViewContainer.topAnchor),
                bodyView.bottomAnchor.constraint(equalTo: bodyViewContainer.bottomAnchor),
                ])
        }
    }
    
    let headViewsContainer = UIStackView()
    let bodyViewContainer = UIView()
    
    private(set) var headViews = [UIView]()
    private(set) var bodyViews = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    func append(headView: UIView, bodyView: UIView) {
        headView.isUserInteractionEnabled = true
        headView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHeadViewTapGesture(_:))))
        headViews.append(headView)
        headViewsContainer.addArrangedSubview(headView)
        bodyViews.append(bodyView)
    }
    
    private func setupSubviews() {
        let folderButton = UIButton()
        addSubview(folderButton)
        addSubview(headViewsContainer)
        addSubview(bodyViewContainer)
        headViewsContainer.axis = .horizontal
        headViewsContainer.distribution = .fillEqually
        headViewsContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headViewsContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            headViewsContainer.trailingAnchor.constraint(equalTo: folderButton.leadingAnchor),
            headViewsContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headViewsContainer.heightAnchor.constraint(equalToConstant: 44),
            ])
        folderButton.backgroundColor = .yellow
        folderButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            folderButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            folderButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            folderButton.widthAnchor.constraint(equalTo: headViewsContainer.heightAnchor),
            folderButton.heightAnchor.constraint(equalTo: folderButton.widthAnchor),
            ])
        bodyViewContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyViewContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bodyViewContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            bodyViewContainer.topAnchor.constraint(equalTo: headViewsContainer.bottomAnchor),
            bodyViewContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
    @objc
    private func handleHeadViewTapGesture(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view else {
            return
        }
        for (index, headView) in headViews.enumerated() {
            guard headView == selectedView else {
                continue
            }
            activeTabIndex = index
            break
        }
    }
    
}
