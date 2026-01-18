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
        case confirmParticipantActionTap(ParticipantAction)
    }
    
    // MARK: - Output
    
    struct Output {
        let fetchData: AnyPublisher<Void, Never>
        let toggleButtonTapped: AnyPublisher<Int, Never>
        let participantActionTriggered: AnyPublisher<ParticipantAction, Never>
        let showError: AnyPublisher<String, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: ManageUseCase
    private var cancellables = Set<AnyCancellable>()
    let output: Output
    private(set) var expandedSections: Set<Int> = [] // 섹션 펼침 여부
    private(set) var participants: [ParticipantManageModel] = []
    
    enum ParticipantAction {
        case confirmDeposit(purchaseId: Int)
        case enterTrackingNumber(purchaseId: Int)
    }
    
    // MARK: - Subject
    
    private let fetchDataSubject = PassthroughSubject<Void, Never>()
    private let toggleButtonSubject = PassthroughSubject<Int, Never>()
    private let participantActionSubject = PassthroughSubject<ParticipantAction, Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    
    // MARK: - Initializer
    
    init(useCase: ManageUseCase) {
        self.useCase = useCase
        self.output = Output(
            fetchData:
                fetchDataSubject.eraseToAnyPublisher(),
            toggleButtonTapped: toggleButtonSubject.eraseToAnyPublisher(),
            participantActionTriggered: participantActionSubject.eraseToAnyPublisher(),
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
            
        case .confirmParticipantActionTap(let action):
            handleParticipantAction(action)
        }
    }
    
    // MARK: - Private Method
    
    private func fetchParticipants() {
        Task { [weak self] in
            do {
                guard let self else { return }

                let entity = try await self.useCase.execute(postId: 1)
                self.participants = entity.toParticipantManageModels()
                self.fetchDataSubject.send()

            } catch {
                print("Error : \(error)")
            }
        }
    }
    
    private func toggleExpandSection(section: Int) {
        // 1. 로컬 토글 상태 변경
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }

        // 2. 서버 요청
        Task { [weak self] in
            do {
                guard let self else { return }

                let entity = try await self.useCase.execute(postId: 1)
                self.participants = entity.toParticipantManageModels()

                // 3. 서버 응답 후 UI 갱신 트리거 (단 한 번)
                self.toggleButtonSubject.send(section)

            } catch {
                print("Error : \(error)")
            }
        }
    }
    
    private func handleParticipantAction(_ action: ParticipantAction) {
        switch action {
        case .confirmDeposit(let purchaseId):
            participantActionSubject.send(.confirmDeposit(purchaseId: purchaseId))
            confirmDeposit(purchaseId: purchaseId)
        case .enterTrackingNumber(let purchaseId):
            participantActionSubject.send(.enterTrackingNumber(purchaseId: purchaseId))
        }
    }
    
    private func confirmDeposit(purchaseId: Int) {
        Task { [weak self] in
            guard let self else { return }

            do {
                //try await self.useCase.confirmDeposit(purchaseId: purchaseId)

                // 성공 → 리스트 재조회 → reloadData Output
                let entity = try await self.useCase.execute(postId: 1) //self.postId TODO~!!!!!!!
                self.participants = entity.toParticipantManageModels()
                self.fetchDataSubject.send()

            } catch {
                self.errorSubject.send("입금 확인에 실패했어요")
            }
        }
    }
    
    private func enterTrackingNumber(purchaseId: Int) {
        
    }
    
    func setParticipants(_ participants: [ParticipantManageModel]) {
        self.participants = participants
    }
}
