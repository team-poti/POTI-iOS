//
//  GoodsListInterface.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

protocol GoodsListInterface {
    func fetchGoodsListData() async throws -> GoodsListEntity
}
