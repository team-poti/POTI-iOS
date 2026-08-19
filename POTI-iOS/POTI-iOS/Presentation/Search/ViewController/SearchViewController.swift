//
//  SearchViewController.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

import UIKit

import Combine

final class SearchViewController: BaseViewController<SearchViewModel> {
    private let rootView = SearchView()
    private let factory: ViewControllerFactory
    private var didFocusSearchBar = false

    init(viewModel: SearchViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycles

    override func loadView() {
        view = rootView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !didFocusSearchBar else { return }
        didFocusSearchBar = true
        rootView.focusSearchBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rootView.dismissKeyboard()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Custom Methods

    override func setDelegate() {
        rootView.resultsCollectionView.dataSource = self
        rootView.resultsCollectionView.delegate = self
    }

    override func addTarget() {
        rootView.onTapBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        rootView.onSubmitSearch = { [weak self] in self?.viewModel.action(.submitSearch($0)) }
    }

    override func bindViewModel() {
        rootView.queryPublisher
            .sink { [weak self] in self?.viewModel.action(.queryChanged($0)) }
            .store(in: &cancellables)

        viewModel.output.render
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.rootView.render(state)
                self?.rootView.resultsCollectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.output.showPotList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self, let artistId = item.artistId else { return }
                let viewController = factory.makePotListViewController(title: item.title, artistId: artistId, artistName: item.artist)
                navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.results.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodsListCell.identifier, for: indexPath) as? GoodsListCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.results[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.action(.selectResult(indexPath.item))
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold = scrollView.contentSize.height - scrollView.bounds.height - 100
        guard scrollView.contentOffset.y > threshold else { return }
        viewModel.action(.loadNextPage)
    }
}
