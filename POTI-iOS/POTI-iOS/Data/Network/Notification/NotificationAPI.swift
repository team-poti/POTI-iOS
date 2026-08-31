//
//  NotificationAPI.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

import Alamofire

enum NotificationAPI: BaseTargetType {
    case fetchNotifications(page: Int)
    case readNotification(notificationId: Int)
    case readAllNotifications
    case fetchSettings
    case updateSettings(tradeNotificationEnabled: Bool, eventNotificationEnabled: Bool)

    var path: String {
        switch self {
        case .fetchNotifications:
            return "/api/v1/notifications"
        case .readNotification(let notificationId):
            return "/api/v1/notifications/\(notificationId)/read"
        case .readAllNotifications:
            return "/api/v1/notifications/read-all"
        case .fetchSettings, .updateSettings:
            return "/api/v1/notifications/settings"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchNotifications, .fetchSettings:
            return .get
        case .readNotification, .readAllNotifications, .updateSettings:
            return .patch
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .fetchNotifications(let page):
            return ["page": "\(page)", "size": "20", "sort": "createdAt,desc"]
        default:
            return nil
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .updateSettings(let tradeNotificationEnabled, let eventNotificationEnabled):
            return [
                "tradeNotificationEnabled": tradeNotificationEnabled,
                "eventNotificationEnabled": eventNotificationEnabled
            ]
        default:
            return nil
        }
    }
}
