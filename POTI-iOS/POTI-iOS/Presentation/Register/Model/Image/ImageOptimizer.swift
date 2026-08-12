//
//  ImageOptimizer.swift
//  POTI-iOS
//
//  Created by soomin on 8/12/26.
//

import UIKit

protocol ImageOptimizing {
    func optimize(fileURL: URL) -> OptimizedImage?
}

struct ImageOptimizer: ImageOptimizing {
    func optimize(fileURL: URL) -> OptimizedImage? {
        guard let image = UIImage(contentsOfFile: fileURL.path), let jpegData = image.jpegData(compressionQuality: 0.8) else { return nil }
        return OptimizedImage(data: jpegData, fileExtension: "jpg", mimeType: "image/jpeg")
    }
}
