//
//  Identifiable.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/15/26.
//

import Foundation

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
