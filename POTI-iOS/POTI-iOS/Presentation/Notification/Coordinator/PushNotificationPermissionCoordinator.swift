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
    private var pendingPermissionAllowedAction: (() -> Void)?
    
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
    
    private func requestSystemPermission(whenPermissionAllowed: @escaping () -> Void) {
        Task { [weak self] in
            guard let self else { return }
            let result = await permissionService.requestPermissionOrOpenSettings()
            await handlePermissionResult(result, whenPermissionAllowed: whenPermissionAllowed)
        }
    }
    
    @MainActor
    private func handlePermissionResult(_ result: PushNotificationPermissionResult,
                                        whenPermissionAllowed: @escaping () -> Void) {
        switch result {
        case .granted:
            whenPermissionAllowed()
        case .denied:
            viewModel.action(.setAllNotifications(isEnabled: false))
        case .openedSettings:
            isWaitingForSystemSettings = true
            pendingPermissionAllowedAction = whenPermissionAllowed
            viewModel.action(.setAllNotifications(isEnabled: false))
        }
    }

    private func showPermissionModal(in view: UIView, whenPermissionAllowed: @escaping () -> Void) {
        let modalView = PushNotificationPermissionModalView()
        modalView.onTapAllow = { [weak self] in
            self?.requestSystemPermission(whenPermissionAllowed: whenPermissionAllowed)
        }
        modalView.onTapLater = { [weak self] in
            Task { @MainActor in
                self?.viewModel.action(.setAllNotifications(isEnabled: false))
            }
        }
        modalView.show(in: view)
    }

    // MARK: - Public Methods

    func showPermissionModal(in view: UIView) {
        showPermissionModal(in: view) { [weak self] in
            self?.viewModel.action(.setAllNotifications(isEnabled: true))
        }
    }
    
    func handleEnablingNotification(in view: UIView, whenPermissionAllowed: @escaping () -> Void) {
        Task { [weak self] in
            guard let self else { return }
            
            if await permissionService.isPermissionAllowed() {
                await MainActor.run { whenPermissionAllowed() }
            } else {
                await MainActor.run {
                    self.showPermissionModal(in: view, whenPermissionAllowed: whenPermissionAllowed)
                }
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
                if isAllowed {
                    self.pendingPermissionAllowedAction?()
                } else {
                    self.viewModel.action(.setAllNotifications(isEnabled: false))
                }
                self.pendingPermissionAllowedAction = nil
            }
        }
    }
}
