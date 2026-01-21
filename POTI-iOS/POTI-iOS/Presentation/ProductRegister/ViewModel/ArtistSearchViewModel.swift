//
//  ArtistSearchViewModel.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/19/26.
//


import UIKit

import Combine

final class ArtistSearchViewModel: BaseViewModelType {

    // MARK: - Properties

    enum Input {
        case queryChanged(String)
        case tapDone
    }

    struct Output {
        let isDoneEnabled: AnyPublisher<Bool, Never>
        let didSubmitQuery: AnyPublisher<String, Never>
    }

    let output: Output
    
    private var currentQuery: String = ""

    private let isDoneEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    private let didSubmitQuerySubject = PassthroughSubject<String, Never>()

    // MARK: - Life Cycle

    init() {
        self.output = Output(
            isDoneEnabled: isDoneEnabledSubject.eraseToAnyPublisher(),
            didSubmitQuery: didSubmitQuerySubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Custom Method

    func action(_ trigger: Input) {
        switch trigger {
        case .queryChanged(let query):
            let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
            currentQuery = trimmed
            isDoneEnabledSubject.send(!trimmed.isEmpty)

        case .tapDone:
            guard !currentQuery.isEmpty else {
                isDoneEnabledSubject.send(false)
                return
            }
            didSubmitQuerySubject.send(currentQuery)
        }
    }
}
