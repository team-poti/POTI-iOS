//
//  ArtistSearchViewController.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/19/26.
//

import UIKit

final class ArtistSearchViewController: BaseViewController<ArtistSearchViewModel>, NavigationConfigurable {

    // MARK: - Properties


    // MARK: - UI Components

    private let rootView = ArtistSearchView()

    // MARK: - Life Cycle

    override func loadView() {
        self.view = rootView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.focusQuery()
    }


    // MARK: - Custom Method

    func navigationStyle() -> PotiNavigationStyle {
        return .backDefault("아티스트 검색")
    }


    // MARK: - delegate Method

    override func bindViewModel() {
        rootView.onChangeQuery = { [weak self] query in
            self?.viewModel.action(.queryChanged(query))
        }

        rootView.onTapDone = { [weak self] in
            self?.viewModel.action(.tapDone)
        }
    }
}
