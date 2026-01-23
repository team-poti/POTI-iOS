//
//  ReviewsAPI.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/23/26.
//

import Alamofire

enum ReviewsAPI: BaseTargetType {
    case createReview(transactionId: Int, rating: Int)
    
    var path: String {
        switch self {
        case .createReview:
            return "api/v1/reviews"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createReview:
            return .post
        }
    }
    
    var queryParameters: Parameters? {
        return nil
    }
    
    var bodyParameters: Parameters? {
        return nil
    }
}
