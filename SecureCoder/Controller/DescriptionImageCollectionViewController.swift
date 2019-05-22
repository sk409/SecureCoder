//import UIKit
//class DescriptionImageCollectionViewController: UIViewController {
//    
//    private static let cellID = "DescriptionPageControllerCollectionViewCell"
//    
//    
//    @IBOutlet weak var bottomControlsContainerView: UIView!
//    @IBOutlet weak var prevButton: UIButton!
//    @IBOutlet weak var nextButton: UIButton!
//    @IBOutlet private weak var pageControl: UIPageControl!
//    @IBOutlet weak var collectionView: UICollectionView!
//    
//    private var lesson: Lesson?
//    
//    private var pages = [DescriptionPage]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupPageControl()
//        setupCollectionView()
//        setupBarButton()
//        setupBottomControlButtons()
//    }
//    
//    @IBAction func showPreviousPage(_ sender: Any) {
//        pageControl.currentPage = max(0, pageControl.currentPage - 1)
//        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
//        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        prevButton.isEnabled = (pageControl.currentPage != 0)
//        nextButton.isEnabled = (pageControl.currentPage != (pageControl.numberOfPages - 1))
//    }
//    
//    @IBAction func showNextPage(_ sender: Any) {
//        pageControl.currentPage = min(pageControl.numberOfPages - 1, pageControl.currentPage + 1)
//        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
//        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        prevButton.isEnabled = (pageControl.currentPage != 0)
//        nextButton.isEnabled = (pageControl.currentPage != (pageControl.numberOfPages - 1))
//    }
//    
//    func setLesson(_ lesson: Lesson) {
//        self.lesson = lesson
//        let imageNamesString = DatabaseSession.sync(with: "LoadFileNames.php", parameters: ["directory_path": lesson.relativeDescriptionImageDirectoryURLString], method: .get)
//        guard !imageNamesString.isEmpty else {
//            return
//        }
//        guard let imageNamesArray = imageNamesString.toArray()?.numberingSorted() else {
//            return
//        }
//        let queryObject = URLQueryObject()
//        queryObject.addArray(name: "image_paths[]", values: imageNamesArray.map { lesson.relativeDescriptionImageDirectoryURLString + $0 })
//        let imageDatasString = DatabaseSession.sync(with: "LoadImages.php", query: queryObject, method: .get)
//        guard let imageDatasArray = imageDatasString.toArray() else {
//            return
//        }
//        let images = imageDatasArray.map { imageDataString -> UIImage in
//            guard let imageData = Data(base64Encoded: imageDataString) else {
//                return UIImage()
//            }
//            guard let image = UIImage(data: imageData) else {
//                return UIImage()
//            }
//            return image
//        }
//        pages = images.map { DescriptionPage(image: $0) }
//    }
//    
//    private func setupPageControl() {
//        pageControl.numberOfPages = pages.count
//    }
//    
//    private func setupCollectionView() {
//        collectionView.register(UINib(nibName: "DescriptionImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DescriptionImageCollectionViewController.cellID)
//        
//    }
//    
//    private func setupBarButton() {
//        navigationItem.setRightBarButton(UIBarButtonItem(title: "GO", style: .plain, target: self, action: #selector(transitionToCodeEditorViewController)), animated: false)
//    }
//    
//    private func setupBottomControlButtons() {
//        prevButton.isEnabled = false
//        prevButton.setTitleColor(.turquoiseBlue, for: .normal)
//        prevButton.setTitleColor(.lightGray, for: .disabled)
//        nextButton.setTitleColor(.turquoiseBlue, for: .normal)
//        nextButton.setTitleColor(.lightGray, for: .disabled)
//    }
//    
//    @objc private func transitionToCodeEditorViewController() {
//        guard let lesson = self.lesson else {
//            return
//        }
//        guard let codeEditorViewController = storyboard?.instantiateViewController(withIdentifier: "CodeEditorViewController") as? CodeEditorViewController else {
//            return
//        }
//        codeEditorViewController.setLesson(lesson)
//        show(codeEditorViewController, sender: nil)
//    }
//}
//
//
//extension DescriptionImageCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return pages.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionImageCollectionViewController.cellID, for: indexPath) as? DescriptionImageCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        cell.backgroundColor = .blue
//        cell.setImage(pages[indexPath.row].image)
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard let navigationBarHeight = navigationController?.navigationBar.frame.height else {
//            return CGSize(width: view.frame.width, height: view.frame.height)
//        }
//        let bottomControlsContainerViewHeight = bottomControlsContainerView.frame.height
//        return CGSize(width: view.frame.width, height: view.frame.height - navigationBarHeight - bottomControlsContainerViewHeight)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//}
