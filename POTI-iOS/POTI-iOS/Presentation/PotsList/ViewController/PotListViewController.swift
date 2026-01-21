//
//  PotListViewController.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

import UIKit

import Combine

protocol PotListViewScrollDelegate: AnyObject {
    func potsListViewDidScroll(yOffset: CGFloat)
}

final class PotListViewController: BaseViewController<PotListViewModel>{
    
    // MARK: - Properties
    
    weak var scrollDelegate: PotListViewScrollDelegate?
    private let rootView = PotListView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
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
    
    override func bindViewModel() {
        viewModel.output.reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.rootView.potsListCollectionView.reloadData()
            }
            .store(in: &cancellables)
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
        
        let pot = viewModel.pots[indexPath.item]
        cell.configure(pot: pot)
        
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
    }
}

extension PotListViewController: PotListHeaderCellDelegate {
    func leftFilterButtonDidTap() {
        // TODO: - 멤버 모달 이후 구현하기
    }
    
    func rightFilterButtonDidTap() {
        // TODO: - 필터링 모달 이후 구현하기
    }
}
