//
//  ImageUploadAPI.swift
//  POTI-iOS
//
//  Created by soomin on 8/12/26.
//

import Alamofire

enum ImageUploadAPI: BaseTargetType {
    case fetchPostPresignedUploads(fileExtensions: [String])
    case fetchProfilePresignedUpload(fileExtension: String)

    var path: String {
        "/api/v1/images/presigned-url"
    }

    var method: HTTPMethod {
        .get
    }

    var queryParameters: [String: String]? {
        switch self {
        case let .fetchPostPresignedUploads(fileExtensions):
            return ["type": "POST", "extensions": fileExtensions.joined(separator: ",")]
        case let .fetchProfilePresignedUpload(fileExtension):
            return ["type": "PROFILE", "extensions": fileExtension]
        }
    }
}
