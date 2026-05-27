//
//  BannerCarouselView.swift
//  POTI-iOS
//
//  Created by mandoo on 5/27/26.
//

import UIKit

import Kingfisher
import SnapKit

final class BannerCarouselView: BaseView {
    
    // MARK: - Properties
    
    private var banners: [BannerModel] = []
    private var lastRecordedPage: Int = 0
    
    // MARK: - UI Components
    
    private let shadowImageView = UIImageView()
    private let shadowLayerView = UIView()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private let pageControl = UIPageControl()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setDelegate()
        register()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .clear
        
        shadowImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            let angle = CGFloat(-4.26 * Double.pi / 180)
            $0.transform = CGAffineTransform(rotationAngle: angle)
        }
        
        shadowLayerView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.2)
        }
        
        collectionView.do {
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
            $0.decelerationRate = .fast
            $0.clipsToBounds = true
            $0.backgroundColor = .clear
        }
        
        pageControl.do {
            $0.currentPage = 0
            $0.numberOfPages = 3
            $0.pageIndicatorTintColor = .gray300
            $0.currentPageIndicatorTintColor = .poti200
            $0.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    override func setUI() {
        addSubviews(shadowImageView, collectionView, pageControl)
        shadowImageView.addSubview(shadowLayerView)
    }
    
    override func setLayout() {
        shadowImageView.snp.makeConstraints {
            $0.edges.equalTo(collectionView)
        }
        
        shadowLayerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.height.equalTo(196)
        }
        
        pageControl.snp.makeConstraints {
            $0.bottom.equalTo(collectionView)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Private Methods
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func register() {
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let width = UIScreen.main.bounds.width - 44
        layout.itemSize = CGSize(width: width, height: 196)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        return layout
    }
    
    private func updateBackground(page: Int) {
        guard page < banners.count else { return }
        let urlString = banners[page].imageUrl
        shadowImageView.kf.setImage(with: URL(string: urlString))
    }
    
    // MARK: - Public Method
    
    func configure(banners: [BannerModel]) {
        self.banners = banners
        pageControl.numberOfPages = banners.count
        collectionView.reloadData()
        
        if let firstBanner = banners.first {
            shadowImageView.kf.setImage(with: URL(string: firstBanner.imageUrl))
        }
    }
}

// MARK: - UICollectionViewDataSource

extension BannerCarouselView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as! BannerCell
        cell.configure(banner: banners[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension BannerCarouselView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        guard width > 0 else { return }
        
        let page = Int(floor((scrollView.contentOffset.x - width / 2) / width) + 1)
        
        if page >= 0 && page < banners.count && page != lastRecordedPage {
            lastRecordedPage = page
            pageControl.currentPage = page
            updateBackground(page: page)
        }
    }
}
