//
//  SortViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/17/26.
//

import Combine

final class SortViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case selectOption(index: Int)
    }
    
    // MARK: - Output
    
    struct Output {
        let options: AnyPublisher<[String], Never>
        let selectedIndex: AnyPublisher<Int, Never>
        let onSelect: AnyPublisher<Int, Never>
    }
    
    let output: Output
    var currentOptions: [String] {
        return optionsSubject.value
    }
    
    var currentSelectedIndex: Int {
        return selectedIndexSubject.value
    }
    
    // MARK: - Subjects
    
    private let optionsSubject = CurrentValueSubject<[String], Never>(["최신순", "마감임박순", "평점순"])
    private let selectedIndexSubject: CurrentValueSubject<Int, Never>
    private let onSelectSubject = PassthroughSubject<Int, Never>()
    
    init(initialIndex: Int) {
        self.selectedIndexSubject = .init(initialIndex)
        
        self.output = Output(
            options: optionsSubject.eraseToAnyPublisher(),
            selectedIndex: selectedIndexSubject.eraseToAnyPublisher(),
            onSelect: onSelectSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .selectOption(let index):
            selectedIndexSubject.send(index)
            self.onSelectSubject.send(index)
        }
    }
}
