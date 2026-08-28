//
//  NotificationSettingViewModel.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

import Combine

final class NotificationSettingViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case didToggleTradeNotification
        case didToggleEventNotification
        case setAllNotifications(isEnabled: Bool)
    }

    // MARK: - Output

    struct Output {
        let reloadData: AnyPublisher<Void, Never>
    }

    // MARK: - Properties

    private let fetchNotificationSettingsUseCase: FetchNotificationSettingsUseCase
    private let updateNotificationSettingsUseCase: UpdateNotificationSettingsUseCase
    private var isUpdating = false

    private(set) var isTradeNotificationOn = false
    private(set) var isEventNotificationOn = false
    let output: Output

    // MARK: - Subject

    private let reloadDataSubject = PassthroughSubject<Void, Never>()

    // MARK: - Initializer

    init(fetchNotificationSettingsUseCase: FetchNotificationSettingsUseCase,
         updateNotificationSettingsUseCase: UpdateNotificationSettingsUseCase) {
        self.fetchNotificationSettingsUseCase = fetchNotificationSettingsUseCase
        self.updateNotificationSettingsUseCase = updateNotificationSettingsUseCase
        self.output = Output(reloadData: reloadDataSubject.eraseToAnyPublisher())
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchSettings()
        case .didToggleTradeNotification:
            updateSettings(tradeNotificationEnabled: !isTradeNotificationOn, eventNotificationEnabled: isEventNotificationOn)
        case .didToggleEventNotification:
            updateSettings(tradeNotificationEnabled: isTradeNotificationOn, eventNotificationEnabled: !isEventNotificationOn)
        case .setAllNotifications(let isEnabled):
            updateSettings(tradeNotificationEnabled: isEnabled, eventNotificationEnabled: isEnabled)
        }
    }

    // MARK: - Private Methods

    private func fetchSettings() {
        Task { [weak self] in
            guard let self else { return }

            do {
                let settings = try await fetchNotificationSettingsUseCase.execute()
                apply(settings)
            } catch {
                PotiLogger.error(error)
            }
        }
    }

    private func updateSettings(tradeNotificationEnabled: Bool, eventNotificationEnabled: Bool) {
        guard !isUpdating else {
            reloadDataSubject.send(())
            return
        }
        isUpdating = true

        Task { [weak self] in
            guard let self else { return }
            defer { isUpdating = false }

            do {
                let settings = try await updateNotificationSettingsUseCase.execute(tradeNotificationEnabled: tradeNotificationEnabled,
                                                                                   eventNotificationEnabled: eventNotificationEnabled)
                apply(settings)
            } catch {
                reloadDataSubject.send(())
                PotiLogger.error(error)
            }
        }
    }

    private func apply(_ settings: NotificationSettingsEntity) {
        isTradeNotificationOn = settings.isTradeNotificationEnabled
        isEventNotificationOn = settings.isEventNotificationEnabled
        reloadDataSubject.send(())
    }
}
