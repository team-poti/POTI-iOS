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

    private(set) var isTradeNotificationOn: Bool
    private(set) var isEventNotificationOn: Bool
    let output: Output

    // MARK: - Subject

    private let reloadDataSubject = PassthroughSubject<Void, Never>()

    // MARK: - Initializer

    init(isTradeNotificationOn: Bool = false, isEventNotificationOn: Bool = false) {
        self.isTradeNotificationOn = isTradeNotificationOn
        self.isEventNotificationOn = isEventNotificationOn
        self.output = Output(reloadData: reloadDataSubject.eraseToAnyPublisher())
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            reloadDataSubject.send(())
        case .didToggleTradeNotification:
            isTradeNotificationOn.toggle()
            reloadDataSubject.send(())
        case .didToggleEventNotification:
            isEventNotificationOn.toggle()
            reloadDataSubject.send(())
        case .setAllNotifications(let isEnabled):
            isTradeNotificationOn = isEnabled
            isEventNotificationOn = isEnabled
            reloadDataSubject.send(())
        }
    }
}
