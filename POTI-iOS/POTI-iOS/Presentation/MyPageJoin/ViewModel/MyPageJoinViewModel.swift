//
//  MyPageJoinViewModel.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/16/26.
//

import Combine

final class MyPageJoinViewModel: BaseViewModelType {
    private let participationId: Int
    private(set) var orderId: Int
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case setParticipants([MyPageJoinModel])
        case tapPotInfo
        case submitDeposit(orderId: Int, depositorName: String, depositedAt: String)
        case completeDelivery(participantId: Int)
        case completeReview(transactionId: Int, rating: Int)
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let fetchData: AnyPublisher<Void, Never>
        let naviPotInfo: AnyPublisher<Void, Never>
        let viewState: AnyPublisher<JoinDetailViewState, Never>
        let submitDepositResult: AnyPublisher<Void, Never>
        let completeDeliveryResult: AnyPublisher<Void, Never>
        let completeReviewResult: AnyPublisher<Void, Never>
    }
    
    private(set) var joinModel: MyPageJoinModel?
    private(set) var yourPageModel: YourPageModel?
    private let participationsDetailUseCase: ParticipationsDetailUseCase
    private let postPaymentsUseCase: PostPaymentsUseCase
    private let participationsDeliveredUseCase: ParticipationsDeliveredUseCase
    private let createReviewUseCase: ReviewUseCase
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
    private let submitDepositResultSubject = PassthroughSubject<Void, Never>()
    private let completeDeliveryResultSubject = PassthroughSubject<Void, Never>()
    private let completeReviewResultSubject = PassthroughSubject<Void, Never>()
    
    let output: Output
    
    // MARK: - Lifecycle
    
    init(
        participationId: Int,
        orderId: Int,
        participationsDetailUsecase: ParticipationsDetailUseCase,
        postPaymentsUseCase: PostPaymentsUseCase,
        participationsDeliveredUseCase: ParticipationsDeliveredUseCase,
        createReviewUseCase: ReviewUseCase
    ) {
        self.participationId = participationId
        self.orderId = orderId
        self.participationsDeliveredUseCase = participationsDeliveredUseCase
        self.participationsDetailUseCase = participationsDetailUsecase
        self.postPaymentsUseCase = postPaymentsUseCase
        self.createReviewUseCase = createReviewUseCase
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher(),
            fetchData: fetchDataSubject.eraseToAnyPublisher(),
            naviPotInfo: naviPotInfoSubject.eraseToAnyPublisher(),
            viewState: viewStateSubject
                .compactMap { $0 }
                .eraseToAnyPublisher(),
            submitDepositResult: submitDepositResultSubject.eraseToAnyPublisher(),
            completeDeliveryResult: completeDeliveryResultSubject.eraseToAnyPublisher(),
            completeReviewResult: completeReviewResultSubject.eraseToAnyPublisher()
            
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
                    let _ = try await postPaymentsUseCase.execute(
                        orderId: orderId,
                        depositorName: depositorName,
                        depositedAt: depositedAt
                    )
                    // 서버 상태를 다시 받아와 화면을 정확히 갱신
                    await self.fetchParticipationsDetail(participationId: self.participationId)
                    self.submitDepositResultSubject.send()
                } catch {
                    print("❌ payment error:", error)
                }
            }
        case .completeDelivery(let participantId):
            Task { [weak self] in
                guard let self else { return }
                do {
                    try await participationsDeliveredUseCase.execute(participationId: participantId)
                    await self.fetchParticipationsDetail(participationId: self.participationId)
                    self.completeDeliveryResultSubject.send()
                } catch {
                    print("❌ delivery complete error:", error)
                }
            }
        case .completeReview(let transactionId, let rating):
            Task { [weak self] in
                guard let self else { return }
                do {
                    _ = try await createReviewUseCase.execute(
                        transactionId: transactionId,
                        rating: rating
                    )

                    // 서버 상태를 다시 받아와 화면을 정확히 갱신
                    await self.fetchParticipationsDetail(participationId: self.participationId)
                    self.completeReviewResultSubject.send()
                } catch {
                    print("❌ review create error:", error)
                }
            }
        }
    }
    
    // MARK: - Private Method
    
    private func fetchParticipationsDetail(participationId: Int) async {
        do {
            let entity = try await participationsDetailUseCase.execute(participationId: participationId)
            
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
