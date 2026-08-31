//
//  WithdrawalReasonResponseDTO.swift
//  POTI-iOS
//
//  Created by Neon on 8/31/26.
//

struct WithdrawalReasonResponseDTO: Decodable {
    let code: String
    let label: String

    func toEntity() -> WithdrawalReasonEntity {
        WithdrawalReasonEntity(code: code, label: label)
    }
}
