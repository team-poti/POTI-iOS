//
//  NotificationEntity.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

struct NotificationEntity {
    let id: Int
    let title: String
    let body: String
    let type: String
    let deeplink: String?
    let isRead: Bool
    let createdAt: String
}

struct NotificationPageEntity {
    let notifications: [NotificationEntity]
    let currentPage: Int
    let hasNext: Bool
}
