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
            navigationController?.pushViewController(WithdrawalViewController(viewModel: viewModel), animated: true)
        case .unavailable:
            let alert = UIAlertController(
                title: "회원탈퇴를 할 수 없어요",
                message: "진행 중인 모집이나 참여 내역이 있어 지금은 탈퇴할 수 없어요. 진행 중인 거래가 모두 종료된 후 다시 시도해 주세요.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    }
}
