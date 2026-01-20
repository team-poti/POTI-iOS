//
//  ManageInterface.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/18/26.
//


protocol ManageInterface {
    func fetchManageData(postId: Int) async throws -> ManageEntity
    //func confirmDepositData(purchaseId: Int) async throws
}
