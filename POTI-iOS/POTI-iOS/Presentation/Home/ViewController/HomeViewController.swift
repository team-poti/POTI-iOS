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
    
    var numberOfItemsInSection: Int {
        switch self {
        case .banner:
            return 3
        case .myGroup, .otherGroup:
            return 5
        }
    }
    
    func getHeaderTitle(nickName: String) -> String? {
        switch self {
        case .banner:
            return nil
        case .myGroup:
            return "\(nickName)님을 위한 추천 굿즈"
        case .otherGroup:
            return "다른 굿즈 구경하기"
        }
    }
}

protocol HomeViewScrollDelegate: AnyObject {
    func homeViewDidScroll(yOffset: CGFloat)
}

final class HomeViewController: BaseViewController<HomeViewModel>{
    
    // MARK: - Properties
    
    weak var scrollDelegate: HomeViewScrollDelegate?
    private let rootView = HomeView()
    private let setHomeData = PassthroughSubject<Void, Never>()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
        self.navigationController?.navigationBar.isHidden = true
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
        
        viewModel.output.updateBannerPage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] page in
                self?.updateBannerFooter(page)
            }
            .store(in: &cancellables)
        
        rootView.currentPageNumber
            .sink { [weak self] page in
                self?.viewModel.action(.bannerScrolled(index: page))
            }
            .store(in: &cancellables)
    }
    
    private func updateBannerFooter(_ page: Int) {
        if let footer = rootView.homeCollectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionFooter,
            at: IndexPath(item: 0, section: 0)
        ) as? BannerFooterCell {
            footer.updatePageControl(currentPage: page)
        }
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
        case .banner: return viewModel.banners.count
        case .myGroup: return viewModel.myGroupItems.count
        case .otherGroup: return viewModel.otherGroupItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = HomeSection(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch section {
        case .banner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as! BannerCell
            cell.configure(banner: viewModel.banners[indexPath.item])
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
            let nickName = viewModel.nickname
            header.configure(text: section.getHeaderTitle(nickName: nickName), section: indexPath.section)
            header.delegate = self
            return header
            
        case UICollectionView.elementKindSectionFooter:
            if section == .banner {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BannerFooterCell.identifier, for: indexPath) as! BannerFooterCell
                return footer
            }
            return UICollectionReusableView()
            
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - Extensions

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.homeViewDidScroll(yOffset: scrollView.contentOffset.y)
    }
}

extension HomeViewController: GoodsHeaderCellDelegate {
    func moreButtonDidTap(in section: Int) {
//        guard let sectionType = HomeSection(rawValue: section) else { return }
        
        let networkService = NetworkService()
        
        let repository = DefaultGoodsListRepository(networkService: networkService)
        let useCase = DefaultGoodsListUseCase(repository: repository)
        
        let goodsListViewModel = GoodsListViewModel(useCase: useCase)
        let goodsListViewController = GoodsListViewController(viewModel: goodsListViewModel)
        
        self.navigationController?.pushViewController(goodsListViewController, animated: true)
    }
}
