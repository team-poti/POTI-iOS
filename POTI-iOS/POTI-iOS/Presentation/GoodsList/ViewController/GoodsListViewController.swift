//
//  GoodsListViewController.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import UIKit

import Combine

protocol GoodsListViewScrollDelegate: AnyObject {
    func goodsListViewDidScroll(yOffset: CGFloat)
}

final class GoodsListViewController: BaseViewController<GoodsListViewModel>, NavigationConfigurable {
    
    // MARK: - Properties
    
    weak var scrollDelegate: GoodsListViewScrollDelegate?
    private let rootView = GoodsListView()
    private let setGoodsListData = PassthroughSubject<Void, Never>()
    private let factory: ViewControllerFactory
    
    // MARK: - Initializer
    
    init(viewModel: GoodsListViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.updateLayout(sectionType: viewModel.sectionType)
        viewModel.action(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? PotiTabBar {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? PotiTabBar {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    // MARK: - Custom Methods
    
    override func setDelegate() {
        rootView.goodsListCollectionView.delegate = self
        rootView.goodsListCollectionView.dataSource = self
    }
    
    override func bindViewModel() {
        viewModel.output.reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.rootView.goodsListCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func addTarget() {
        rootView.floatingButton.addTarget(
            self,
            action: #selector(didTapFloatingButton),
            for: .touchUpInside
        )
    }
    
    // MARK: - Method
    
    func navigationStyle() -> PotiNavigationStyle {
        let title = viewModel.sectionType.getHeaderTitle(nickName: viewModel.nickname) ?? ""
        return .backDefault(title)
    }
    
    @objc private func didTapFloatingButton() {
        let vc = factory.makeProductRegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension GoodsListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.groupItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodsListCell.identifier, for: indexPath) as? GoodsListCell else {
            return UICollectionViewCell()
        }
        
        let goods = viewModel.groupItems[indexPath.item]
        cell.configure(goods: goods)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: GoodsListHeaderCell.identifier,
                for: indexPath
            ) as! GoodsListHeaderCell
            
            header.delegate = self
            
            header.configure(
                text: viewModel.currentSortText,
                isFilterVisible: (viewModel.sectionType != .otherGroup)
            )
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - Extensions

extension GoodsListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.goodsListViewDidScroll(yOffset: scrollView.contentOffset.y)
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            viewModel.action(.loadNextPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let goods = viewModel.groupItems[indexPath.item]
        
        let potListVC = factory.makePotListViewController(
            title: goods.title,
            artistId: goods.artistId,
            artistName: goods.artist
        )
        self.navigationController?.pushViewController(potListVC, animated: true)
    }
}

extension GoodsListViewController: GoodsListHeaderCellDelegate {
    func filterButtonDidTap() {
        let initialIndex = (viewModel.currentSort == "LATEST") ? 0 : 1
        let bottomSheet = factory.makeSortBottomSheet(type: .goods, initialIndex: initialIndex)
        
        bottomSheet.onSelectCompletion = { [weak self] index in
            self?.viewModel.action(.didTapSortOption(index: index))
        }
        
        bottomSheet.onDismissCompletion = { [weak self] in
            if let header = self?.rootView.goodsListCollectionView.supplementaryView(
                forElementKind: UICollectionView.elementKindSectionHeader,
                at: IndexPath(item: 0, section: 0)
            ) as? GoodsListHeaderCell {
                header.setFilterButtonState(isSelected: false)
            }
        }
        bottomSheet.show(on: self.navigationController?.view ?? self.view)
    }
}
