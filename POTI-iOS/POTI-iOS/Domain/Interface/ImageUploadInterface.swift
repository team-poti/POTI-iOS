//
//  ImageUploadInterface.swift
//  POTI-iOS
//
//  Created by soomin on 8/12/26.
//

import Foundation

protocol ImageUploadInterface {
    func fetchPresignedURLs(fileExtensions: [String]) async throws -> [PresignedUploadEntity]
    func uploadImage(data: Data, to url: URL, mimeType: String) async throws
}
