//
//  PaymentsConfirmDTO.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/22/26.
//

/// 모집자 - 입금 확인 버튼
struct PaymentsConfirmDTO: Decodable {
    let orderId: Int
    let status: String
    let confirmedAt: String
}
