//
//  JoinDetailViewState.swift
//  POTI-iOS
//
//  Created by Neon on 1/23/26.
//

import UIKit

struct JoinDetailViewState {
    let potInfo: PotInfoViewState
    let progress: JoinProgressStatusViewCell.Model
    let myJoinDepositInfo: MyJoinDepositState
    let screenState: any JoinDetailScreenState
}

struct MyJoinDepositState {
    struct MemberRow: Equatable {
        let name: String
        let price: Int
    }
    
    let memberRows: [MemberRow]
    let shippingMethod: String
    let shippingFee: Int
    let totalAmount: Int
}

// MARK: - Mapper

struct JoinDetailViewStateMapper {
    func map(entity: JoinDetailEntity) -> JoinDetailViewState {
        let potInfo = PotInfoViewState(
            postId: entity.postId,
            orderNumber: entity.orderNumber,
            imageUrl: entity.imageUrl,
            artistName: entity.artistName,
            title: entity.title,
            status: entity.postStatus
        )
        
        let participantStatus = entity.paymentInfo.depositStatus
        
        let screenState = JoinDetailScreenStateFactory.make(
            postStatus: entity.postStatus,
            participantStatus: participantStatus
        )

        let serverMessage = entity.statusMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        let progress = JoinProgressStatusViewCell.Model(
            message: serverMessage.isEmpty ? screenState.message : serverMessage,
            progressImage: screenState.progressImage
        )
        
        let myJoinDepositInfo = MyJoinDepositState(
            memberRows: entity.memberPayments.map { .init(name: $0.memberName, price: $0.price) },
            shippingMethod: entity.shippingInfo.shippingMethod,
            shippingFee: entity.paymentInfo.shippingFee,
            totalAmount: entity.paymentInfo.totalAmount
        )
        
        return JoinDetailViewState(
            potInfo: potInfo,
            progress: progress,
            myJoinDepositInfo: myJoinDepositInfo,
            screenState: screenState
        )
    }
}
