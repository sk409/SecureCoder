import UIKit

class CourseCardCollectionViewCell: UICollectionViewCell {
    
    var course: Course? {
        didSet {
            threatLabelsStackView.arrangedSubviews.forEach { arrangedSubView in
                self.threatLabelsStackView.removeArrangedSubview(arrangedSubView)
                arrangedSubView.removeFromSuperview()
            }
            courseTitleLabel.text = course?.title
            course?.threats.forEach { threat in
                let threatLabel = UILabel()
                self.threatLabelsStackView.addArrangedSubview(threatLabel)
                threatLabel.font = .systemFont(ofSize: 16)
                threatLabel.numberOfLines = 0
                threatLabel.text = "・" + threat
            }
            let threatsCount = course?.threats.count ?? 0
            let threatLabelHeight: CGFloat = 14
            threatLabelsStackView.heightAnchor.constraint(equalToConstant: threatLabelHeight * CGFloat(threatsCount))
        }
    }
    
    let headerView = UIView()
    let courseTitleLabel = UILabel()
    let separatorView = UIView()
    let bodyView = UIView()
    let threatTitleLabel = UILabel()
    let threatLabelsStackView = UIStackView()
    let startButton = CellButton()
    let detailButton = CellButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        addSubview(headerView)
        headerView.addSubview(courseTitleLabel)
        addSubview(separatorView)
        addSubview(bodyView)
        bodyView.addSubview(threatTitleLabel)
        bodyView.addSubview(threatLabelsStackView)
        bodyView.addSubview(detailButton)
        bodyView.addSubview(startButton)
        headerView.backgroundColor = .systemBlue
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            ])
        courseTitleLabel.font = .boldSystemFont(ofSize: 18)
        courseTitleLabel.numberOfLines = 0
        courseTitleLabel.textAlignment = .center
        courseTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            courseTitleLabel.leadingAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.leadingAnchor),
            courseTitleLabel.trailingAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.trailingAnchor),
            courseTitleLabel.centerYAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerYAnchor),
            ])
        separatorView.backgroundColor = .black
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            ])
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            bodyView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
        threatTitleLabel.text = "想定される脅威"
        threatTitleLabel.font = .boldSystemFont(ofSize: 18)
        threatTitleLabel.numberOfLines = 0
        threatTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            threatTitleLabel.leadingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            threatTitleLabel.topAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.topAnchor, constant: 16),
            ])
        threatLabelsStackView.axis = .vertical
        threatLabelsStackView.distribution = .fillEqually
        threatLabelsStackView.spacing = 8
        threatLabelsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            threatLabelsStackView.leadingAnchor.constraint(equalTo: threatTitleLabel.leadingAnchor),
            threatLabelsStackView.trailingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.trailingAnchor),
            threatLabelsStackView.topAnchor.constraint(equalTo: threatTitleLabel.bottomAnchor, constant: 16),
            ])
        detailButton.backgroundColor = .lightGray
        detailButton.setTitle("詳細", for: .normal)
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailButton.leadingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            detailButton.bottomAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            detailButton.widthAnchor.constraint(equalToConstant: 88),
            detailButton.heightAnchor.constraint(equalToConstant: 44),
            ])
        startButton.backgroundColor = .systemBlue
        startButton.setTitle("開始", for: .normal)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.trailingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            startButton.bottomAnchor.constraint(equalTo: detailButton.bottomAnchor),
            startButton.widthAnchor.constraint(equalTo: detailButton.widthAnchor),
            startButton.heightAnchor.constraint(equalTo: detailButton.heightAnchor),
            ])
    }
    
}
