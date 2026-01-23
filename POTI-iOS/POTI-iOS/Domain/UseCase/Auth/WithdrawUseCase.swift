//
//  WithdrawUseCase.swift
//  POTI-iOS
//
//  Created by nayeon on 1/24/26.
//

protocol WithdrawUseCase {
    func execute() async throws -> Void
}

final class DefaultWithdrawUseCase: WithdrawUseCase {
    private let repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.withDraw()
    }
}
