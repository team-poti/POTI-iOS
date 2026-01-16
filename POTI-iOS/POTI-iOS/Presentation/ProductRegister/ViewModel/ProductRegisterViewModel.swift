//
//  ProductRegisterViewModel.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/16/26.
//

import UIKit

import Combine

final class ProductRegisterViewModel: BaseViewModelType {
    
    enum Input {
        case none
    }

    struct Output {
        let none: AnyPublisher<Void, Never>
    }

    let output: Output

    let imagePickerViewModel: ImagePickerViewModel

    init() {
        self.imagePickerViewModel = ImagePickerViewModel(maxCount: 5)
        self.output = Output(none: Empty().eraseToAnyPublisher())
    }

    func action(_ trigger: Input) {
        // no-op
    }
}
