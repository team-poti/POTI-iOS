//
//  UIImage+.swift
//  POTI-iOS
//
//  Created by neon on 1/13/26.
//

import UIKit

extension UIImage {
    static func fromUIColor(color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        return renderer.image { ctx in
            color.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }
}
