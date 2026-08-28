//
//  GetAddressUseCase.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

protocol GetAddressUseCase {
    func execute() async throws -> AddressEntity
}

final class DefaultGetAddressUseCase: GetAddressUseCase {
    private let repository: SettingsInterface
    init(repository: SettingsInterface) { self.repository = repository }
    func execute() async throws -> AddressEntity { try await repository.fetchAddress() }
}
