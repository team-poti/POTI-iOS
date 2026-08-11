//
//  RegisterPostResponseDTO.swift
//  POTI-iOS
//
//  Created by soomin on 1/22/26.
//

struct RegisterPostResponseDTO: Decodable {
    let postId: Int

    func toEntity() -> RegisterPostResultEntity {
        RegisterPostResultEntity(postId: postId)
    }
}
