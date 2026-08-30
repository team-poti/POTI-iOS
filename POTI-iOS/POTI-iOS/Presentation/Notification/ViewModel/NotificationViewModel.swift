//
//  NotificationViewModel.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

import Combine

@MainActor
final class NotificationViewModel: @MainActor BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case loadNextPage
        case didTapNotification(index: Int)
        case didTapReadAll
    }

    // MARK: - Output

    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let deepLink: AnyPublisher<String, Never>
    }

    // MARK: - Properties

    private let fetchNotificationsUseCase: FetchNotificationsUseCase
    private let readNotificationUseCase: ReadNotificationUseCase
    private let readAllNotificationsUseCase: ReadAllNotificationsUseCase

    private(set) var notifications: [NotificationItem] = []
    private var currentPage = 0
    private var hasNextPage = true
    private var isFetching = false
    private var isReadingAll = false

    let output: Output

    var hasUnreadNotification: Bool {
        notifications.contains { !$0.isRead }
    }

    // MARK: - Subject

    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    private let deepLinkSubject = PassthroughSubject<String, Never>()

    // MARK: - Initializer

    init(fetchNotificationsUseCase: FetchNotificationsUseCase, readNotificationUseCase: ReadNotificationUseCase,
         readAllNotificationsUseCase: ReadAllNotificationsUseCase) {
        self.fetchNotificationsUseCase = fetchNotificationsUseCase
        self.readNotificationUseCase = readNotificationUseCase
        self.readAllNotificationsUseCase = readAllNotificationsUseCase
        self.output = Output(reloadData: reloadDataSubject.eraseToAnyPublisher(), deepLink: deepLinkSubject.eraseToAnyPublisher())
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchNotifications(isFirstPage: true)
        case .loadNextPage:
            fetchNotifications(isFirstPage: false)
        case .didTapNotification(let index):
            readNotification(at: index)
        case .didTapReadAll:
            readAllNotifications()
        }
    }

    // MARK: - Private Methods

    private func fetchNotifications(isFirstPage: Bool) {
        guard !isFetching && (isFirstPage || hasNextPage) else { return }

        isFetching = true
        let requestedPage = isFirstPage ? 0 : currentPage

        Task { [weak self] in
            guard let self else { return }
            defer { isFetching = false }

            do {
                let page = try await fetchNotificationsUseCase.execute(page: requestedPage)
                let newItems = page.notifications.map { $0.toNotificationItem() }

                if isFirstPage {
                    notifications = newItems
                } else {
                    notifications.append(contentsOf: newItems)
                }

                currentPage = page.currentPage + 1
                hasNextPage = page.hasNext
                reloadDataSubject.send(())
            } catch {
                PotiLogger.error(error)
            }
        }
    }

    private func readNotification(at index: Int) {
        guard notifications.indices.contains(index) else { return }

        let notification = notifications[index]
        sendDeepLinkIfNeeded(notification.deeplink)
        guard !notification.isRead else { return }

        Task { [weak self] in
            guard let self else { return }

            do {
                try await readNotificationUseCase.execute(notificationId: notification.id)
                guard let updatedIndex = notifications.firstIndex(where: { $0.id == notification.id }) else { return }
                notifications[updatedIndex].isRead = true
                reloadDataSubject.send(())
            } catch {
                PotiLogger.error(error)
            }
        }
    }

    private func sendDeepLinkIfNeeded(_ deepLink: String?) {
        guard let deepLink, !deepLink.isBlank else { return }
        deepLinkSubject.send(deepLink)
    }

    private func readAllNotifications() {
        guard hasUnreadNotification, !isReadingAll else { return }
        isReadingAll = true

        Task { [weak self] in
            guard let self else { return }
            defer { isReadingAll = false }

            do {
                try await readAllNotificationsUseCase.execute()
                for index in notifications.indices {
                    notifications[index].isRead = true
                }
                reloadDataSubject.send(())
            } catch {
                PotiLogger.error(error)
            }
        }
    }
}
