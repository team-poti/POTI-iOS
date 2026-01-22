//
//  GoodsListUseCase.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

protocol GoodsListUseCase {
    func execute(artistId: Int, sort: String, page: Int) async throws -> GoodsListEntity
}

final class DefaultGoodsListUseCase: GoodsListUseCase {
    private let repository: GoodsListInterface
    
    init(repository: GoodsListInterface) {
        self.repository = repository
    }
    
    func execute(artistId: Int, sort: String, page: Int) async throws -> GoodsListEntity {
        return try await repository.fetchGoodsListData(
            artistId: artistId,
            sort: sort,
            page: page
        )
    }
}

