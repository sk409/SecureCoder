import UIKit

class LastSlideCollectionViewCell: UICollectionViewCell {
    
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
        let title = UILabel()
        title.text = "これでスライドは終了です。"
        title.textColor = .black
        title.textAlignment = .center
        title.font = .boldSystemFont(ofSize: 18)
        let content = UILabel()
        content.text = "演習に進みましょう!"
        content.textColor = .black
        content.textAlignment = .center
        content.font = .boldSystemFont(ofSize: 18)
        let headView = UIStackView(arrangedSubviews: [title, content])
        addSubview(headView)
        headView.distribution = .fillEqually
        headView.axis = .vertical
        headView.translatesAutoresizingMaskIntoConstraints = false
        headView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        headView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        headView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        headView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 1 / 3).isActive = true
        let footTopView = UIView()
        let closeButtonSize = CGSize(width: 150, height: 64)
        footTopView.addSubview(closeButton)
        closeButton.backgroundColor = .appleGreen
        closeButton.setTitle("演習に進む", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.layer.cornerRadius = closeButtonSize.height * 0.25
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.centerXAnchor.constraint(equalTo: footTopView.centerXAnchor).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: footTopView.centerYAnchor).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: closeButtonSize.width).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: closeButtonSize.height).isActive = true
        let footBottomView = UIView()
        let footView = UIStackView(arrangedSubviews: [footTopView, footBottomView])
        addSubview(footView)
        footView.distribution = .fillEqually
        footView.axis = .vertical
        footView.translatesAutoresizingMaskIntoConstraints = false
        footView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        footView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        footView.topAnchor.constraint(equalTo: headView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        footView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
}
