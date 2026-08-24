//
//  ImagesInterface.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

import Foundation

protocol ImagesInterface {
    /// presigned URL 발급
    func fetchPresignedUrls(count: Int) async throws -> [PresignedUrlEntity]

    /// 프로필 이미지용 presigned URL 발급
    func fetchProfilePresignedUrl(fileExtension: String) async throws -> PresignedUrlEntity

    /// S3에 실제 업로드
    func uploadImage(data: Data, to url: URL) async throws
}
