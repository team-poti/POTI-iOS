//
//  NotificationItem.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

struct NotificationItem {
    let title: String
    let content: String
    let time: String
    var isRead: Bool
}

extension NotificationItem {
    static let mockData: [NotificationItem] = [
        NotificationItem(
            title: "배송 시작",
            content: "아이브 메이크스타 거래건 배송이 시작되었어요",
            time: "3시간 전",
            isRead: false
        ),
        NotificationItem(
            title: "배송 시작",
            content: "아이브 메이크스타 거래건 배송이 시작되었어요",
            time: "3시간 전",
            isRead: true
        ),
        NotificationItem(
            title: "배송 시작",
            content: "아이브 메이크스타 거래건 배송이 시작되었어요",
            time: "3시간 전",
            isRead: true
        ),
        NotificationItem(
            title: "배송 시작",
            content: "아이브 메이크스타 거래건 배송이 시작되었어요",
            time: "3시간 전",
            isRead: true
        )
    ]
}
