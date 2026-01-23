//
//  ReviewsUseCase.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

protocol ReviewUseCase {
    func execute(transactionId: Int, rating: Int) async throws -> ReviewsEntity
}

final class DefaultReviewUseCase: ReviewUseCase {
    private let repository: ReviewsInterface

    init(repository: ReviewsInterface) {
        self.repository = repository
    }

    func execute(transactionId: Int, rating: Int) async throws -> ReviewsEntity {
        try await repository.createReview(transactionId: transactionId, rating: rating)
    }
}
