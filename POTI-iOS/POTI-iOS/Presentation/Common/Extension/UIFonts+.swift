//
//  UIFonts+.swift
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
            return UIFont(name: type.rawValue, size: size)!
        }
    }
    
    static let display_20b = FontManager.display20b.font
    static let display_18b = FontManager.display18b.font
    static let title_18sb  = FontManager.title18sb.font
    static let body_16sb   = FontManager.body16sb.font
    static let body_16m    = FontManager.body16m.font
    static let body_14sb   = FontManager.body14sb.font
    static let body_14m    = FontManager.body14m.font
    static let caption_12m = FontManager.caption12m.font
    static let caption_10m = FontManager.caption10m.font
    static let button_16sb = FontManager.button16sb.font
    static let button_14sb = FontManager.button14sb.font
}
