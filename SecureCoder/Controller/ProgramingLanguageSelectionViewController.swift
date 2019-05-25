import UIKit

class ProgramingLanguageSelectionViewController: UIViewController {
    
    private static let cellID = "cellID"
    
    private let programingLanguages = ["HTML & CSS", "JavaScript", "PHP"]
    private let descriptions = ["Webページの\n見た目を作る言語", "フロントエンドからバックエンドまで多彩な可能性を秘めた人気の言語", "HTML&CSSと相性が良いサーバサイド言語"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
    }
    
    private func setupSubviews() {
        let titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.text = "学べる言語"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 64)
            ])
        let separator = UIView()
        view.addSubview(separator)
        separator.backgroundColor = .black
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            separator.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
            ])
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(ProgramingLanguageCollectionViewCell.self, forCellWithReuseIdentifier: ProgramingLanguageSelectionViewController.cellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: separator.safeAreaLayoutGuide.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
}

extension ProgramingLanguageSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return programingLanguages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgramingLanguageSelectionViewController.cellID, for: indexPath) as? ProgramingLanguageCollectionViewCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ProgramingLanguageSelectionViewController.cellID, for: indexPath)
        }
        cell.headerColor = .green
        cell.title = programingLanguages[indexPath.item]
        cell.subtitle = descriptions[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.safeAreaLayoutGuide.layoutFrame.size.width
        let height: CGFloat = 400
        return CGSize(width: width, height: height)
    }
    
}
