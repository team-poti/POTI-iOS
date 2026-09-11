//
//  AnalyticsTrackerTests.swift
//  POTI-iOSTests
//

import Mixpanel
import XCTest
@testable import POTI_iOS

final class AnalyticsTrackerTests: XCTestCase {

    func testResetRestoresCommonEventPropertiesAfterAccountSwitch() {
        let session = MockAnalyticsSession()

        AnalyticsTracker.reset(using: session)

        XCTAssertEqual(session.resetCallCount, 1)
        XCTAssertEqual(session.registeredProperties?["platform"] as? String, "ios")
        XCTAssertNotNil(session.registeredProperties?["app_version"] as? String)
    }
}

private final class MockAnalyticsSession: AnalyticsSession {
    private(set) var resetCallCount = 0
    private(set) var registeredProperties: Properties?

    func reset(completion: (() -> Void)?) {
        resetCallCount += 1
        completion?()
    }

    func registerSuperProperties(_ properties: Properties) {
        registeredProperties = properties
    }
}
