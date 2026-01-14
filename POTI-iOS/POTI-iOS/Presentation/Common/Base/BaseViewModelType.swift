//
//  BaseViewModelType.swift
//  POTI-iOS
//
//  Created by neon on 1/14/26.
//

import Combine

public protocol BaseViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
