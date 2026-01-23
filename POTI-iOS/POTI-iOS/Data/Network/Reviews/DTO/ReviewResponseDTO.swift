//
//  ReviewResponseDTO.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

struct ReviewResponseDTO: Decodable {
    let reviewId: Int
}

extension ReviewResponseDTO {
    func toEntity() -> ReviewsEntity {
        return ReviewsEntity(reviewId: reviewId)
    }
}
