//
//  NotificationViewModel.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

import Combine

final class NotificationViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case didTapNotification(index: Int)
        case didTapReadAll
    }

    // MARK: - Output

    struct Output {
        let reloadData: AnyPublisher<Void, Never>
    }

    // MARK: - Properties

    private(set) var notifications: [NotificationItem]
    let output: Output

    var hasUnreadNotification: Bool {
        notifications.contains { !$0.isRead }
    }

    // MARK: - Subject

    private let reloadDataSubject = PassthroughSubject<Void, Never>()

    // MARK: - Initializer

    init(notifications: [NotificationItem] = []) {
        self.notifications = notifications
        self.output = Output(reloadData: reloadDataSubject.eraseToAnyPublisher())
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            reloadDataSubject.send(())
        case .didTapNotification(let index):
            readNotification(at: index)
        case .didTapReadAll:
            readAllNotifications()
        }
    }

    // MARK: - Private Methods

    private func readNotification(at index: Int) {
        guard notifications.indices.contains(index), !notifications[index].isRead else { return }
        notifications[index].isRead = true
        reloadDataSubject.send(())
    }

    private func readAllNotifications() {
        guard hasUnreadNotification else { return }
        for index in notifications.indices {
            notifications[index].isRead = true
        }
        reloadDataSubject.send(())
    }
}
