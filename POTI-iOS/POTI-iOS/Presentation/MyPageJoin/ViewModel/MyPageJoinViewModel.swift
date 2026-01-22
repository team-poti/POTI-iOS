//
//  MyPageJoinViewModel.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/16/26.
//

import Combine

final class MyPageJoinViewModel: BaseViewModelType {
    private let participationId: Int
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case setParticipants([MyPageJoinModel])
        case tapPotInfo
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let fetchData: AnyPublisher<Void, Never>
        let naviPotInfo: AnyPublisher<Void, Never>
        let viewState: AnyPublisher<JoinDetailViewState?, Never>
    }
    
    private(set) var joinModel: MyPageJoinModel?
    
    /// MyPageJoinDetailViewController -> .statusInfo  섹션에서 분기용으로 사용할 현재 상태
    private(set) var participantOrderStatus: MyPageJoinModel.PostStatus?
    private(set) var progressStatusModel: ProgressStatusModel?
    private(set) var participants: [MyPageJoinModel] = []
    
    // MARK: - Subject
    
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    private let fetchDataSubject = PassthroughSubject<Void, Never>()
    private let naviPotInfoSubject = PassthroughSubject<Void, Never>()
    private let viewStateSubject = CurrentValueSubject<JoinDetailViewState?, Never>(nil)
    
    let output: Output
    private let usecase: ParticipationsDetailUseCase
    private let viewStateMapper = JoinDetailViewStateMapper()
    
    // MARK: - Lifecycle
    
    init(
        participationId: Int,
        usecase: ParticipationsDetailUseCase
    ) {
        self.participationId = participationId
        self.usecase = usecase
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher(),
            fetchData: fetchDataSubject.eraseToAnyPublisher(),
            naviPotInfo: naviPotInfoSubject.eraseToAnyPublisher(),
            viewState: viewStateSubject.eraseToAnyPublisher()
        )
        print("✅ MyPageJoinViewModel init - participationId:", participationId)
    }
    
    deinit {
        print("🧨 MyPageJoinViewModel deinit - participationId:", participationId)
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        print("➡️ MyPageJoinViewModel action:", trigger)
        switch trigger {
        case .viewDidLoad:
            print("🟦 viewDidLoad received - will fetch, participationId:", participationId)
            Task { [weak self] in
                guard let self else {
                    print("⚠️ viewDidLoad Task: self nil (ViewModel released before fetch)")
                    return
                }
                await self.fetchParticipationsDetail(participationId: self.participationId)
            }
        case .setParticipants(let participants):
            self.participants = participants
            self.joinModel = participants.first
            /// VC에서 viewModel.participantStatus로 바로 꺼내 쓸 수 있게 디폴트 값 설정
            self.participantOrderStatus = joinModel?.postStatus
            if let joinModel {
                self.progressStatusModel = ProgressStatusModel(
                    role: .participant,
                    status: ParticipantStatus.from(participantStatus: joinModel.postStatus)
                )
            } else {
                self.progressStatusModel = nil
            }
            fetchDataSubject.send()
            
        case .tapPotInfo:
            naviPotInfoSubject.send()
        }
    }
    
    // MARK: - Private Method
    
    private func fetchParticipationsDetail(participationId: Int) async {
        print("🌐 fetchParticipationsDetail start - participationId:", participationId)
        do {
            let entity = try await usecase.execute(participationId: participationId)
            print("✅ fetchParticipationsDetail success - entity:", entity)
            let state = viewStateMapper.map(entity: entity)
            
            viewStateSubject.send(state)
            reloadDataSubject.send()
        } catch {
            print("❌ fetchParticipationsDetail error type:", String(reflecting: type(of: error)))
            print("❌ fetchParticipationsDetail error:", error)
            print("❌ fetchParticipationsDetail localizedDescription:", error.localizedDescription)
        }
    }
}
