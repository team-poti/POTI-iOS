//
//  ParticipantAPILayerTests.swift
//  POTI-iOSTests
//
//  Created by Neon on 8/30/26.
//

import XCTest
@testable import POTI_iOS

final class ParticipantAPILayerTests: XCTestCase {
    func testParticipantListTarget() {
        let target = OrderManagementAPI.fetchManage(postId: 182)

        XCTAssertEqual(target.path, "/api/v1/posts/182/participants")
        XCTAssertEqual(target.method.rawValue, "GET")
        XCTAssertNil(target.queryParameters)
        XCTAssertNil(target.bodyParameters)
    }

    func testPaymentConfirmationTarget() {
        let target = PaymentsAPI.patchPaymentConfirm(orderId: 42)

        XCTAssertEqual(target.path, "/api/v1/payments/42/confirm")
        XCTAssertEqual(target.method.rawValue, "PATCH")
        XCTAssertNil(target.bodyParameters)
    }

    func testTrackingNumberTarget() {
        let target = OrderManagementAPI.patchTrackingNumber(
            orderId: 42,
            request: TrackingNumberRequestDTO(
                carrier: "우체국",
                trackingNumber: "1234567890"
            )
        )

        XCTAssertEqual(target.path, "/api/v1/orders/42/deliveries")
        XCTAssertEqual(target.method.rawValue, "PATCH")
        XCTAssertEqual(target.bodyParameters?["carrier"] as? String, "우체국")
        XCTAssertEqual(
            target.bodyParameters?["trackingNumber"] as? String,
            "1234567890"
        )
    }

    func testManageResponseDecodesAndMapsEveryServerState() throws {
        let json = """
        {
          "participants": [
            {
              "orderId": 42,
              "userId": 7,
              "profileImage": null,
              "nickname": "neon",
              "memberNames": ["멤버"],
              "status": "PAID",
              "priceInfo": {
                "memberPerPrices": [{"name": "멤버", "price": 5000}],
                "shippingName": "준등기",
                "shippingPrice": 1800,
                "totalPrice": 6800
              },
              "depositInfo": null,
              "shippingInfo": {
                "receiverName": "네온",
                "address": "서울시 포티구",
                "phone": "010-0000-0000",
                "trackingNumber": null
              }
            }
          ]
        }
        """

        let dto = try JSONDecoder().decode(ManageDTO.self, from: Data(json.utf8))
        let entity = dto.toEntity()

        XCTAssertEqual(entity.participants.count, 1)
        XCTAssertEqual(entity.participants.first?.status, .paid)
        XCTAssertEqual(entity.participants.first?.orderId, 42)
    }

    func testUnknownServerStateIsNotSilentlyConvertedToWaitingForPayment() throws {
        let json = """
        {
          "participants": [
            {
              "orderId": 42,
              "userId": 7,
              "profileImage": null,
              "nickname": "neon",
              "memberNames": [],
              "status": "NEW_SERVER_STATE",
              "priceInfo": {
                "memberPerPrices": [],
                "shippingName": "",
                "shippingPrice": 0,
                "totalPrice": 0
              },
              "depositInfo": null,
              "shippingInfo": null
            }
          ]
        }
        """

        let dto = try JSONDecoder().decode(ManageDTO.self, from: Data(json.utf8))

        XCTAssertEqual(dto.toEntity().participants.first?.status, .unknown)
    }
}
