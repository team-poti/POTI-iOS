//
//  RecruitPaymentsConfirmDTO.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

/// 모집자 - 입금 확인 버튼
struct RecruitPaymentsConfirmDTO: Decodable {
    let orderId: Int
    let status: String
    let confirmedAt: String
}
