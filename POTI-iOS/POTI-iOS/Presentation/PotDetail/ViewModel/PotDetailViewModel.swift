//
//  PotDetailViewModel.swift
//  POTI-iOS
//
//  Created by soomin on 1/18/26.
//

import Combine

enum PotJoinButtonState: Equatable {
    case available
    case closed
    case myPost
    case alreadyParticipated

    var isEnabled: Bool {
        self == .available
    }

    var title: String {
        switch self {
        case .available: "분철팟 참여하기"
        case .closed: "마감된 분철팟이에요"
        case .myPost: "내가 등록한 분철팟이에요"
        case .alreadyParticipated: "이미 참여한 분철팟이에요"
        }
    }
}

final class PotDetailViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let joinButtonState = CurrentValueSubject<PotJoinButtonState, Never>(.closed)
    }
    
    // MARK: - Properties
    
    private let useCase: PotDetailUseCase
    private let fetchPotOptionsUseCase: FetchPotOptionsUseCase
    private let getMyPageInformationUseCase: GetMyPageInformationUseCase
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
    
    init(useCase: PotDetailUseCase, fetchPotOptionsUseCase: FetchPotOptionsUseCase,
         getMyPageInformationUseCase: GetMyPageInformationUseCase, postId: Int) {
        self.useCase = useCase
        self.fetchPotOptionsUseCase = fetchPotOptionsUseCase
        self.getMyPageInformationUseCase = getMyPageInformationUseCase
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
                
                let currentUserId = try? await getMyPageInformationUseCase.execute().userId
                let joinButtonState = makeJoinButtonState(model: model, currentUserId: currentUserId)
                
                await MainActor.run {
                    output.joinButtonState.send(joinButtonState)
                    reloadDataSubject.send(())
                }
            } catch {
                print("PotDetail fetch Error: \(error)")
                output.joinButtonState.send(.closed)
            }
        }
    }

    private func makeJoinButtonState(model: PotDetailModel, currentUserId: Int?) -> PotJoinButtonState {
        if model.isMyPost {
            return .myPost
        }
        guard let currentUserId else {
            return .closed
        }
        if model.participants.contains(where: { $0.userId == currentUserId }) {
            return .alreadyParticipated
        }
        return model.status == "RECRUITING" ? .available : .closed
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
