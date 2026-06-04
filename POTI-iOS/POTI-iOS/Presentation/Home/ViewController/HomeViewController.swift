//
//  HomeViewController.swift
//  POTI-iOS
//
//  Created by mandoo on 1/13/26.
//

import UIKit

import Combine

enum HomeSection: Int, CaseIterable {
    case banner = 0
    case myGroup
    case otherGroup
    
    func getHeaderTitle(nickname: String) -> String {
        switch self {
        case .banner:
            return ""
        case .myGroup:
            return "\(nickname)님을 위한 추천 굿즈"
        case .otherGroup:
            return "다른 굿즈 구경하기"
        }
    }
}

protocol HomeViewScrollDelegate: AnyObject {
    func homeViewDidScroll(yOffset: CGFloat)
}

final class HomeViewController: BaseViewController<HomeViewModel>, NavigationConfigurable {
    
    private let factory: ViewControllerFactory
    
    init(
        viewModel: HomeViewModel,
        factory: ViewControllerFactory
    ) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }
    
    // MARK: - Properties
    
    weak var scrollDelegate: HomeViewScrollDelegate?
    private let rootView = HomeView()
    
    // MARK: - Initializer
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? PotiTabBar {
            tabBarController.tabBar.isHidden = false
        }
    }
    
    // MARK: - Custom Methods
    
    override func addTarget() {
        rootView.floatingButton.addTarget(
            self,
            action: #selector(didTapFloatingButton),
            for: .touchUpInside
        )
    }
    
    override func setDelegate() {
        rootView.homeCollectionView.delegate = self
        rootView.homeCollectionView.dataSource = self
    }
    
    override func bindViewModel() {
        viewModel.output.reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.rootView.homeCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.withdrawCompleted
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.switchToLoginRoot()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Action
    
    @objc private func didTapFloatingButton() {
        let productRegisterViewController = factory.makeProductRegisterViewController()
        self.navigationController?.pushViewController(productRegisterViewController, animated: true)
        //                KeychainManager.deleteAllTokens()
    }
    
    // MARK: - Methods
    
    func navigationStyle() -> PotiNavigationStyle {
        return .home
    }
    
    override func searchButtonTapped() {
        viewModel.action(.searchButtonTapped)
    }
    
    private func switchToLoginRoot() {
        let loginVC = factory.makeLoginViewController()
        switchRootViewController(to: loginVC)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = HomeSection(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .banner:
            return 1
        case .myGroup:
            return min(viewModel.myGroupItems.count, 5)
        case .otherGroup:
            return min(viewModel.otherGroupItems.count, 5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = HomeSection(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch section {
        case .banner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCarouselCell.identifier, for: indexPath) as! BannerCarouselCell
            cell.configure(banners: viewModel.banners)
            return cell
            
        case .myGroup:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodsCell.identifier, for: indexPath) as! GoodsCell
            cell.configure(goods: viewModel.myGroupItems[indexPath.item])
            return cell
            
        case .otherGroup:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodsCell.identifier, for: indexPath) as! GoodsCell
            cell.configure(goods: viewModel.otherGroupItems[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = HomeSection(rawValue: indexPath.section) else { return UICollectionReusableView() }
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GoodsHeaderCell.identifier, for: indexPath) as! GoodsHeaderCell
            let nickname = viewModel.nickname
            header.configure(text: section.getHeaderTitle(nickname: nickname), section: indexPath.section)
            header.delegate = self
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.homeViewDidScroll(yOffset: scrollView.contentOffset.y)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionType = HomeSection(rawValue: indexPath.section) else { return }
        
        let selectedGoods: GoodsModel
        switch sectionType {
        case .banner:
            return
        case .myGroup:
            selectedGoods = viewModel.myGroupItems[indexPath.item]
        case .otherGroup:
            selectedGoods = viewModel.otherGroupItems[indexPath.item]
        }
        
        let potListViewController = factory.makePotListViewController(
            title: selectedGoods.postTitle,
            artistId: selectedGoods.artistId,
            artistName: selectedGoods.artist
        )
        
        self.navigationController?.pushViewController(potListViewController, animated: true)
    }
}

extension HomeViewController: GoodsHeaderCellDelegate {
    func moreButtonDidTap(in section: Int) {
        guard let sectionType = HomeSection(rawValue: section) else { return }
        
        let targetArtistId: Int
        
        switch sectionType {
        case .banner:
            return
            
        case .myGroup:
            switch viewModel.userStatus {
            case .favoriteArtistExist:
                targetArtistId = viewModel.mainArtistId ?? 0
            case .favoriteArtistNoArticles, .noFavoriteArtist:
                targetArtistId = 0
            }
            
        case .otherGroup:
            targetArtistId = 0
        }
        
        let feedsViewController = factory.makeFeedsViewController(
            sectionType: sectionType,
            artistId: targetArtistId,
            nickname: viewModel.nickname
        )
        feedsViewController.title = sectionType.getHeaderTitle(nickname: viewModel.nickname)
        
        self.navigationController?.pushViewController(feedsViewController, animated: true)
    }
}
