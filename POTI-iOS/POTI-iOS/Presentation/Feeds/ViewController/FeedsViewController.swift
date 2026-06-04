//
//  FeedsViewController.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import UIKit

import Combine

protocol FeedsViewScrollDelegate: AnyObject {
    func feedsViewDidScroll(yOffset: CGFloat)
}

final class FeedsViewController: BaseViewController<FeedsViewModel>, NavigationConfigurable {
    
    // MARK: - Properties
    
    weak var scrollDelegate: FeedsViewScrollDelegate?
    private let rootView = FeedsView()
    private let factory: ViewControllerFactory
    
    // MARK: - Initializer
    
    init(viewModel: FeedsViewModel, factory: ViewControllerFactory) {
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
        rootView.feedsCollectionView.delegate = self
        rootView.feedsCollectionView.dataSource = self
    }
    
    override func bindViewModel() {
        viewModel.output.reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.rootView.feedsCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func addTarget() {
        rootView.floatingButton.addTarget(self, action: #selector(floatingButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Method
    
    func navigationStyle() -> PotiNavigationStyle {
        let title = viewModel.sectionType.getHeaderTitle(nickname: viewModel.nickname)
        return .backDefault(title)
    }
    
    // MARK: - Action
    
    @objc private func floatingButtonDidTap() {
        let registerViewContorller = factory.makeProductRegisterViewController()
        self.navigationController?.pushViewController(registerViewContorller, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension FeedsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.groupItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedsCell.identifier, for: indexPath) as? FeedsCell else {
            return UICollectionViewCell()
        }
        
        let groupItem = viewModel.groupItems[indexPath.item]
        cell.configure(groupItem: groupItem)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FeedsHeaderCell.identifier,
                for: indexPath
            ) as! FeedsHeaderCell
            
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

extension FeedsViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.feedsViewDidScroll(yOffset: scrollView.contentOffset.y)
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            viewModel.action(.loadNextPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let groupItem = viewModel.groupItems[indexPath.item]
        
        let potListViewController = factory.makePotListViewController(
            title: groupItem.title,
            artistId: groupItem.artistId,
            artistName: groupItem.artist
        )
        self.navigationController?.pushViewController(potListViewController, animated: true)
    }
}

extension FeedsViewController: FeedsHeaderCellDelegate {
    func filterButtonDidTap() {
        if let header = rootView.feedsCollectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: 0)
        ) as? FeedsHeaderCell {
            header.setFilterButtonState(isSelected: true)
        }
        
        let initialIndex = (viewModel.currentSort == .latest) ? 0 : 1
        let bottomSheet = factory.makeSortBottomSheet(type: .feeds, initialIndex: initialIndex)
        
        bottomSheet.onSelectCompletion = { [weak self] index in
            let selectedOption: FeedsSortOption = (index == 0) ? .latest : .hot
            
            self?.viewModel.action(.didTapSortOption(option: selectedOption))
        }
        
        bottomSheet.onDismissCompletion = { [weak self] in
            if let header = self?.rootView.feedsCollectionView.supplementaryView(
                forElementKind: UICollectionView.elementKindSectionHeader,
                at: IndexPath(item: 0, section: 0)
            ) as? FeedsHeaderCell {
                header.setFilterButtonState(isSelected: false)
            }
        }
        bottomSheet.show(on: self.navigationController?.view ?? self.view)
    }
}
