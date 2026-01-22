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
        case viewDidLoad
        case toggleButtonTap(section: Int)
        case confirmDeposit(purchaseId: Int)
        case confirmShip(purchaseId: Int)
    }
    
    // MARK: - Output
    
    struct Output {
        let fetchData: AnyPublisher<Void, Never>
        let toggleButtonTapped: AnyPublisher<Int, Never>
        let confirmDepositTriggered: AnyPublisher<Int, Never>
        let confirmShipTriggered: AnyPublisher<Int, Never>
        let showError: AnyPublisher<String, Never>
    }
    
    // MARK: - Properties
    
    private let postId: Int
    private let useCase: PostsParticipantsUseCase
    private var cancellables = Set<AnyCancellable>()
    let output: Output
    private(set) var expandedSections: Set<Int> = [] // 섹션 펼침 여부
    private(set) var participants: [ParticipantManageModel] = []
    private var onTapConfirmDeposit: ((Int) -> Void)?
    private var onTapConfirmShip: ((Int) -> Void)?
    
    // MARK: - Subject
    
    private let fetchDataSubject = PassthroughSubject<Void, Never>()
    private let toggleButtonSubject = PassthroughSubject<Int, Never>()
    private let confirmDepositSubject = PassthroughSubject<Int, Never>()
    private let confirmShipSubject = PassthroughSubject<Int, Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    
    // MARK: - Initializer
    
    init(postId: Int, useCase: PostsParticipantsUseCase) {
        self.postId = postId
        self.useCase = useCase
        self.output = Output(
            fetchData:
                fetchDataSubject.eraseToAnyPublisher(),
            toggleButtonTapped: toggleButtonSubject.eraseToAnyPublisher(),
            confirmDepositTriggered: confirmDepositSubject.eraseToAnyPublisher(),
            confirmShipTriggered: confirmShipSubject.eraseToAnyPublisher(),
            showError: errorSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchParticipants()
            
        case .toggleButtonTap(let section):
            toggleExpandSection(section: section)
            
        case .confirmDeposit(let purchaseId):
            confirmDepositSubject.send(purchaseId)
            
        case .confirmShip(let purchaseId):
            confirmShipSubject.send(purchaseId)
        }
    }
    
    // MARK: - Private Method
    
    private func fetchParticipants() {
        Task { [weak self] in
            do {
                guard let self else { return }
                
                let entity = try await self.useCase.execute(postId: postId)
                self.participants = entity.toParticipantManageModels()
                self.fetchDataSubject.send()
                
            } catch {
                print("Error : \(error)")
            }
        }
    }
    
    private func toggleExpandSection(section: Int) {
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
        self.toggleButtonSubject.send(section)
    }
    
    func setParticipants(_ participants: [ParticipantManageModel]) {
        self.participants = participants
    }
}
