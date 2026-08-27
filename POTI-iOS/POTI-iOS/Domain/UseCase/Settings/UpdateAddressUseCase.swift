//
//  UpdateAddressUseCase.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

protocol UpdateAddressUseCase {
    func execute(_ address: AddressEntity) async throws -> AddressEntity
}

final class DefaultUpdateAddressUseCase: UpdateAddressUseCase {
    private let repository: SettingsInterface
    init(repository: SettingsInterface) { self.repository = repository }
    func execute(_ address: AddressEntity) async throws -> AddressEntity { try await repository.updateAddress(address) }
}
