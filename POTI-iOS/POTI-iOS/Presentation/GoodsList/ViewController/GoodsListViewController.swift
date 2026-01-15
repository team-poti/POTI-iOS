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

final class GoodsListViewController: BaseViewController<GoodsListViewModel> {
    
    // MARK: - Properties
    
    weak var scrollDelegate: GoodsListViewScrollDelegate?
    private let rootView = GoodsListView()
    private let setGoodsListData = PassthroughSubject<Void, Never>()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGoodsListData.send(())
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
        rootView.goodsListCollectionView.delegate = self
        rootView.goodsListCollectionView.dataSource = self
    }
    
    override func bindViewModel() {
        let input = GoodsListViewModel.Input(
            viewDidLoad: setGoodsListData.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.rootView.goodsListCollectionView.reloadData()
            }
            .store(in: &cancellables)
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
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GoodsListHeaderCell.identifier, for: indexPath) as! GoodsListHeaderCell
            header.delegate = self
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
    }
}

extension GoodsListViewController: GoodsListHeaderCellDelegate {
    func filterButtonDidTap() {
        
        // TODO: - 멤버 모달 이후 구현하기
        
    }
}
