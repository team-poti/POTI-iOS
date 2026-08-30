//
//  MyPageJoinViewModel.swift
//  POTI-iOS
//
//  Created by Neon on 1/16/26.
//

import Combine

final class MyPageJoinViewModel: BaseViewModelType {
    private let participationId: Int
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case tapPotInfo
        case submitDeposit(participationId: Int, depositorName: String, depositedAt: String)
        case completeDelivery(participantId: Int)
        case completeReview(transactionId: Int, rating: Int)
    }
    
    // MARK: - Output
    
    struct Output {
        let naviPotInfo: AnyPublisher<Int, Never>
        let viewState: AnyPublisher<JoinDetailViewState, Never>
        let submitDepositResult: AnyPublisher<Void, Never>
        let completeDeliveryResult: AnyPublisher<Void, Never>
        let completeReviewResult: AnyPublisher<Void, Never>
    }
    
    private(set) var joinModel: MyPageJoinModel?
    private let participationsDetailUseCase: ParticipationDetailUseCase
    private let postPaymentsUseCase: PostPaymentsUseCase
    private let participationsDeliveredUseCase: ParticipationDeliveredUseCase
    private let createReviewUseCase: ReviewUseCase
    private let viewStateMapper = JoinDetailViewStateMapper()
    
    // MARK: - Subject
    
    private let naviPotInfoSubject = PassthroughSubject<Int, Never>()
    private let viewStateSubject = CurrentValueSubject<JoinDetailViewState?, Never>(nil)
    private let submitDepositResultSubject = PassthroughSubject<Void, Never>()
    private let completeDeliveryResultSubject = PassthroughSubject<Void, Never>()
    private let completeReviewResultSubject = PassthroughSubject<Void, Never>()
    
    let output: Output
    
    // MARK: - Lifecycle
    
    init(
        participationId: Int,
        participationsDetailUsecase: ParticipationDetailUseCase,
        postPaymentsUseCase: PostPaymentsUseCase,
        participationsDeliveredUseCase: ParticipationDeliveredUseCase,
        createReviewUseCase: ReviewUseCase
    ) {
        self.participationId = participationId
        self.participationsDeliveredUseCase = participationsDeliveredUseCase
        self.participationsDetailUseCase = participationsDetailUsecase
        self.postPaymentsUseCase = postPaymentsUseCase
        self.createReviewUseCase = createReviewUseCase
        self.output = Output(
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
        case .tapPotInfo:
            if let postId = self.joinModel?.postId {
                naviPotInfoSubject.send(postId)
            }
        case .submitDeposit(let participationId, let depositorName, let depositedAt):
            guard joinModel?.paymentInfo.depositStatus == .waiting else {
                return
            }
            
            Task { [weak self] in
                guard let self else { return }
                do {
                    let entity = PostPaymentEntity(
                        participationId: participationId,
                        depositorName: depositorName,
                        depositedAt: depositedAt
                    )
                    
                    _ = try await postPaymentsUseCase.execute(entity: entity)
                    
                    await self.fetchParticipationsDetail(participationId: self.participationId)
                    self.submitDepositResultSubject.send()
                } catch {
                    PotiLogger.error(error)
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
                    PotiLogger.error(error)
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
                    
                    await self.fetchParticipationsDetail(participationId: self.participationId)
                    self.completeReviewResultSubject.send()
                } catch {
                    PotiLogger.error(error)
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
            let state = viewStateMapper.map(entity: entity)
            viewStateSubject.send(state)
        } catch {
            PotiLogger.error(error)
        }
    }
}
