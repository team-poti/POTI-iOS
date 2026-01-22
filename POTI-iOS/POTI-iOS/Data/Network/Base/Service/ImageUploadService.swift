//
//  ImageUploadService.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//


import UIKit
import Alamofire

protocol ImageUploadService {
    func getPresignedUrls(type: String, extensions: [String]) async throws -> PresignedUrlResponseDTO
    func uploadImage(image: UIImage, to presignedUrl: String) async throws
}

final class DefaultImageUploadService: ImageUploadService {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // 1. Presigned URL 받기
    func getPresignedUrls(type: String, extensions: [String]) async throws -> PresignedUrlResponseDTO {
        let dto = try await networkService.request(
            target: ImagesAPI.getPresignedUrls(type: type, extensions: extensions),
            type: PresignedUrlResponseDTO.self
        )
        return dto
    }
    
    // 2. 이미지를 S3에 업로드
    func uploadImage(image: UIImage, to presignedUrl: String) async throws {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw PotiError.badRequest
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(imageData, to: presignedUrl, method: .put, headers: [
                "Content-Type": "image/jpeg"
            ])
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    PotiLogger.debug("이미지 업로드 성공")
                    continuation.resume()
                case .failure(let error):
                    PotiLogger.error(error)
                    continuation.resume(throwing: PotiError.networkFail)
                }
            }
        }
    }
}
