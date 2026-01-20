//
//  MyPageJoinViewModel.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/16/26.
//

import Combine

final class MyPageJoinViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        /// 외부에서 참가자 목록을 주입(서버 붙기 전/프리뷰/테스트용)
        case setParticipants([MyPageJoinModel])
    }

    // MARK: - Output

    struct Output {
        let fetchData: AnyPublisher<Void, Never>
    }

    // MARK: - Public State (VC에서 읽기)

    private(set) var joinModel: MyPageJoinModel?

    /// MyPageJoinDetailViewController -> .statusInfo  섹션에서 분기용으로 사용할 현재 상태
    private(set) var participantStatus: MyPageJoinModel.PostStatus?
    private(set) var progressStatusModel: ProgressStatusModel?
    private(set) var participants: [MyPageJoinModel] = []

    // MARK: - Subject

    private let fetchDataSubject = PassthroughSubject<Void, Never>()

    // MARK: - Output

    let output: Output

    // MARK: - Lifecycle

    init() {
        self.output = Output(fetchData: fetchDataSubject.eraseToAnyPublisher())
    }

    // MARK: - Mock

    private func makeMockParticipants() -> [MyPageJoinModel] {
        return [
            MyPageJoinModel(
                participationId: 5,
                imageUrlString: "",
                artistName: "BLACKPINK",
                title: "Pink Venom 포토카드",
                postStatus: .recruitCompleted,
                orderStatus: .delivered,
                statusMessage: "모든 진행이 완료되었어요",
                memberPayments: [
                    .init(memberName: "제니", price: 9000),
                    .init(memberName: "로제", price: 9000),
                    .init(memberName: "지수", price: 9000),
                    .init(memberName: "리사", price: 9000)
                ],
                paymentInfo: .init(
                    shippingFee: 4000,
                    totalAmount: 40000,
                    depositStatus: .completed,
                    bank: "우리은행",
                    accountNumber: "1002-345-678901",
                    depositDeadline: "2025-12-30T02:50"
                ),
                shippingInfo: .init(
                    shippingMethod: "일반택배",
                    receiver: "김서현",
                    zipcode: "06000",
                    address: "서울시 강남구 압구정로 77",
                    phone: "010-5555-6666",
                    carrier: "CJ대한통운",
                    trackingNumber: "987654321098",
                    shippingStatus: .delivered
                )
            )
        ]
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            // 서버 붙기 전 임시 mock 데이터
            let mock = makeMockParticipants()
            action(.setParticipants(mock))

        case .setParticipants(let participants):
            self.participants = participants
            self.joinModel = participants.first
            //  VC에서 viewModel.participantStatus로 바로 꺼내 쓸 수 있게 디폴트 값 설정
            self.participantStatus = joinModel?.postStatus
            if let joinModel {
                self.progressStatusModel = ProgressStatusModel(
                    role: .participant,
                    status: ParticipantStatus.from(participantStatus: joinModel.postStatus)
                )
            } else {
                self.progressStatusModel = nil
            }
            fetchDataSubject.send(())
        }
    }
}
