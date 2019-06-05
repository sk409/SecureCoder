import UIKit

class CoursesViewController: UIViewController {
    
    private(set) var cardViews = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSubviews()
    }
    
    private func setupSubviews() {
        let titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.text = "学べる言語"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            ])
        let cards = [
            CourseCard(
                course: Application.course(.html),
                title: "HTML & CSS",
                content: "Webページの\n見た目を作る言語"
            ),
            CourseCard(
                course: Application.course(.javaScript),
                title: "JavaScript",
                content: "多彩な可能性を秘めたスクリプト言語"
            ),
            CourseCard(
                course: Application.course(.php),
                title: "PHP",
                content: "HTMLと相性が良いサーバサイド言語"
            ),
        ]
        for card in cards {
            let cardView = CourseCardView()
            cardView.course = card.course
            cardView.title = card.title
            cardView.content = card.content
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProgramingLanguageCardViewTapEvent(_:))))
            cardViews.append(cardView)
        }
        let cardWidth: CGFloat = view.safeAreaLayoutGuide.layoutFrame.size.width / 4.5
        let cardHeight: CGFloat = cardWidth * 1.618
        let spacing: CGFloat = 32
        let stackViewWidth = cardWidth * CGFloat(cardViews.count) + spacing * CGFloat(cardViews.count - 1)
        let stackView = UIStackView(arrangedSubviews: cardViews)
        view.addSubview(stackView)
        stackView.spacing = 32
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.widthAnchor.constraint(equalToConstant: stackViewWidth),
            stackView.heightAnchor.constraint(equalToConstant: cardHeight)
            ])
    }
    
    @objc
    private func handleProgramingLanguageCardViewTapEvent(_ sender: UITapGestureRecognizer) {
        guard let cardView = sender.view as? CourseCardView else {
            return
        }
        let sectionSelectionViewController = SectionsViewController()
        sectionSelectionViewController.course = cardView.course
        (parent as? TemplateViewController)?.setContentViewController(sectionSelectionViewController, options: .transitionCurlDown)
    }
    
}
//
//extension ProgramingLanguageSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return programingLanguages.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgramingLanguageSelectionViewController.cellID, for: indexPath) as? ProgramingLanguageCollectionViewCell else {
//            return collectionView.dequeueReusableCell(withReuseIdentifier: ProgramingLanguageSelectionViewController.cellID, for: indexPath)
//        }
//        cell.headerColor = .green
//        cell.title = programingLanguages[indexPath.item]
//        cell.subtitle = descriptions[indexPath.item]
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.safeAreaLayoutGuide.layoutFrame.size.width
//        let height: CGFloat = 400
//        return CGSize(width: width, height: height)
//    }
//
//}
