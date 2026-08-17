//
//  ImageOptimizer.swift
//  POTI-iOS
//
//  Created by soomin on 8/12/26.
//

import ImageIO
import UIKit

protocol ImageOptimizing: Sendable {
    func optimize(fileURL: URL) throws -> OptimizedImage
}

enum ImageOptimizationError: Error {
    case failedToCreateImageSource
    case failedToDownsample
    case failedToEncodeJPEG
}

struct ImageOptimizer: ImageOptimizing {
    private let maxPixelSize: Int
    private let compressionQuality: CGFloat

    init(maxPixelSize: Int = 1_600, compressionQuality: CGFloat = 0.8) {
        self.maxPixelSize = maxPixelSize
        self.compressionQuality = compressionQuality
    }

    func optimize(fileURL: URL) throws -> OptimizedImage {
        let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(fileURL as CFURL, sourceOptions) else {
            throw ImageOptimizationError.failedToCreateImageSource
        }

        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize
        ] as CFDictionary
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            throw ImageOptimizationError.failedToDownsample
        }

        guard let jpegData = UIImage(cgImage: cgImage).jpegData(compressionQuality: compressionQuality) else {
            throw ImageOptimizationError.failedToEncodeJPEG
        }
        return OptimizedImage(data: jpegData, fileExtension: "jpg", mimeType: "image/jpeg")
    }
}
