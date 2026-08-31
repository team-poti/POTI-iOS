//
//  PushNotificationPermissionCoordinator.swift
//  POTI-iOS
//
//  Created by soomin on 8/28/26.
//

import UIKit
import UserNotifications

@MainActor
final class PushNotificationPermissionCoordinator {

    // MARK: - Properties

    private let viewModel: NotificationSettingViewModel
    private let permissionService: PushNotificationPermissionService
    private let fetchNotificationSettingsUseCase: FetchNotificationSettingsUseCase
    private var isWaitingForSystemSettings = false
    private var pendingPermissionAllowedAction: (() -> Void)?
    private var didEvaluateCurrentSession = false
    private var isEvaluating = false
    private var isModalPresented = false

    // MARK: - Initializer

    init(viewModel: NotificationSettingViewModel, permissionService: PushNotificationPermissionService,
         fetchNotificationSettingsUseCase: FetchNotificationSettingsUseCase) {
        self.viewModel = viewModel
        self.permissionService = permissionService
        self.fetchNotificationSettingsUseCase = fetchNotificationSettingsUseCase

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
            handlePermissionResult(result, whenPermissionAllowed: whenPermissionAllowed)
        }
    }

    private func handlePermissionResult(_ result: PushNotificationPermissionResult,
                                        whenPermissionAllowed: @escaping () -> Void) {
        switch result {
        case .granted:
            whenPermissionAllowed()
        case .denied:
            break
        case .openedSettings:
            isWaitingForSystemSettings = true
            pendingPermissionAllowedAction = whenPermissionAllowed
        }
    }

    private func showPermissionModal(in view: UIView, onAllow: @escaping () -> Void) {
        guard !isModalPresented else { return }
        isModalPresented = true

        let modalView = PushNotificationPermissionModalView()
        modalView.onTapAllow = { [weak self] in
            self?.isModalPresented = false
            onAllow()
        }
        modalView.onTapLater = { [weak self] in
            self?.isModalPresented = false
        }
        modalView.show(in: view)
    }

    private func handlePermissionModalAllow(systemPermissionAllowed: Bool, serverPermissionAllowed: Bool) {
        let enableServerNotificationIfNeeded = { [weak self] in
            guard !serverPermissionAllowed else { return }
            self?.viewModel.action(.setAllNotifications(isEnabled: true))
        }

        if systemPermissionAllowed {
            enableServerNotificationIfNeeded()
        } else {
            requestSystemPermission(whenPermissionAllowed: enableServerNotificationIfNeeded)
        }
    }

    private func restartEvaluationIfNeeded(in view: UIView) {
        isEvaluating = false
        didEvaluateCurrentSession = false
        evaluatePermissionIfNeeded(in: view)
    }

    private static func isPermissionAllowed(_ status: UNAuthorizationStatus) -> Bool {
        switch status {
        case .authorized, .provisional, .ephemeral:
            return true
        default:
            return false
        }
    }

    // MARK: - Public Methods

    func evaluatePermissionIfNeeded(in view: UIView) {
        guard let sessionToken = KeychainManager.getAccessToken() else {
            didEvaluateCurrentSession = false
            isEvaluating = false
            return
        }

        guard !didEvaluateCurrentSession, !isEvaluating else { return }
        isEvaluating = true

        Task { [weak self] in
            guard let self else { return }

            do {
                let status = await permissionService.authorizationStatus()
                guard sessionToken == KeychainManager.getAccessToken() else {
                    restartEvaluationIfNeeded(in: view)
                    return
                }

                let settings = try await fetchNotificationSettingsUseCase.execute()
                guard sessionToken == KeychainManager.getAccessToken() else {
                    restartEvaluationIfNeeded(in: view)
                    return
                }

                let systemPermissionAllowed = Self.isPermissionAllowed(status)
                let serverPermissionAllowed = settings.isTradeNotificationEnabled || settings.isEventNotificationEnabled

                isEvaluating = false
                didEvaluateCurrentSession = true

                guard !systemPermissionAllowed || !serverPermissionAllowed else { return }
                showPermissionModal(in: view) { [weak self] in
                    self?.handlePermissionModalAllow(systemPermissionAllowed: systemPermissionAllowed,
                                                     serverPermissionAllowed: serverPermissionAllowed)
                }
            } catch {
                isEvaluating = false
                PotiLogger.error(error)
            }
        }
    }

    func handleEnablingNotification(in view: UIView, whenPermissionAllowed: @escaping () -> Void) {
        Task { [weak self] in
            guard let self else { return }

            if await permissionService.isPermissionAllowed() {
                whenPermissionAllowed()
            } else {
                showPermissionModal(in: view) { [weak self] in
                    self?.requestSystemPermission(whenPermissionAllowed: whenPermissionAllowed)
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
            if isAllowed {
                pendingPermissionAllowedAction?()
            }
            pendingPermissionAllowedAction = nil
        }
    }
}
