//
//  PotiFontManager.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/11/26.
//

import UIKit

public struct FontProperty {
    let font: UIFont.FontType
    let size: CGFloat
    let lineHeight: CGFloat
}

public enum PotiFontManager {
    case display20b
    case display18b
    
    case title18sb
    
    case body16sb
    case body16m
    case body14sb
    case body14m
    
    case caption12m
    case caption10m
    case button16sb
    case button14sb

    public var fontProperty: FontProperty {
        switch self {
        case .display20b:
            return FontProperty(font: .bold, size: 20, lineHeight: 20 * 1.4)
        case .display18b:
            return FontProperty(font: .bold, size: 18, lineHeight: 18 * 1.4)
        case .title18sb:
            return FontProperty(font: .semibold, size: 18, lineHeight: 18 * 1.4)
        case .body16sb:
            return FontProperty(font: .semibold, size: 16, lineHeight: 16 * 1.5)
        case .body16m:
            return FontProperty(font: .medium, size: 16, lineHeight: 16 * 1.5)
        case .body14sb:
            return FontProperty(font: .semibold, size: 14, lineHeight: 14 * 1.5)
        case .body14m:
            return FontProperty(font: .medium, size: 14, lineHeight: 14 * 1.5)
        case .caption12m:
            return FontProperty(font: .medium, size: 12, lineHeight: 12 * 1.5)
        case .caption10m:
            return FontProperty(font: .medium, size: 10, lineHeight: 10 * 1.5)
        case .button16sb:
            return FontProperty(font: .semibold, size: 16, lineHeight: 16 * 1.5)
        case .button14sb:
            return FontProperty(font: .semibold, size: 14, lineHeight: 14 * 1.5)
        }
    }
}

public extension PotiFontManager {
    var font: UIFont {
        guard let font = UIFont(name: fontProperty.font.name, size: fontProperty.size) else {
            return UIFont()
        }
        return font
    }
}
