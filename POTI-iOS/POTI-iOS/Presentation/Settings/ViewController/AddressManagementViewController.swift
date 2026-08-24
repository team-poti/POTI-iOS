//
//  AddressManagementViewController.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

import Combine

final class AddressManagementViewController: BaseViewController<SettingsViewModel>, NavigationConfigurable {
    private let rootView = AddressManagementView()

    func navigationStyle() -> PotiNavigationStyle { .backDefault("내 주소 관리") }

    override func loadView() { view = rootView }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.fetchAddress)
    }

    override func bindViewModel() {
        viewModel.output.address
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.rootView.configure($0) }
            .store(in: &cancellables)

        viewModel.output.completed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.navigationController?.popViewController(animated: true) }
            .store(in: &cancellables)
    }

    override func addTarget() {
        rootView.saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        rootView.postalCodeField.searchButton.addTarget(self, action: #selector(searchPostalCodeTapped), for: .touchUpInside)
    }

    @objc private func saveTapped() { viewModel.action(.updateAddress(rootView.address)) }

    @objc private func searchPostalCodeTapped() {
        let viewController = PostcodeSearchViewController { [weak self] postalCode, address in
            self?.rootView.applySearchResult(postalCode: postalCode, address: address)
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
