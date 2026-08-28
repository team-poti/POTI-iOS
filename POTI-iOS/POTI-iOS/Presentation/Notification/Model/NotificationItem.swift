//
//  NotificationItem.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

import Foundation

struct NotificationItem {
    let id: Int
    let title: String
    let content: String
    let time: String
    let type: String
    let deeplink: String?
    var isRead: Bool
}

extension NotificationEntity {
    func toNotificationItem(now: Date = Date()) -> NotificationItem {
        return NotificationItem(id: id, title: title, content: body, time: createdAt.toRelativeTime(now: now),
                                type: type, deeplink: deeplink, isRead: isRead)
    }
}
