//
//  StarRatingControlTests.swift
//  POTI-iOSTests
//
//  Created by Neon on 8/30/26.
//

import XCTest
@testable import POTI_iOS

@MainActor
final class StarRatingControlTests: XCTestCase {
    func testRatingIsClampedToSupportedRange() {
        let control = StarRatingControl()

        control.setRating(8)
        XCTAssertEqual(control.rating, 5)

        control.setRating(-1)
        XCTAssertEqual(control.rating, 0)
    }

    func testAccessibilityAdjustmentsChangeRating() {
        let control = StarRatingControl()

        control.accessibilityIncrement()
        XCTAssertEqual(control.rating, 1)
        XCTAssertEqual(control.accessibilityValue, "5점 중 1점")

        control.accessibilityDecrement()
        XCTAssertEqual(control.rating, 0)
    }
}
