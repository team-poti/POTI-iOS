//
//  ReviewsAPITests.swift
//  POTI-iOSTests
//
//  Created by Neon on 8/30/26.
//

import Alamofire
import XCTest
@testable import POTI_iOS

final class ReviewsAPITests: XCTestCase {
    func testCreateReviewMatchesSwaggerContract() {
        let target = ReviewsAPI.createReview(transactionId: 193, rating: 5)

        XCTAssertEqual(target.path, "api/v1/reviews")
        XCTAssertEqual(target.method, .post)
        XCTAssertEqual(target.bodyParameters?["transactionId"] as? Int, 193)
        XCTAssertEqual(target.bodyParameters?["star"] as? Int, 5)
        XCTAssertNil(target.bodyParameters?["rating"])
    }
}
