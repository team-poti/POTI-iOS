//
//  ParticipantManageViewModel.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/16/26.
//

import Combine

final class ParticipantManageViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case toggleButtonTap(section: Int)
    }
    
    // MARK: - Output
    
    struct Output {
        let toggleButtonTapped: AnyPublisher<Int, Never>
    }
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    let output: Output
    private(set) var expandedSections: Set<Int> = [] // 섹션 펼침 여부
    private(set) var participants: [ParticipantManageModel] = []
    
    // MARK: - Subject
    
    private let toggleButtonSubject = PassthroughSubject<Int, Never>()
    
    // MARK: - Initializer
    
    init() {
        self.output = Output(
            toggleButtonTapped: toggleButtonSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
            //        case .toggleButtonTap(let section):
            //            toggleButtonSubject.send(section)
            
        case .toggleButtonTap(let section):
            toggleExpandSection(section: section)
        }
    }
    
    // MARK: - Private Method
    
    private func toggleExpandSection(section: Int) {
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
        toggleButtonSubject.send(section)
    }
    
    func setParticipants(_ participants: [ParticipantManageModel]) {
        self.participants = participants
    }
}
