//
//  RegisterResponseDTO.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/22/26.
//

import Foundation

struct RegisterResponseDTO: Decodable {

    let code: Int
    let message: String
    let data: DataDTO

    struct DataDTO: Decodable {
        let postId: Int
    }
}

// MARK: - Entity Mapping

extension RegisterResponseDTO {

    func toEntity() -> RegisterResponseEntity {
        return RegisterResponseEntity(postId: data.postId)
    }
}
