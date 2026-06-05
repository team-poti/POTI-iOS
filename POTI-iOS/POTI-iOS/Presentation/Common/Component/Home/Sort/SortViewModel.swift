//
//  SortViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/17/26.
//

import Combine

enum SortType {
    case feeds
    case pot
    
    var options: [String] {
        switch self {
        case .feeds: return ["최신순", "인기순"]
        case .pot:   return ["최신순", "마감임박순", "평점순"]
        }
    }
}

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
    
    // MARK: - Properties
    
    let output: Output
    private let sortType: SortType
    
    // MARK: - Subjects
    
    private let optionsSubject: CurrentValueSubject<[String], Never>
    private let selectedIndexSubject: CurrentValueSubject<Int, Never>
    private let onSelectSubject = PassthroughSubject<Int, Never>()
    
    var currentOptions: [String] {
        return optionsSubject.value
    }
    
    var currentSelectedIndex: Int {
        return selectedIndexSubject.value
    }
    
    // MARK: - Initializer
    
    init(type: SortType, initialIndex: Int) {
        self.sortType = type
        
        let initialOptions = type.options
        self.optionsSubject = CurrentValueSubject<[String], Never>(initialOptions)
        self.selectedIndexSubject = CurrentValueSubject<Int, Never>(initialIndex)
        
        self.output = Output(
            options: optionsSubject.eraseToAnyPublisher(),
            selectedIndex: selectedIndexSubject.eraseToAnyPublisher(),
            onSelect: onSelectSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Methods
    
    func getSortString(for index: Int) -> String {
        switch sortType {
        case .feeds:
            switch index {
            case 0:
                return "LATEST"
            case 1:
                return "HOT"
            default:
                return "LATEST"
            }
        case .pot:
            switch index {
            case 0:
                return "LATEST"
            case 1:
                return "DEADLINE"
            default:
                return "RATING"
            }
        }
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .selectOption(let index):
            selectedIndexSubject.send(index)
            self.onSelectSubject.send(index)
        }
    }
}
