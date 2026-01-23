//
//  ReviewsInterface.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

protocol ReviewsInterface {
    func createReview(transactionId: Int, rating: Int) async throws -> ReviewsEntity
}
