//
//  AuthenticationRequirementTests.swift
//  POTI-iOSTests
//
//  Created by Neon on 8/31/26.
//

import XCTest
@testable import POTI_iOS

@MainActor
final class AuthenticationRequirementTests: XCTestCase {
    func testProtectedActionsUseContextSpecificLoginMessages() {
        XCTAssertEqual(LoginRequiredAction.register.message, "분철을 등록하려면 로그인이 필요해요")
        XCTAssertEqual(LoginRequiredAction.participate.message, "분철에 참여하려면 로그인이 필요해요")
        XCTAssertEqual(LoginRequiredAction.history.message, "분철 내역을 확인하려면 로그인이 필요해요")
    }

    func testMyPageCanRenderGuestModeWithoutUserData() {
        let view = MyPageView()

        view.setGuestMode(true)

        XCTAssertFalse(view.guestView.isHidden)
        XCTAssertEqual(view.guestView.loginButton.configuration?.title, "로그인")
    }
}
