import UIKit

class CourseSelectionViewController: UIViewController {
    
    private static let cellsSpacing: CGFloat = 32
    private static let cellId = "cellId"
    
    let coursesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        return collectionViewLayout
    }())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(coursesCollectionView)
        coursesCollectionView.dataSource = self
        coursesCollectionView.delegate = self
        coursesCollectionView.backgroundColor = .white
        coursesCollectionView.contentInset = UIEdgeInsets(top: 0, left: CourseSelectionViewController.cellsSpacing, bottom: 0, right: CourseSelectionViewController.cellsSpacing)
        coursesCollectionView.register(CourseCardCollectionViewCell.self, forCellWithReuseIdentifier: CourseSelectionViewController.cellId)
        coursesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coursesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            coursesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            coursesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            coursesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
    }
    
    @objc
    private func handleStartButton(_ sender: CellButton) {
        guard let indexPath = sender.indexPath else {
            return
        }
        let course = Application.shared.courses[indexPath.row]
        let sectionSelectionViewController = SectionSelectionViewController()
        sectionSelectionViewController.course = course
        present(sectionSelectionViewController, animated: true)
    }
    
}

extension CourseSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Application.shared.courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let courseCardCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseSelectionViewController.cellId, for: indexPath) as! CourseCardCollectionViewCell
        courseCardCollectionViewCell.course = Application.shared.courses[indexPath.row]
        courseCardCollectionViewCell.startButton.indexPath = indexPath
        courseCardCollectionViewCell.startButton.addTarget(self, action: #selector(handleStartButton(_:)), for: .touchUpInside)
        courseCardCollectionViewCell.detailButton.indexPath = indexPath
        
        return courseCardCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.4, height: collectionView.bounds.height * 0.8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CourseSelectionViewController.cellsSpacing
    }
    
}
