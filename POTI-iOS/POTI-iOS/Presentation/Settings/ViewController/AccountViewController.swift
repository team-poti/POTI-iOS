//
//  AccountViewController.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

import Combine

final class AccountViewController: BaseViewController<SettingsViewModel>, NavigationConfigurable {
    private let rootView = AccountView()
    private let factory: ViewControllerFactory

    init(viewModel: SettingsViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func navigationStyle() -> PotiNavigationStyle { .backDefault("내 계정") }

    override func loadView() { view = rootView }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.fetchAccount)
    }

    override func bindViewModel() {
        viewModel.output.account
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.rootView.configure($0) }
            .store(in: &cancellables)

        viewModel.output.withdrawalAvailability
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in self?.handleWithdrawalAvailability(state) }
            .store(in: &cancellables)

        viewModel.output.logoutCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.navigateToLogin() }
            .store(in: &cancellables)

    }

    override func addTarget() {
        rootView.logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        rootView.withdrawalButton.addTarget(self, action: #selector(withdrawalTapped), for: .touchUpInside)
    }

    @objc private func logoutTapped() { viewModel.action(.logout) }
    @objc private func withdrawalTapped() { viewModel.action(.checkWithdrawal) }

    private func handleWithdrawalAvailability(_ state: WithdrawalAvailabilityEntity) {
        switch state {
        case .available:
            navigationController?.pushViewController(
                factory.makeWithdrawalViewController(viewModel: viewModel),
                animated: true
            )
        case .unavailable:
            WithdrawalUnavailableView().show(on: navigationController?.view ?? view)
        }
    }

    private func navigateToLogin() {
        switchRootViewController(to: factory.makeLoginViewController())
    }
}
