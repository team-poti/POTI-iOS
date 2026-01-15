//
//  PotsListViewController.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

import UIKit

import Combine

protocol PotsListViewScrollDelegate: AnyObject {
    func potsListViewDidScroll(yOffset: CGFloat)
}

final class PotsListViewController: BaseViewController<PotsListViewModel>{
    
    // MARK: - Properties
    
    weak var scrollDelegate: PotsListViewScrollDelegate?
    private let rootView = PotsListView()
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        let viewModel = PotsListViewModel()
        self.bind(viewModel: viewModel)
        super.viewDidLoad()
        viewModel.viewDidLoad.send(())
        
        self.navigationController?.navigationBar.isHidden = true
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
    
    override func bind(viewModel: PotsListViewModel) {
        super.bind(viewModel: viewModel)
        
        viewModel.$pots
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rootView.potsListCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource

extension PotsListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.pots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PotsListCell.identifier, for: indexPath) as? PotsListCell else {
            return UICollectionViewCell()
        }
        
        let pot = viewModel.pots[indexPath.item]
        cell.configure(pot: pot)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PotsListHeaderCell.identifier, for: indexPath) as! PotsListHeaderCell
            header.delegate = self
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - Extensions

extension PotsListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.potsListViewDidScroll(yOffset: scrollView.contentOffset.y)
    }
}

extension PotsListViewController: PotsListHeaderCellDelegate {
    func leftFilterButtonDidTap() {
        // TODO: - 멤버 모달 이후 구현하기
    }
    
    func rightFilterButtonDidTap() {
        // TODO: - 필터링 모달 이후 구현하기
    }
}
