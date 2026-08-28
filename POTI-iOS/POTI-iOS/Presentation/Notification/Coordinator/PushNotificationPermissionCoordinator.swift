//
//  PushNotificationPermissionCoordinator.swift
//  POTI-iOS
//
//  Created by soomin on 8/28/26.
//

import UIKit

final class PushNotificationPermissionCoordinator {
    
    // MARK: - Properties
    
    private let viewModel: NotificationSettingViewModel
    private let permissionService: PushNotificationPermissionService
    private var isWaitingForSystemSettings = false
    
    // MARK: - Initializer
    
    init(viewModel: NotificationSettingViewModel, permissionService: PushNotificationPermissionService) {
        self.viewModel = viewModel
        self.permissionService = permissionService
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    
    private func requestSystemPermission() {
        Task { [weak self] in
            guard let self else { return }
            let result = await permissionService.requestPermissionOrOpenSettings()
            await handlePermissionResult(result)
        }
    }
    
    @MainActor
    private func handlePermissionResult(_ result: PushNotificationPermissionResult) {
        switch result {
        case .granted:
            viewModel.action(.setAllNotifications(isEnabled: true))
        case .denied:
            viewModel.action(.setAllNotifications(isEnabled: false))
        case .openedSettings:
            isWaitingForSystemSettings = true
            viewModel.action(.setAllNotifications(isEnabled: false))
        }
    }
    
    // MARK: - Public Methods
    
    func showPermissionModal(in view: UIView) {
        let modalView = PushNotificationPermissionModalView()
        modalView.onTapAllow = { [weak self] in
            self?.requestSystemPermission()
        }
        modalView.onTapLater = { [weak self] in
            self?.viewModel.action(.setAllNotifications(isEnabled: false))
        }
        modalView.show(in: view)
    }
    
    func handleEnablingNotification(in view: UIView, whenPermissionAllowed: @escaping () -> Void) {
        Task { [weak self] in
            guard let self else { return }
            
            if await permissionService.isPermissionAllowed() {
                await MainActor.run { whenPermissionAllowed() }
            } else {
                await MainActor.run { self.showPermissionModal(in: view) }
            }
        }
    }
    
    // MARK: - Action
    
    @objc private func applicationDidBecomeActive() {
        guard isWaitingForSystemSettings else { return }
        isWaitingForSystemSettings = false
        
        Task { [weak self] in
            guard let self else { return }
            let isAllowed = await permissionService.isPermissionAllowed()
            await MainActor.run {
                self.viewModel.action(.setAllNotifications(isEnabled: isAllowed))
            }
        }
    }
}
