//
//  GetMyPageInformationUseCase.swift
//  POTI-iOS
//
//  Created by neon on 1/22/26.
//

protocol GetMyPageInformationUseCase {
    func execute() async throws -> MyPageEntity
}

final class DefaultGetMyPageInformationUseCase: GetMyPageInformationUseCase {
    
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> MyPageEntity {
        return try await repository.getMyPageInformation()
    }
}
