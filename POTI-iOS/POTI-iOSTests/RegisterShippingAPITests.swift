//
//  RegisterShippingAPITests.swift
//  POTI-iOSTests
//
//  Created by Neon on 8/31/26.
//

import XCTest
@testable import POTI_iOS

final class RegisterShippingAPITests: XCTestCase {
    func testShippingOptionsTargetMatchesSwaggerContract() {
        let target = RegisterAPI.fetchShippingOptions

        XCTAssertEqual(target.path, "/api/v1/shippings")
        XCTAssertEqual(target.method.rawValue, "GET")
        XCTAssertNil(target.queryParameters)
        XCTAssertNil(target.bodyParameters)
    }

    func testShippingOptionsResponseMapsServerIdentifiersAndPrices() throws {
        let json = """
        [
          {"deliveryId": 7, "name": "우체국택배", "price": 4000},
          {"deliveryId": 9, "name": "준등기", "price": 1800}
        ]
        """

        let dto = try JSONDecoder().decode(
            [RegisterShippingOptionResponseDTO].self,
            from: Data(json.utf8)
        )
        let entities = dto.map { $0.toEntity() }

        XCTAssertEqual(
            entities,
            [
                .init(deliveryID: 7, name: "우체국택배", price: 4_000),
                .init(deliveryID: 9, name: "준등기", price: 1_800)
            ]
        )
    }
}
