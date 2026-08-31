//
//  NotificationResponseDTO.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

struct NotificationResponseDTO: Decodable {
    let content: [NotificationDTO]
    let hasNext: Bool

    func toEntity(currentPage: Int) -> NotificationPageEntity {
        return NotificationPageEntity(notifications: content.map { $0.toEntity() }, currentPage: currentPage, hasNext: hasNext)
    }
}

struct NotificationDTO: Decodable {
    let id: Int
    let title: String?
    let body: String
    let type: String
    let deeplink: String?
    let read: Bool
    let createdAt: String

    func toEntity() -> NotificationEntity {
        return NotificationEntity(id: id, title: title ?? "", body: body, type: type,
                                  deeplink: deeplink, isRead: read, createdAt: createdAt)
    }
}
