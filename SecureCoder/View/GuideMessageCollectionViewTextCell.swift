import UIKit

class GuideMessageCollectionViewTextCell: UICollectionViewCell {
    
    private let goButton = UIButton()
    
    let textView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(textView)
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
//        addSubview(goButton)
//        goButton.setTitle("問題を解く", for: .normal)
//        goButton.setTitleColor(.white, for: .normal)
//        goButton.backgroundColor = .appleGreen
//        goButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            goButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
//            goButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
//            goButton.widthAnchor.constraint(equalToConstant: 100),
//            goButton.heightAnchor.constraint(equalTo: goButton.widthAnchor, multiplier: 0.5),
//            ])
    }
    
}
