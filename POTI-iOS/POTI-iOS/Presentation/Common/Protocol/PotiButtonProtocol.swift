//
//  PotiButtonProtocol.swift
//  POTI-iOS
//
//  Created by neon on 1/13/26.
//

import UIKit

public protocol PotiButtonProtocol {
    var isDisabled: Bool { get set }
    var text: String? { get set }
    var color: ColorType { get set }
}

public enum ColorType {
    case primaryMain
    case primarySub
    case secondaryMain
    case secondarySub
    case deactiveMain
    case deactivedSub
}

extension ColorType {
    
    var defaultBackgroundColor: UIColor {
        switch self {
        case .primaryMain:
            return .poti600
        case .primarySub:
            return .gray100
        case .secondaryMain:
            return .potiBlack
        case .secondarySub:
            return .gray100
        case .deactiveMain:
            return .gray700
        case .deactivedSub:
            return .gray100
        }
    }
    
    var pressedBackgroundColor: UIColor {
        switch self {
        case .primaryMain:
            return .poti800
        case .primarySub:
            return .gray300
        case .secondaryMain:
            return .gray900
        case .secondarySub:
            return .gray300
        case .deactiveMain:
            return .gray700
        case .deactivedSub:
            return .gray100
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .primaryMain, .secondaryMain, .deactiveMain:
            return .potiWhite
        case .primarySub:
            return .poti600
        case .secondarySub:
            return .gray900
        case .deactivedSub:
            return .gray700
        }
    }
}
