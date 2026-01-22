//
//  PotListInterface.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

protocol PotListInterface {
    func fetchPotListData(title: String, artistId: Int, memberIds: [Int]?, sort: String, page: Int) async throws -> PotListEntity
}
