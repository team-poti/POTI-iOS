//
//  ArtistSearchViewController.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/19/26.
//

import UIKit

import Combine

final class ArtistSearchViewController: BaseViewController<ArtistSearchViewModel>, NavigationConfigurable {

    // MARK: - UI Components

    private let rootView = ArtistSearchView()

    var onSelectArtist: ((RegisterArtistEntity) -> Void)?

    // MARK: - Custom Method

    func navigationStyle() -> PotiNavigationStyle {
        return .backDefault("아티스트 검색")
    }

    override func addTarget() {
        rootView.doneButton.addTarget(
            self,
            action: #selector(didTapDone),
            for: .touchUpInside
        )
    }

    @objc private func didTapDone() {
        viewModel.action(.tapDone)
    }

    // MARK: - Life Cycle

    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? PotiTabBar {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? PotiTabBar {
            tabBarController.tabBar.isHidden = false
        }
    }

    // MARK: - delegate Method

    override func bindViewModel() {
        
        rootView.onChangeQuery = { [weak self] query in
            guard let self else { return }
            self.rootView.setDoneEnabled(false)
            self.viewModel.action(.queryChanged(query))
        }
        
        rootView.onSelectItem = { [weak self] index, name in
            guard let self else { return }
            self.rootView.setQueryText(name)
            self.rootView.setDoneEnabled(true)
            self.viewModel.action(.selectArtist(index: index))
        }
        
        viewModel.output.artists
            .receive(on: RunLoop.main)
            .sink { [weak self] artists in
                self?.rootView.setSearchItems(artists.compactMap { $0.name })
            }
            .store(in: &cancellables)
        
        viewModel.output.didSelectArtist
            .receive(on: RunLoop.main)
            .sink { [weak self] artist in
                guard let self else { return }
                                
                self.onSelectArtist?(artist)
                
                if self.navigationController != nil {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
    }
}
