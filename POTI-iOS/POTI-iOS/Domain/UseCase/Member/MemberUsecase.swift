//
//  MemberUsecase.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

protocol MemberUsecase {
    func execute(artistId: Int) async throws -> [MemberEntity]
}

final class DefaultMemberUseCase: MemberUsecase {
    private let repository: MemberInterface
    
    init(repository: MemberInterface) {
        self.repository = repository
    }
    
    func execute(artistId: Int) async throws -> [MemberEntity] {
        return try await repository.fetchMemberList(artistId: artistId)
    }
}
