import UIKit

class DescriptionView: UIView {
    
    let titleLabel = UILabel()
    let contentTextView = UITextView()
    let closeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        let headView = UIView()
        addSubview(headView)
        headView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            headView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            headView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 1 / 3),
            ])
        headView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.bottomAnchor),
            ])
        headView.addSubview(closeButton)
        closeButton.setBackgroundImage(UIImage(named: "cross-icon"), for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            closeButton.centerYAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.centerYAnchor),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            closeButton.heightAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            ])
        let bodyView = UIView()
        addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: headView.bottomAnchor),
            bodyView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 1 / 3),
            ])
        bodyView.addSubview(contentTextView)
        contentTextView.isEditable = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentTextView.leadingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.trailingAnchor),
            contentTextView.topAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.topAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
}
