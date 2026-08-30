//
//  WithdrawalAPITests.swift
//  POTI-iOSTests
//
//  Created by Neon on 8/31/26.
//

import Alamofire
import XCTest
@testable import POTI_iOS

final class WithdrawalAPITests: XCTestCase {
    func testWithdrawalReasonsTargetMatchesSwaggerContract() {
        let target = AuthAPI.withdrawalReasons

        XCTAssertEqual(target.path, "/api/v1/auth/withdrawal/reasons")
        XCTAssertEqual(target.method, .get)
        XCTAssertNil(target.bodyParameters)
    }

    func testWithdrawalReasonResponseMapsToDomain() throws {
        let data = Data(#"{"code":"LOW_FREQUENCY","label":"이용 빈도가 낮아요."}"#.utf8)
        let dto = try JSONDecoder().decode(WithdrawalReasonResponseDTO.self, from: data)

        XCTAssertEqual(
            dto.toEntity(),
            WithdrawalReasonEntity(code: "LOW_FREQUENCY", label: "이용 빈도가 낮아요.")
        )
    }

    func testActiveTransactionErrorCodeMapsToWithdrawalBlocked() {
        let error = NetworkService().mapErrorCode(
            40019,
            message: "진행 중인 거래가 있어 탈퇴할 수 없습니다."
        )

        XCTAssertEqual(error, .withdrawalBlocked)
    }
}
