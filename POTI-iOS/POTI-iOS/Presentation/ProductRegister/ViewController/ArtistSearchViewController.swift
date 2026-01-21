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

    // MARK: - delegate Method

    override func bindViewModel() {
        
        rootView.onChangeQuery = { [weak self] query in
            self?.viewModel.action(.queryChanged(query))
        }
        
        viewModel.output.isDoneEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                self?.rootView.setDoneEnabled(isEnabled)
            }
            .store(in: &cancellables)

        viewModel.output.didSubmitQuery
            .receive(on: RunLoop.main)
            .sink { [weak self] query in
                print("ArtistSearch submitted query:", query)

                if self?.navigationController != nil {
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    self?.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
    }
}
