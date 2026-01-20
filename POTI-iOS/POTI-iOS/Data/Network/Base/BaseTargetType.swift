//
//  BaseTargetType.swift
//  POTI-iOS
//
//  Created by neon on 1/14/26.
//

import Alamofire

protocol BaseTargetType {
    var path: String { get }
    var method: HTTPMethod { get }
    
    /// URL Query (?a=1) (GET)
    var queryParameters: [String: String]? { get }
    /// JSON Request Body (POST/PUT)
    var bodyParameters: Parameters? { get }
}

extension BaseTargetType {
    var headers: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
    var queryParameters: [String: String]? { nil }
    var bodyParameters: Parameters? { nil }
}

