//
//  PotListUseCase.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

protocol PotListUseCase {
    func execute(title: String, artistId: Int, memberIds: [Int]?, sort: String, page: Int) async throws -> PotListEntity
}

final class DefaultPotListUseCase: PotListUseCase {
    
    private let repository: PostInterface

    init(repository: PostInterface) {
        self.repository = repository
    }
    
    func execute(title: String, artistId: Int, memberIds: [Int]?, sort: String, page: Int) async throws -> PotListEntity {
            return try await repository.fetchPotListData(title: title, artistId: artistId, memberIds: memberIds, sort: sort, page: page)
    }
}
