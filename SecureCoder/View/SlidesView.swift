import UIKit

class SlidesView: UIView {
    
    static private let slideCollectionViewCellID = "SlideCollectionViewCell"
    static private let lastSlideCollectionViewCellID = "LastSlideCollectionViewCell"
    
    var slides: [Slide]? {
        didSet {
            pageControl.numberOfPages = (slides?.count ?? 0) + 1
        }
    }
    var hideFunction: (() -> Void)?
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        return collectionViewLayout
    }())
    let closeButton = UIButton(type: .custom)
    let pageControl = UIPageControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = UIColor(red: 0.82, green: 0.92, blue: 0.98, alpha: 1)
        addSubview(collectionView)
        addSubview(closeButton)
        addSubview(pageControl)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.register(SlideCollectionViewCell.self, forCellWithReuseIdentifier: SlidesView.slideCollectionViewCellID)
        collectionView.register(LastSlideCollectionViewCell.self, forCellWithReuseIdentifier: SlidesView.lastSlideCollectionViewCellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
        closeButton.alpha = 0.5
        closeButton.setBackgroundImage(UIImage(named: "cross-icon"), for: .normal)
        closeButton.addTarget(self, action: #selector(handleCloseButton(_:)), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            ])
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            pageControl.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 1 / 6),
            ])
    }
    
    @objc
    private func handleCloseButton(_ sender: UIButton) {
        hideFunction?()
    }
    
}

extension SlidesView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeAreaWidth = bounds.width - safeAreaInsets.left - safeAreaInsets.right
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlidesView.lastSlideCollectionViewCellID, for: indexPath) as? LastSlideCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.closeButton.addTarget(self, action: #selector(handleCloseButton(_:)), for: .touchUpInside)
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlidesView.slideCollectionViewCellID, for: indexPath) as? SlideCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.title = slides[indexPath.item].title
        cell.content = slides[indexPath.item].content
        cell.imageName = slides[indexPath.item].imageName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return safeAreaLayoutGuide.layoutFrame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
