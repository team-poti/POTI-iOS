//
//  PotListViewController.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import UIKit

import Combine

protocol PotListViewScrollDelegate: AnyObject {
    func potListViewDidScroll(yOffset: CGFloat)
}

final class PotListViewController: BaseViewController<PotListViewModel>, NavigationConfigurable {
    
    // MARK: - Properties
    
    weak var scrollDelegate: PotListViewScrollDelegate?
    private let rootView = PotListView()
    private let factory: ViewControllerFactory
    
    // MARK: - Initializer
    
    init(viewModel: PotListViewModel, factory: ViewControllerFactory) {
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
        setupNavigationBar()
        viewModel.action(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? PotiTabBar {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    // MARK: - Custom Methods
    
    override func setDelegate() {
        rootView.potListCollectionView.delegate = self
        rootView.potListCollectionView.dataSource = self
    }
    
    override func bindViewModel() {
        viewModel.output.reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.rootView.potListCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.sortTitle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.updateHeaderSortTitle(title)
            }
            .store(in: &cancellables)
        
        viewModel.output.filterTitle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.updateHeaderFilterTitle(title)
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
    
    // MARK: - Methods
    
    func navigationStyle() -> PotiNavigationStyle {
        return .backSubtitle(title: viewModel.title, subtitle: viewModel.artistName)
    }
    
    func setupNavigationBar() {
        let style = navigationStyle()
        PotiNavigationBar.configure(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            style: style,
            target: self
        )
    }
    
    private func setHeaderButtonState(isMemberFilter: Bool, isSelected: Bool) {
        if let header = rootView.potListCollectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: 0)
        ) as? PotListHeaderCell {
            header.setButtonSelectionState(isMemberFilter: isMemberFilter, isSelected: isSelected)
        }
    }
    
    private func updateHeaderSortTitle(_ title: String) {
        if let header = rootView.potListCollectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: 0)
        ) as? PotListHeaderCell {
            header.setSortButtonTitle(title)
        }
    }
    
    private func updateHeaderFilterTitle(_ title: String) {
        if let header = rootView.potListCollectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: 0)
        ) as? PotListHeaderCell {
            header.setSortButtonTitle(title)
        }
    }
    
    @objc private func didTapFloatingButton() {
        let vc = factory.makeProductRegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension PotListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PotListCell.identifier, for: indexPath) as? PotListCell else {
            return UICollectionViewCell()
        }
        
        let feed = viewModel.pots[indexPath.item]
        cell.configure(model: feed)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PotListHeaderCell.identifier, for: indexPath) as? PotListHeaderCell else {
            return UICollectionReusableView() 
        }
        
        header.delegate = self
        header.configure(
            memberFilterText: viewModel.output.filterTitle.value,
            sortText: viewModel.currentSort.title
        )
        return header
    }
}

//MARK: - Extensions

extension PotListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.potListViewDidScroll(yOffset: scrollView.contentOffset.y)
        
        let threshold = scrollView.contentSize.height - scrollView.frame.size.height
        if scrollView.contentOffset.y > threshold * 0.85 {
            viewModel.action(.loadNextPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPot = viewModel.pots[indexPath.item]
        guard selectedPot.status != "CLOSED" else { return }
        
        let detailViewController = factory.makePotDetailViewController(postId: selectedPot.potId)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension PotListViewController: PotListHeaderCellDelegate {
    func memberFilterButtonDidTap() {
        let memberFilterBottomSheet = factory.makeArtistMembersFilterBottomSheet(
            artistId: viewModel.artistId,
            selectedIds: viewModel.selectedMemberIds
        )
        
        memberFilterBottomSheet.onComplete = { [weak self] data in
            self?.viewModel.action(.filterByMembers(members: data.ids, names: data.names))
        }
        
        memberFilterBottomSheet.onDismissCompletion = { [weak self] in
            self?.setHeaderButtonState(isMemberFilter: true, isSelected: false)
        }
        
        memberFilterBottomSheet.show(in: self.navigationController?.view ?? self.view)
    }
    
    func sortButtonDidTap() {
        let initialIndex = viewModel.currentSort.rawValue
        let sortBottomSheet = factory.makeSortBottomSheet(type: .pot, initialIndex: initialIndex)
        
        sortBottomSheet.onSelectCompletion = { [weak self] index in
            self?.viewModel.action(.didTapSortOption(index: index))
        }
        
        sortBottomSheet.onDismissCompletion = { [weak self] in
            self?.setHeaderButtonState(isMemberFilter: false, isSelected: false)
        }
        
        sortBottomSheet.show(on: self.navigationController?.view ?? self.view)
    }
}


