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
        /// 완료 버튼 활성화 상태
        let isDoneEnabled: AnyPublisher<Bool, Never>

        /// 완료 버튼 탭 시 확정된 검색어
        let didSubmitQuery: AnyPublisher<String, Never>
    }

    let output: Output

    private var currentQuery: String = ""

    private let isDoneEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    private let didSubmitQuerySubject = PassthroughSubject<String, Never>()


    // MARK: - UI Components


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


    // MARK: - Action Method


    // MARK: - delegate Method

}
