//
//  WithdrawalViewController.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

import Combine

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

    override func bindViewModel() {
        viewModel.output.withdrawalCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.navigateToLogin() }
            .store(in: &cancellables)
    }

    override func addTarget() {
        rootView.withdrawButton.addTarget(self, action: #selector(withdrawTapped), for: .touchUpInside)
    }

    @objc private func withdrawTapped() {
        guard let reasonCode = rootView.selectedReasonCode else { return }
        let confirmationView = WithdrawalConfirmationView { [weak self] in
            self?.viewModel.action(.withdraw(reasonCode))
        }
        confirmationView.show(on: navigationController?.view ?? view)
    }

    private func navigateToLogin() {
        switchRootViewController(to: factory.makeLoginViewController())
    }
}
