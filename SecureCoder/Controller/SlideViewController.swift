import UIKit

class SlideViewController: UIViewController {
    
    static private let slideCollectionViewCellID = "SlideCollectionViewCell"
    static private let lastSlideCollectionViewCellID = "LastSlideCollectionViewCell"
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var slides: [Slide]?
    
    private let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.82, green: 0.92, blue: 0.98, alpha: 1)
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.register(SlideCollectionViewCell.self, forCellWithReuseIdentifier: SlideViewController.slideCollectionViewCellID)
        collectionView.register(LastSlideCollectionViewCell.self, forCellWithReuseIdentifier: SlideViewController.lastSlideCollectionViewCellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let closeButtonSize: CGFloat = 32
        let closeButton = UIButton(type: .custom)
        view.addSubview(closeButton)
        closeButton.alpha = 0.5
        closeButton.layer.cornerRadius = closeButtonSize * 0.5
        closeButton.backgroundColor = .lightGray
        closeButton.setTitle("✖︎", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(handleCloseButton(_:)), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -2).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: closeButtonSize).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: closeButtonSize).isActive = true

        if let slides = slides {
            view.addSubview(pageControl)
            pageControl.pageIndicatorTintColor = .white
            pageControl.currentPageIndicatorTintColor = .black
            pageControl.numberOfPages = slides.count + 1
            pageControl.currentPage = 0
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            pageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            pageControl.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1 / 6).isActive = true
        }
    }
    
    @objc
    private func handleCloseButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}

extension SlideViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeAreaWidth = view.bounds.width - view.safeAreaInsets.left - view.safeAreaInsets.right
        pageControl.currentPage = max(0, Int((scrollView.contentOffset.x + safeAreaWidth / 2) / safeAreaWidth))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = slides?.count else {
            return 0
        }
        return count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let slides = slides else {
            return UICollectionViewCell()
        }
        guard indexPath.item != slides.count else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideViewController.lastSlideCollectionViewCellID, for: indexPath) as? LastSlideCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.closeButton.addTarget(self, action: #selector(handleCloseButton(_:)), for: .touchUpInside)
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideViewController.slideCollectionViewCellID, for: indexPath) as? SlideCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.title = slides[indexPath.item].title
        cell.content = slides[indexPath.item].content
        cell.imageName = slides[indexPath.item].imageName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.safeAreaLayoutGuide.layoutFrame.size
    }
    
}
