//
//  PotListViewController.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import UIKit

import Combine

protocol PotListViewScrollDelegate: AnyObject {
    func potsListViewDidScroll(yOffset: CGFloat)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? PotiTabBar {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    // MARK: - Custom Methods
    
    override func setDelegate() {
        rootView.potsListCollectionView.delegate = self
        rootView.potsListCollectionView.dataSource = self
    }
    
    override func bindViewModel() {
        viewModel.output.reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.rootView.potsListCollectionView.reloadData()
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
    
    private func setHeaderButtonState(isLeft: Bool, isSelected: Bool) {
        if let header = rootView.potsListCollectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: 0)
        ) as? PotListHeaderCell {
            header.setFilterButtonState(isLeft: isLeft, isSelected: isSelected)
        }
    }
    
    private func updateHeaderSortTitle(_ title: String) {
        if let header = rootView.potsListCollectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: 0)
        ) as? PotListHeaderCell {
            header.setSortButtonTitle(title)
        }
    }
    
    private func updateHeaderFilterTitle(_ title: String) {
        if let header = rootView.potsListCollectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: 0)
        ) as? PotListHeaderCell {
            header.setLeftFilterButtonTitle(title)
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
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PotListHeaderCell.identifier, for: indexPath) as! PotListHeaderCell
            header.delegate = self
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - Extensions

extension PotListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.potsListViewDidScroll(yOffset: scrollView.contentOffset.y)
        
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let frameHeight = scrollView.frame.size.height
        
        if yOffset > (contentHeight - frameHeight) * 0.8 {
            viewModel.action(.viewDidLoad)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPot = viewModel.pots[indexPath.item]
        let detailVC = factory.makePotDetailViewController(postId: selectedPot.potId)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension PotListViewController: PotListHeaderCellDelegate {
    func leftFilterButtonDidTap() {
        let bottomSheet = factory.makeArtistsBottomSheet(
            artistId: viewModel.artistId,
            selectedIds: viewModel.selectedMemberIds
        )
        
        bottomSheet.onComplete = { [weak self] data in
            self?.viewModel.action(.filterByMembers(members: data.ids, names: data.names))
        }
        
        bottomSheet.onDismissCompletion = { [weak self] in
            self?.setHeaderButtonState(isLeft: true, isSelected: false)
        }
        
        bottomSheet.show(in: self.navigationController?.view ?? self.view)
    }
    
    func rightFilterButtonDidTap() {
        let initialIndex = viewModel.currentSortIndex
        
        let bottomSheet = factory.makeSortBottomSheet(type: .pot, initialIndex: initialIndex)
        
        bottomSheet.onSelectCompletion = { [weak self] index in
            self?.viewModel.action(.didTapSortOption(index: index))
        }
        
        bottomSheet.onDismissCompletion = { [weak self] in
            self?.setHeaderButtonState(isLeft: false, isSelected: false)
        }
        
        bottomSheet.show(on: self.navigationController?.view ?? self.view)
    }
}


