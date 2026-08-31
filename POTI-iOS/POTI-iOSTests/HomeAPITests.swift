//
//  HomeAPITests.swift
//  POTI-iOSTests
//
//  Created by Neon on 8/31/26.
//

import XCTest
@testable import POTI_iOS

final class HomeAPITests: XCTestCase {
    func testGuestHomeResponseUsesPotiAsNicknameWhenServerReturnsNull() throws {
        let json = """
        {
          "nickname": null,
          "mainArtist": null,
          "mainArtistId": null,
          "myGroupItems": [],
          "otherGroupItems": [],
          "banners": []
        }
        """

        let dto = try JSONDecoder().decode(HomeDTO.self, from: Data(json.utf8))

        XCTAssertEqual(dto.toEntity().nickname, "포티")
    }

    func testAuthenticatedHomeResponsePreservesNickname() throws {
        let json = """
        {
          "nickname": "네온",
          "mainArtist": null,
          "mainArtistId": null,
          "myGroupItems": [],
          "otherGroupItems": [],
          "banners": []
        }
        """

        let dto = try JSONDecoder().decode(HomeDTO.self, from: Data(json.utf8))

        XCTAssertEqual(dto.toEntity().nickname, "네온")
    }
}
