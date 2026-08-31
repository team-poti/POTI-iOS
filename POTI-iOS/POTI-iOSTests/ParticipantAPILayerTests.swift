//
//  ParticipantAPILayerTests.swift
//  POTI-iOSTests
//
//  Created by Neon on 8/30/26.
//

import XCTest
@testable import POTI_iOS

final class ParticipantAPILayerTests: XCTestCase {
    func testParticipationDeliveredTargetMatchesSwaggerContract() {
        let target = ParticipationAPI.patchParticipationDelivered(participationId: 193)

        XCTAssertEqual(target.path, "/api/v1/participations/193/delivered")
        XCTAssertEqual(target.method.rawValue, "PATCH")
        XCTAssertNil(target.bodyParameters)
    }

    func testParticipationDeliveredResponsePreservesReviewTargetUserId() throws {
        let json = #"{"leaderUserId":77}"#

        let dto = try JSONDecoder().decode(
            ParticipationDeliverResponseDTO.self,
            from: Data(json.utf8)
        )

        XCTAssertEqual(dto.toEntity().leaderUserId, 77)
    }

    func testReviewTargetProfileUsesDeliveredLeaderUserId() {
        let delivered = ParticipationDeliveredEntity(leaderUserId: 77)
        let target = UsersAPI.fetchYourPageInformation(userId: delivered.leaderUserId)

        XCTAssertEqual(target.path, "/api/v1/users/77/profile")
        XCTAssertEqual(target.method.rawValue, "GET")
        XCTAssertNil(target.queryParameters)
        XCTAssertNil(target.bodyParameters)
    }

    func testReviewTargetProfileDecodesCurrentServerResponse() throws {
        let json = """
        {
          "userId": 61,
          "nickname": "히하",
          "profileImageUrl": "https://example.com/profile.png",
          "ratingAvg": 0.0,
          "activityMessage": "최근 3일 이내 활동",
          "joinedAt": "2026-08-25",
          "participationSummary": {
            "inProgress": 0,
            "completed": 0
          },
          "recruitSummary": {
            "inProgress": 0,
            "completed": 1
          }
        }
        """

        let dto = try JSONDecoder().decode(YourPageResponseDTO.self, from: Data(json.utf8))
        let entity = dto.toEntity()

        XCTAssertEqual(entity.userId, 61)
        XCTAssertEqual(entity.nickname, "히하")
        XCTAssertEqual(entity.profileImageUrl, "https://example.com/profile.png")
        XCTAssertEqual(entity.ratingAvg, 0.0)
        XCTAssertEqual(entity.recruitSummary.total, 1)
        XCTAssertFalse(entity.hasFavoriteArtist)
    }

    func testParticipationRequestUsesCurrentSwaggerAddressFields() throws {
        let entity = ParticipationEntity(
            postId: 182,
            shippingId: 3,
            receiverName: "네온",
            zipcode: "06000",
            address: "서울시 포티구",
            addressDetail: "193호",
            phone: "010-0000-0000",
            items: [.init(optionId: 7, count: 1)]
        )
        let target = ParticipationAPI.applyParticipation(
            request: ParticipationRequestDTO(from: entity)
        )
        let deliveryInfo = try XCTUnwrap(target.bodyParameters?["deliveryInfo"] as? [String: Any])

        XCTAssertEqual(deliveryInfo["address"] as? String, "서울시 포티구")
        XCTAssertEqual(deliveryInfo["addressDetail"] as? String, "193호")
        XCTAssertNil(deliveryInfo["addressLine"])
    }

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

    func testDeliveredParticipantDecodesNullableShippingRecipientFields() throws {
        let json = """
        {
          "participants": [
            {
              "orderId": 648,
              "userId": 59,
              "profileImage": "https://example.com/profile.jpg",
              "nickname": "아오오니임",
              "memberNames": ["안유진"],
              "status": "DELIVERED",
              "priceInfo": {
                "memberPerPrices": [{"name": "안유진", "price": 10}],
                "shippingName": "준등기",
                "shippingPrice": 1800,
                "totalPrice": 4010
              },
              "depositInfo": {
                "depositorName": "니아",
                "depositTime": "24-12-10 10:32"
              },
              "shippingInfo": {
                "receiverName": null,
                "address": null,
                "phone": null,
                "trackingNumber": "1212"
              }
            }
          ]
        }
        """

        let dto = try JSONDecoder().decode(ManageDTO.self, from: Data(json.utf8))
        let participant = try XCTUnwrap(dto.toEntity().participants.first)

        XCTAssertEqual(participant.status, .delivered)
        XCTAssertEqual(participant.shippingInfo?.receiverName, "")
        XCTAssertEqual(participant.shippingInfo?.address, "")
        XCTAssertEqual(participant.shippingInfo?.phone, "")
        XCTAssertEqual(participant.shippingInfo?.trackingNumber, "1212")
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
