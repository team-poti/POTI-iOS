//
//  RecruitDetailViewModel.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import Combine

final class RecruitDetailViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case tapPotInfo
        case tapManageInfo
    }
    
    // MARK: - Output

    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let joinItems: AnyPublisher<[MyPageJoinModel], Never>
        let naviPotInfo: AnyPublisher<Void, Never>
        let naviManageInfo: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties

    let output: Output

    // MARK: - Subject

    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    private let joinItemsSubject = CurrentValueSubject<[MyPageJoinModel], Never>([]) // TODO: - NETWORK - MYPageJoinModel 아님
    private let naviPotInfoSubject = PassthroughSubject<Void, Never>()
    private let naviManageInfoSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Initializer
    
    init() {
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher(),
            joinItems: joinItemsSubject.eraseToAnyPublisher(),
            naviPotInfo: naviPotInfoSubject.eraseToAnyPublisher(),
            naviManageInfo: naviManageInfoSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchRecruitDetail()
            loadMockJoinItems()
        case .tapPotInfo:
            naviPotInfoSubject.send()
        case .tapManageInfo:
            naviManageInfoSubject.send()
        }
    }
    // MARK: - Private Method
    
    private func fetchRecruitDetail() {
//        Task {
//            do {
//                let data = try await useCase.execute()
//                self.groupItems = data.toGroupItemModel()
//                reloadDataSubject.send(())
//            } catch {
//                print("Error: \(error)")
//            }
//        }
    }
    
    private func loadMockJoinItems() {
        let items = makeMockParticipants()
        print("✅ loadMockJoinItems send:", items.count)
        joinItemsSubject.send(items)
        reloadDataSubject.send(())
    }

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
}
