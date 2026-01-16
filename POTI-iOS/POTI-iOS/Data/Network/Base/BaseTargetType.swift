//
//  BaseTargetType.swift
//  POTI-iOS
//
//  Created by neon on 1/14/26.
//

import Alamofire

enum HeaderType {
    case basic
    case authorization(String)
    
    var value: HTTPHeaders {
        switch self {
        case .basic:
            return ["Content-Type": "application/json"]
        case .authorization(let token):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
        }
    }
}

protocol BaseTargetType {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HeaderType { get }
    
    /// URL Query (?a=1) (GET)
    var queryParameters: [String: String]? { get }
    /// JSON Request Body (POST/PUT)
    var bodyParameters: Parameters? { get }
}

extension BaseTargetType {
    var queryParameters: [String: String]? { nil }
    var bodyParameters: Parameters? { nil }
}

