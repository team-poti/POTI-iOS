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
        case submitDeposit(orderId: Int, depositorName: String, depositedAt: String)
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let fetchData: AnyPublisher<Void, Never>
        let naviPotInfo: AnyPublisher<Void, Never>
        let viewState: AnyPublisher<JoinDetailViewState, Never>
    }
    
    private(set) var joinModel: MyPageJoinModel?
    private let participationsDetailUsecase: ParticipationsDetailUseCase
    private let postPaymentsUseCase: PostPaymentsUseCase
    private let viewStateMapper = JoinDetailViewStateMapper()
    
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
    
    // MARK: - Lifecycle
    
    init(
        participationId: Int,
        participationsDetailUsecase: ParticipationsDetailUseCase,
        postPaymentsUseCase: PostPaymentsUseCase
    ) {
        self.participationId = participationId
        self.participationsDetailUsecase = participationsDetailUsecase
        self.postPaymentsUseCase = postPaymentsUseCase
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher(),
            fetchData: fetchDataSubject.eraseToAnyPublisher(),
            naviPotInfo: naviPotInfoSubject.eraseToAnyPublisher(),
            viewState: viewStateSubject
                .compactMap { $0 }
                .eraseToAnyPublisher()
        )
    }
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            Task { [weak self] in
                guard let self else {
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
            
        case .submitDeposit(let orderId, let depositorName, let depositedAt):
            Task { [weak self] in
                guard let self else { return }
                do {
                    let entity = try await postPaymentsUseCase.execute(
                        orderId: orderId,
                        depositorName: depositorName,
                        depositedAt: depositedAt
                    )
                    self.participantOrderStatus = .depositCompleted
                    self.reloadDataSubject.send()
                    
                } catch {
                    print("❌ payment error:", error)
                    // self.errorSubject.send(...)
                }
            }
        }
    }
    
    // MARK: - Private Method
    
    private func fetchParticipationsDetail(participationId: Int) async {
        do {
            let entity = try await participationsDetailUsecase.execute(participationId: participationId)
            
            let model = MyPageJoinModel.map(entity: entity)
            self.joinModel = model
            self.participantOrderStatus = model.postStatus
            self.participants = [model]
            self.progressStatusModel = ProgressStatusModel(
                role: .participant,
                status: ParticipantStatus.from(participantStatus: model.postStatus)
            )
            let state = viewStateMapper.map(entity: entity)
            viewStateSubject.send(state)
            fetchDataSubject.send()
            reloadDataSubject.send()
        } catch {
            print("🥎 fetchParticipationsDetail error:", error)
        }
    }
}
