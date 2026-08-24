//
//  WithdrawalViewController.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

final class WithdrawalViewController: BaseViewController<SettingsViewModel>, NavigationConfigurable {
    private let rootView = WithdrawalView()
    private let factory: ViewControllerFactory

    init(viewModel: SettingsViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func navigationStyle() -> PotiNavigationStyle { .backDefault("회원 탈퇴") }

    override func loadView() { view = rootView }

    override func addTarget() {
        rootView.withdrawButton.addTarget(self, action: #selector(withdrawTapped), for: .touchUpInside)
    }

    @objc private func withdrawTapped() {
        guard let reason = rootView.selectedReason else { return }
        let confirmationView = WithdrawalConfirmationView { [weak self] in
            self?.viewModel.action(.withdraw(reason))
        }
        confirmationView.show(on: navigationController?.view ?? view)
    }
}
