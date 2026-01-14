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

final class GoodsListViewController: BaseViewController<GoodsListViewModel>{
    
    // MARK: - Properties
    
    weak var scrollDelegate: GoodsListViewScrollDelegate?
    private let rootView = GoodsListView()
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        let viewModel = GoodsListViewModel()
        self.bind(viewModel: viewModel)
        super.viewDidLoad()
        viewModel.viewDidLoad.send(())
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Custom Methods
    
    override func setDelegate() {
        rootView.goodsListCollectionView.delegate = self
        rootView.goodsListCollectionView.dataSource = self
    }
    
    override func bind(viewModel: GoodsListViewModel) {
        super.bind(viewModel: viewModel)
        
        Publishers.CombineLatest(viewModel.$popularGoods, viewModel.$recentGoods)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
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
        guard let viewModel = viewModel else { return 0 }
        return viewModel.popularGoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodsListCell.identifier, for: indexPath) as? GoodsListCell else {
            return UICollectionViewCell()
        }
        
        let goods = viewModel.popularGoods[indexPath.item]
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
