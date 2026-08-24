//
//  ArtistSearchViewController.swift
//  POTI-iOS
//
//  Created by soomin on 1/19/26.
//

import UIKit

import Combine

final class ArtistSearchViewController: BaseViewController<ArtistSearchViewModel>, NavigationConfigurable {

    // MARK: - Properties

    private let rootView = ArtistSearchView()
    var onSelectArtist: ((ArtistSearchItem) -> Void)?

    // MARK: - Life Cycles

    override func loadView() {
        view = rootView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Custom Methods

    override func addTarget() {
        rootView.queryPublisher
            .sink { [weak self] in self?.viewModel.action(.queryChanged($0)) }
            .store(in: &cancellables)
        rootView.onSelectArtist = { [weak self] in self?.viewModel.action(.artistSelected($0)) }
        rootView.onTapConfirm = { [weak self] in self?.viewModel.action(.confirmButtonTapped) }
    }

    override func bindViewModel() {
        viewModel.output.state
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.rootView.render($0) }
            .store(in: &cancellables)

        viewModel.output.didSelectArtist
            .receive(on: RunLoop.main)
            .sink { [weak self] artist in
                self?.onSelectArtist?(artist)
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Method

    func navigationStyle() -> PotiNavigationStyle {
        .backDefault("아티스트 검색")
    }
}
