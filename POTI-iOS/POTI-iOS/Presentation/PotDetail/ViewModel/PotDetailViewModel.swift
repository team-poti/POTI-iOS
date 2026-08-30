//
//  PotDetailViewModel.swift
//  POTI-iOS
//
//  Created by soomin on 1/18/26.
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
    private let fetchPotOptionsUseCase: FetchPotOptionsUseCase
    let postId: Int
    private var cancellables = Set<AnyCancellable>()
    
    let output: Output
    
    private(set) var participants: [ParticipantModel] = []
    private(set) var potDetailModel: PotDetailModel?
    private(set) var availableMembers: [String] = []
    private(set) var isShareContentReady = false
    
    // MARK: - Subject
    
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Initializer
    
    init(useCase: PotDetailUseCase, fetchPotOptionsUseCase: FetchPotOptionsUseCase, postId: Int) {
        self.useCase = useCase
        self.fetchPotOptionsUseCase = fetchPotOptionsUseCase
        self.postId = postId
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            isShareContentReady = false
            fetchPotDetail()
            fetchPotOptions()
        }
    }
    
    // MARK: - Private Method
    
    private func fetchPotDetail() {
        Task {
            do {
                let entity = try await useCase.execute(postId: self.postId)
                let model = entity.toPotDetailModel()
                
                self.potDetailModel = model
                self.participants = model.participants.flatMap { participant in
                    participant.selectedMembers.map { memberName in
                        ParticipantModel(userInfo: participant, selectedMember: memberName)
                    }
                }
                
                let isEnabled = (model.status == "RECRUITING")
                
                await MainActor.run {
                    output.isJoinButtonEnabled.send(isEnabled)
                    reloadDataSubject.send(())
                }
            } catch {
                print("PotDetail fetch Error: \(error)")
                output.isJoinButtonEnabled.send(false)
            }
        }
    }

    private func fetchPotOptions() {
        Task {
            do {
                let options = try await fetchPotOptionsUseCase.execute(postId: postId)
                availableMembers = options.members.map(\.name)
                isShareContentReady = true
            } catch {
                PotiLogger.error(error)
            }
        }
    }
}
