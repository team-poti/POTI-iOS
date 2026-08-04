//
//  CreatePostResponseDTO.swift
//  POTI-iOS
//
//  Created by soomin on 1/22/26.
//

struct CreatePostResponseDTO: Decodable {
    let postId: Int

    func toEntity() -> RegisterResponseEntity {
        RegisterResponseEntity(postId: postId)
    }
}
