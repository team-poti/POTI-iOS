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
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        let viewModel = HomeViewModel()
        self.bind(viewModel: viewModel)
        super.viewDidLoad()
        viewModel.viewDidLoad.send(())
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func setDelegate() {
        rootView.homeCollectionView.delegate = self
        rootView.homeCollectionView.dataSource = self
    }
    
    override func bind(viewModel: HomeViewModel) {
        super.bind(viewModel: viewModel)
        
        Publishers.CombineLatest4(viewModel.$banners, viewModel.$myGroupGoods, viewModel.$otherGroupGoods, viewModel.$nickName)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rootView.homeCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        rootView.currentPageNumber
            .receive(on: DispatchQueue.main)
            .sink { [weak self] page in
                guard let self = self else { return }
                if let footer = self.rootView.homeCollectionView.supplementaryView(
                    forElementKind: UICollectionView.elementKindSectionFooter,
                    at: IndexPath(item: 0, section: 0)
                ) as? BannerFooterCell {
                    footer.updatePageControl(currentPage: page)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = HomeSection(rawValue: section),
              let viewModel = viewModel else { return 0 }
        
        switch sectionType {
        case .banner: return viewModel.banners.count
        case .myGroup: return viewModel.myGroupGoods.count
        case .otherGroup: return viewModel.otherGroupGoods.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = HomeSection(rawValue: indexPath.section),
              let viewModel = viewModel else { return UICollectionViewCell() }
        
        switch section {
        case .banner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as! BannerCell
            cell.configure(banner: viewModel.banners[indexPath.item])
            return cell
            
        case .myGroup:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodsCell.identifier, for: indexPath) as! GoodsCell
            cell.configure(goods: viewModel.myGroupGoods[indexPath.item])
            return cell
            
        case .otherGroup:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodsCell.identifier, for: indexPath) as! GoodsCell
            cell.configure(goods: viewModel.otherGroupGoods[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = HomeSection(rawValue: indexPath.section) else { return UICollectionReusableView() }
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GoodsHeaderCell", for: indexPath) as! GoodsHeaderCell
            let nickName = viewModel?.nickName ?? "알 수 없음"
            header.configure(text: section.getHeaderTitle(nickName: nickName), section: indexPath.section)
            header.delegate = self
            return header
            
        case UICollectionView.elementKindSectionFooter:
            if section == .banner {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BannerFooterCell", for: indexPath) as! BannerFooterCell
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
        guard let sectionType = HomeSection(rawValue: section) else { return }
        let currentNickName = viewModel?.nickName ?? ""
        print("\(sectionType.getHeaderTitle(nickName: currentNickName) ?? "") 더보기 액션")
        
        // MARK: - TODO 홈 더보기 뷰 연결하기
    }
}
