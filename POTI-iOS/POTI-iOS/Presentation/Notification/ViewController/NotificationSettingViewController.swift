//
//  NotificationSettingViewController.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

import UIKit

import Combine

final class NotificationSettingViewController: BaseViewController<NotificationSettingViewModel>, NavigationConfigurable {
    
    // MARK: - Property
    
    private let rootView = NotificationSettingView()
    
    // MARK: - Initializer
    
    override init(viewModel: NotificationSettingViewModel) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
    }
    
    // MARK: - Custom Methods
    
    override func addTarget() {
        rootView.tradeToggle.addTarget(self, action: #selector(tradeToggleChanged), for: .valueChanged)
        rootView.eventToggle.addTarget(self, action: #selector(eventToggleChanged), for: .valueChanged)
    }
    
    override func bindViewModel() {
        viewModel.output.reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                rootView.configure(isTradeNotificationOn: viewModel.isTradeNotificationOn, isEventNotificationOn: viewModel.isEventNotificationOn)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    
    private func resetToggleState() {
        rootView.configure(
            isTradeNotificationOn: viewModel.isTradeNotificationOn,
            isEventNotificationOn: viewModel.isEventNotificationOn
        )
    }
    
    private func showPushNotificationPermissionModal() {
        let modalView = PushNotificationPermissionModalView()
        modalView.onTapAllow = { [weak self] in
            self?.viewModel.action(.setAllNotifications(isEnabled: true))
        }
        modalView.onTapLater = { [weak self] in
            self?.viewModel.action(.setAllNotifications(isEnabled: false))
        }
        modalView.show(in: navigationController?.view ?? view)
    }
    
    // MARK: - Public Method
    
    func navigationStyle() -> PotiNavigationStyle {
        .backDefault("알림 설정")
    }
    
    // MARK: - Actions
    
    @objc private func tradeToggleChanged() {
        if viewModel.isTradeNotificationOn {
            viewModel.action(.didToggleTradeNotification)
        } else {
            resetToggleState()
            showPushNotificationPermissionModal()
        }
    }
    
    @objc private func eventToggleChanged() {
        if viewModel.isEventNotificationOn {
            viewModel.action(.didToggleEventNotification)
        } else {
            resetToggleState()
            showPushNotificationPermissionModal()
        }
    }
}
