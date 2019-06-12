import UIKit

class CoursesViewController: UIViewController {
    
    private static let cellID = "CELL"
    
    private let datas = [
        CourseCard(
            course: Application.shared.course(.html)!,
            title: "HTML & CSS",
            content1: "Webページの見た目を作る言語",
            content2: "HTMLとCSSだけでもおしゃれなWebページを作ることができます"
        ),
        CourseCard(
            course: Application.shared.course(.javaScript)!,
            title: "JavaScript",
            content1: "多彩な可能性を秘めたスクリプト言語",
            content2: "Webページに動きをつけることができます"
        ),
        CourseCard(
            course: Application.shared.course(.php)!,
            title: "PHP",
            content1: "HTMLと相性が良いサーバサイド言語",
            content2: "動的なWebページを作ることができます"
        ),
    ]
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        let profileView = UIView()
        view.addSubview(profileView)
        profileView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            profileView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.25),
            ])
        let humanIconImageView = UIImageView(image: UIImage(named: "human-icon"))
        profileView.addSubview(humanIconImageView)
        humanIconImageView.contentMode = .scaleAspectFit
        humanIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            humanIconImageView.centerXAnchor.constraint(equalTo: profileView.safeAreaLayoutGuide.centerXAnchor),
            humanIconImageView.topAnchor.constraint(equalTo: profileView.safeAreaLayoutGuide.topAnchor, constant: 16),
            humanIconImageView.widthAnchor.constraint(equalToConstant: 64),
            humanIconImageView.heightAnchor.constraint(equalTo: humanIconImageView.widthAnchor),
            ])
        let nameLabel = UILabel()
        profileView.addSubview(nameLabel)
        nameLabel.text = "NAME"
        nameLabel.textColor = .black
        nameLabel.font = .boldSystemFont(ofSize: 22)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: profileView.safeAreaLayoutGuide.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: humanIconImageView.bottomAnchor, constant: 16),
            ])
        let calendarIconImageView = UIImageView(image: UIImage(named: "calendar-icon"))
        calendarIconImageView.contentMode = .scaleAspectFit
        let toolsStackView = UIStackView(arrangedSubviews: [calendarIconImageView])
        profileView.addSubview(toolsStackView)
        toolsStackView.axis = .vertical
        toolsStackView.distribution = .fillEqually
        toolsStackView.spacing = 8
        toolsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolsStackView.centerXAnchor.constraint(equalTo: profileView.safeAreaLayoutGuide.centerXAnchor),
            toolsStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            toolsStackView.widthAnchor.constraint(equalToConstant: 44),
            toolsStackView.widthAnchor.constraint(equalToConstant: 44),
            ])
        let separator = UIView()
        view.addSubview(separator)
        separator.backgroundColor = UIColor(white: 0.8, alpha: 1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: profileView.trailingAnchor),
            separator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            separator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            separator.widthAnchor.constraint(equalToConstant: 1),
            ])
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(CourseCardCollectionViewCell.self, forCellWithReuseIdentifier: CoursesViewController.cellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: separator.trailingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
}


extension CoursesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoursesViewController.cellID, for: indexPath) as? CourseCardCollectionViewCell else {
            return UICollectionViewCell()
        }
        let data = datas[indexPath.row]
        cell.course = data.course
        cell.title = data.title
        cell.content1 = data.content1
        cell.content2 = data.content2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.8, height: view.bounds.height * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let cellSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath())
        return (view.bounds.width - cellSize.width) * 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let course = datas[indexPath.row].course
        let sectionsViewController = SectionsViewController()
        sectionsViewController.course = course
        present(sectionsViewController, animated: true)
    }
    
}
