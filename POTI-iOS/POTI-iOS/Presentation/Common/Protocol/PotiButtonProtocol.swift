//
//  PotiButtonProtocol.swift
//  POTI-iOS
//
//  Created by neon on 1/13/26.
//

import Foundation

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
