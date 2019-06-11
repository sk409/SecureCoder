import UIKit

class FileTableViewCell: UITableViewCell {
    
    let iconImageView = UIImageView()
    let fileLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(iconImageView)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            iconImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            ])
        addSubview(fileLabel)
        fileLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fileLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            fileLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            fileLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            fileLabel.heightAnchor.constraint(equalTo: iconImageView.heightAnchor),
            ])
    }
    
}
