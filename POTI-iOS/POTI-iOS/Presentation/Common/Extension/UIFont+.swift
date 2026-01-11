//
//  UIFont+.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/11/26.
//

import UIKit

extension UIFont {
    enum FontType: String {
        case bold = "Pretendard-Bold"
        case medium = "Pretendard-Medium"
        case semibold = "Pretendard-SemiBold"
        
        var name: String {
            return self.rawValue
        }
        
        static func font(_ type: FontType, ofsize size: CGFloat) -> UIFont {
            guard let font = UIFont(name: type.rawValue, size: size) else {
                return UIFont()
            }
            return font
        }
    }
}
