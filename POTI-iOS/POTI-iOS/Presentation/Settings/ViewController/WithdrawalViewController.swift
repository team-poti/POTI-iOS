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

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.fetchWithdrawalReasons)
    }

    override func bindViewModel() {
        viewModel.output.withdrawalCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.navigateToLogin() }
            .store(in: &cancellables)

        viewModel.output.withdrawalReasons
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.rootView.configure(reasons: $0) }
            .store(in: &cancellables)

        viewModel.output.withdrawalError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.showWithdrawalError($0) }
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

    private func showWithdrawalError(_ error: SettingsViewModel.WithdrawalError) {
        let message: String
        switch error {
        case .activeTransaction:
            WithdrawalUnavailableView().show(on: navigationController?.view ?? view)
            return
        case .general(let errorMessage):
            message = errorMessage
        }

        let alert = UIAlertController(
            title: "회원탈퇴를 할 수 없어요",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
