import UIKit

class DescriptionView: UIView {
    
    var descriptions = [Description]() {
        didSet {
            containerViews.forEach { $0.removeFromSuperview() }
            containerViews.removeAll(keepingCapacity: true)
            titleLabels.removeAll(keepingCapacity: true)
            contentTextViews.removeAll(keepingCapacity: true)
            separatorViews.removeAll(keepingCapacity: true)
            buttons.removeAll(keepingCapacity: true)
            //
            for subview in subviews {
                guard subview is UIStackView else {
                    continue
                }
                subview.removeFromSuperview()
                break
            }
            //
            let buttonsStackView = UIStackView()
            for index in 0..<descriptions.count {
                let button = UIButton()
                buttons.append(button)
                buttonsStackView.addArrangedSubview(button)
                button.setBackgroundImage(UIImage(named: "circle-light-gray"), for: .normal)
                button.setBackgroundImage(UIImage(named: "circle-green"), for: .selected)
                button.setTitle(String(index + 1), for: .normal)
                button.setTitle(String(index + 1), for: .selected)
                button.addTarget(self, action: #selector(handleSlideButtonTouchUpInsideEvent(_:)), for: .touchUpInside)
                let containerView = UIView()
                scrollView.addSubview(containerView)
                containerViews.append(containerView)
                let titleLabel = UILabel()
                containerView.addSubview(titleLabel)
                titleLabels.append(titleLabel)
                titleLabel.text = descriptions[index].title
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    titleLabel.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
                    titleLabel.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
                    titleLabel.heightAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.heightAnchor, multiplier: 1 / 3),
                    ])
                let separatorView = UIView()
                containerView.addSubview(separatorView)
                separatorViews.append(separatorView)
                separatorView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    separatorView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
                    separatorView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
                    separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                    separatorView.heightAnchor.constraint(equalToConstant: 1),
                    ])
                let contentTextView = UITextView()
                containerView.addSubview(contentTextView)
                contentTextViews.append(contentTextView)
                contentTextView.backgroundColor = .clear
                contentTextView.isEditable = false
                contentTextView.text = descriptions[index].content
                contentTextView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    contentTextView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
                    contentTextView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
                    contentTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                    contentTextView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
                    ])
            }
            let spacing: CGFloat = 10
            addSubview(buttonsStackView)
            buttonsStackView.distribution = .fillEqually
            buttonsStackView.spacing = spacing
            buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                buttonsStackView.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -spacing * 1.618),
                buttonsStackView.centerYAnchor.constraint(equalTo: closeButton.safeAreaLayoutGuide.centerYAnchor),
                buttonsStackView.widthAnchor.constraint(equalTo: buttonsStackView.heightAnchor, multiplier: CGFloat(buttons.count), constant: CGFloat(buttons.count - 1) * spacing),
                buttonsStackView.heightAnchor.constraint(equalTo: closeButton.heightAnchor)
                ])
            selectedDescriptionIndex = 0
            drawSubviews()
        }
    }
    
    var selectedDescriptionIndex = 0 {
        willSet {
            guard selectedDescriptionIndex < buttons.count else {
                return
            }
            buttons[selectedDescriptionIndex].isSelected = false
        }
        didSet {
            guard selectedDescriptionIndex < buttons.count else {
                return
            }
            buttons[selectedDescriptionIndex].isSelected = true
        }
    }
    
    let closeButton = UIButton()
    
    private(set) var buttons = [UIButton]()
    private(set) var titleLabels = [UILabel]()
    private(set) var contentTextViews = [UITextView]()
    private(set) var separatorViews = [UIView]()
    
    private var containerViews = [UIView]()
    private let scrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollToDescription(at index: Int, animate: Bool) {
        let duration: TimeInterval = animate ? 0.5 : 0
        UIView.animate(withDuration: duration) {
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.bounds.width * CGFloat(index), y: 0)
        }
    }
    
    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        addSubview(closeButton)
        closeButton.setBackgroundImage(UIImage(named: "cross-icon"), for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            ])
    }
    
    private func drawSubviews() {
        let safeAreaFrame = safeAreaLayoutGuide.layoutFrame
        scrollView.frame = safeAreaFrame
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(descriptions.count), height: scrollView.bounds.height)
        for (index, containerView) in containerViews.enumerated() {
            containerView.frame = CGRect(x: safeAreaFrame.width * CGFloat(index), y: 0, width: safeAreaFrame.width, height: safeAreaFrame.height)
        }
    }
    
    @objc
    private func handleSlideButtonTouchUpInsideEvent(_ sender: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else {
            return
        }
        selectedDescriptionIndex = buttonIndex
        scrollToDescription(at: buttonIndex, animate: true)
    }
    
}

extension DescriptionView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let buttonIndex = Int((scrollView.contentOffset.x + scrollView.bounds.width * 0.5) / scrollView.bounds.width)
        selectedDescriptionIndex = buttonIndex
    }
    
}
