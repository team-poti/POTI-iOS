//
//  DefaultReviewRepository.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

final class DefaultReviewsRepository: ReviewsInterface {

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func createReview(
        transactionId: Int,
        rating: Int
    ) async throws -> ReviewsEntity {

        let responseDTO = try await networkService.request(
            target: ReviewsAPI.createReview(transactionId: transactionId, rating: rating),
            type: ReviewResponseDTO.self
        )

        return responseDTO.toEntity()
    }
}
