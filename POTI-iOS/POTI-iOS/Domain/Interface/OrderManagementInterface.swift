//
//  OrderManagementInterface.swift
//  POTI-iOS
//
//  Created by soomin on 1/21/26.
//

protocol OrderManagementInterface {
    func patchTrackingNumber(orderId: Int, entity: TrackingNumberRequestEntity) async throws -> TrackingNumberResponseEntity
    func fetchManagerData(postId: Int) async throws -> ManageEntity
    func fetchSaleDetail(postId: Int) async throws -> RecruitDetailEntity
}
