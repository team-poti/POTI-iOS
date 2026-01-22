//
//  PotDetailViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

import Combine

final class PotDetailViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let isJoinButtonEnabled = CurrentValueSubject<Bool, Never>(false)
    }
    
    // MARK: - Properties
    
    private let useCase: PotDetailUseCase
    let postId: Int
    private var cancellables = Set<AnyCancellable>()
    
    let output: Output
    
    private(set) var displayParticipants: [ParticipantDisplayModel] = []
    private(set) var potDetailModel: PotDetailModel?
    
    // MARK: - Subject
    
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Initializer
    
    init(useCase: PotDetailUseCase, postId: Int) {
        self.useCase = useCase
        self.postId = postId
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchPotDetail()
        }
    }
    
    // MARK: - Private Method
    
    private func fetchPotDetail() {
        Task {
            do {
                let entity = try await useCase.execute()
                let model = entity.toPotDetailModel()
                
                self.potDetailModel = model
                self.displayParticipants = model.participants.flatMap { participant in
                    participant.selectedMembers.map { memberName in
                        ParticipantDisplayModel(userInfo: participant, selectedMember: memberName)
                    }
                }
                let isEnabled = (model.status == "RECRUITING")
                output.isJoinButtonEnabled.send(isEnabled)
                
                reloadDataSubject.send(())
            } catch {
                print("PotDetail fetch Error: \(error)")
                output.isJoinButtonEnabled.send(false)
            }
        }
    }
}
