//
//  GetYourPageInformationUseCase.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

protocol GetYourPageInformationUseCase {
    func execute(userId: Int) async throws -> YourPageEntity
}

final class DefaultGetYourPageInformationUseCase: GetYourPageInformationUseCase {
    
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute(userId: Int) async throws -> YourPageEntity {
        return try await repository.getYourPageInformation(userId: userId)
    }
}
