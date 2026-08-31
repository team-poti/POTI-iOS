//
//  SettingsViewController.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

final class SettingsViewController: BaseViewController<SettingsViewModel>, NavigationConfigurable {
    private let rootView = SettingsView()
    private let factory: ViewControllerFactory

    init(viewModel: SettingsViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func navigationStyle() -> PotiNavigationStyle { .backDefault("설정") }

    override func loadView() { view = rootView }

    override func addTarget() {
        rootView.accountButton.addTarget(self, action: #selector(accountTapped), for: .touchUpInside)
        rootView.profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        rootView.addressButton.addTarget(self, action: #selector(addressTapped), for: .touchUpInside)
        rootView.notificationButton.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
    }

    @objc private func accountTapped() {
        navigationController?.pushViewController(
            factory.makeAccountViewController(viewModel: viewModel),
            animated: true
        )
    }

    @objc private func profileTapped() {
        navigationController?.pushViewController(
            factory.makeProfileManagementViewController(viewModel: viewModel),
            animated: true
        )
    }

    @objc private func addressTapped() {
        navigationController?.pushViewController(
            factory.makeAddressManagementViewController(viewModel: viewModel),
            animated: true
        )
    }

    @objc private func notificationTapped() {
        navigationController?.pushViewController(
            factory.makeNotificationSettingViewController(),
            animated: true
        )
    }
}
