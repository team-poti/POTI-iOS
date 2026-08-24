//
//  SettingsViewController.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

final class SettingsViewController: BaseViewController<SettingsViewModel>, NavigationConfigurable {
    private let rootView = SettingsView()

    func navigationStyle() -> PotiNavigationStyle { .backDefault("설정") }

    override func loadView() { view = rootView }

    override func addTarget() {
        rootView.accountButton.addTarget(self, action: #selector(accountTapped), for: .touchUpInside)
        rootView.profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        rootView.addressButton.addTarget(self, action: #selector(addressTapped), for: .touchUpInside)
    }

    @objc private func accountTapped() {
        navigationController?.pushViewController(AccountViewController(viewModel: viewModel), animated: true)
    }

    @objc private func profileTapped() {
        navigationController?.pushViewController(ProfileManagementViewController(viewModel: viewModel), animated: true)
    }

    @objc private func addressTapped() {
        navigationController?.pushViewController(AddressManagementViewController(viewModel: viewModel), animated: true)
    }
}
