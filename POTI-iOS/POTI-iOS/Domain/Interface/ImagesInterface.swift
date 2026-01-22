//
//  ImagesInterface.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

import UIKit

protocol ImagesInterface {
    func uploadImages(images: [UIImage]) async throws -> [String]
}
