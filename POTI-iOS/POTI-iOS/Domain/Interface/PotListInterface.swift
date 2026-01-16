//
//  PotListInterface.swift
//  POTI-iOS
//
//  Created by mandoo on 1/16/26.
//

protocol PotListInterface {
    func fetchPotListData() async throws -> PotListEntity
}
