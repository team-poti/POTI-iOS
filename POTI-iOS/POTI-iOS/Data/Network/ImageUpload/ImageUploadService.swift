//
//  ImageUploadService.swift
//  POTI-iOS
//
//  Created by soomin on 8/12/26.
//

import Foundation

import Alamofire

protocol ImageUploadService {
    func fetchPostPresignedUploads(fileExtensions: [String]) async throws -> PresignedUploadsDTO
    func fetchProfilePresignedUpload(fileExtension: String) async throws -> PresignedUploadsDTO
    func uploadImage(data: Data, to url: URL, mimeType: String) async throws
}

final class DefaultImageUploadService: ImageUploadService {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchPostPresignedUploads(fileExtensions: [String]) async throws -> PresignedUploadsDTO {
        try await networkService.request(
            target: ImageUploadAPI.fetchPostPresignedUploads(fileExtensions: fileExtensions),
            type: PresignedUploadsDTO.self
        )
    }

    func fetchProfilePresignedUpload(fileExtension: String) async throws -> PresignedUploadsDTO {
        try await networkService.request(
            target: ImageUploadAPI.fetchProfilePresignedUpload(fileExtension: fileExtension),
            type: PresignedUploadsDTO.self
        )
    }

    func uploadImage(data: Data, to url: URL, mimeType: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            AF.upload(data, to: url, method: .put, headers: ["Content-Type": mimeType])
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        PotiLogger.error(error)
                        continuation.resume(throwing: PotiError.networkFail)
                    }
                }
        }
    }
}
