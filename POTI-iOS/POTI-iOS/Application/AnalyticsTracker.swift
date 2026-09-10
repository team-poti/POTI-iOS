//
//  AnalyticsTracker.swift
//  POTI-iOS
//

import Foundation

import Mixpanel

enum AnalyticsTracker {

    private static let userIDKey = "mixpanel.userID"
    private static let firstOpenKey = "mixpanel.hasOpened"
    private static var instance: MixpanelInstance?

    static func configure() {
        guard instance == nil else { return }

        do {
            let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "unknown"
            instance = Mixpanel.initialize(
                token: try AppConfig.mixpanelToken(),
                trackAutomaticEvents: false,
                superProperties: [
                    "platform": "ios",
                    "app_version": appVersion
                ]
            )

            if let userID = UserDefaults.standard.object(forKey: userIDKey) as? Int {
                identify(userID: userID)
            }
        } catch {
            PotiLogger.error(error)
        }
    }

    static func identify(userID: Int, isNewUser: Bool) {
        identify(userID: userID)

        if isNewUser {
            setUserProperties([
                "onboarding_completed": false,
                "signup_date": ISO8601DateFormatter().string(from: Date())
            ])
        }
    }

    static func completeOnboarding(favoriteGroupID: Int?) {
        var properties: Properties = ["onboarding_completed": true]
        properties["favorite_group_id"] = favoriteGroupID.map(String.init) ?? NSNull()
        setUserProperties(properties)
        track(
            "Onboarding Completed",
            properties: [
                "favorite_group_id": favoriteGroupID.map(String.init) ?? NSNull(),
                "skipped": favoriteGroupID == nil
            ]
        )
    }

    static func trackAppOpened(entryPoint: String) {
        let isFirstOpen = !UserDefaults.standard.bool(forKey: firstOpenKey)
        track(
            "App Opened",
            properties: [
                "entry_point": entryPoint,
                "is_first_open": isFirstOpen
            ]
        )
        UserDefaults.standard.set(true, forKey: firstOpenKey)
    }

    static func trackHomeViewed(favoriteGroupID: Int?) {
        var properties: Properties = [
            "content_type": favoriteGroupID == nil ? "all" : "favorite_group"
        ]
        properties["favorite_group_id"] = favoriteGroupID.map(String.init) ?? NSNull()
        setUserProperties(["favorite_group_id": favoriteGroupID.map(String.init) ?? NSNull()])
        track("Home Viewed", properties: properties)
    }

    static func trackSplitCardClicked(splitID: Int, groupID: Int, position: Int) {
        track(
            "Split Card Clicked",
            properties: [
                "split_id": String(splitID),
                "group_id": String(groupID),
                "position": position
            ]
        )
    }

    static func trackSearchPerformed(keyword: String, resultCount: Int) {
        track(
            "Search Performed",
            properties: [
                "keyword": keyword,
                "result_count": resultCount,
                "search_type": "goods"
            ]
        )
    }

    static func trackSearchResultClicked(keyword: String, resultID: Int?, position: Int) {
        var properties: Properties = [
            "keyword": keyword,
            "result_type": "goods",
            "position": position
        ]
        if let resultID {
            properties["result_id"] = String(resultID)
        }
        track("Search Result Clicked", properties: properties)
    }

    static func trackSplitDetailViewed(splitID: Int, groupID: Int, splitStatus: String) {
        track(
            "Split Detail Viewed",
            properties: [
                "split_id": String(splitID),
                "group_id": String(groupID),
                "split_status": splitStatus
            ]
        )
    }

    static func trackJoinButtonClicked(splitID: Int, splitStatus: String) {
        track(
            "Join Button Clicked",
            properties: [
                "split_id": String(splitID),
                "split_status": splitStatus
            ]
        )
    }

    static func trackParticipantInfoSubmitted(splitID: Int) {
        track("Participant Info Submitted", properties: ["split_id": String(splitID)])
    }

    static func reset() {
        UserDefaults.standard.removeObject(forKey: userIDKey)
        instance?.reset()
    }

    private static func identify(userID: Int) {
        guard let instance else { return }
        UserDefaults.standard.set(userID, forKey: userIDKey)
        instance.identify(distinctId: String(userID))
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "unknown"
        setUserProperties([
            "user_id": String(userID),
            "platform": "ios",
            "app_version": appVersion
        ])
    }

    private static func setUserProperties(_ properties: Properties) {
        instance?.people.set(properties: properties)
    }

    private static func track(_ event: String, properties: Properties) {
        instance?.track(event: event, properties: properties)
    }
}
