//
//  FetchShippingOptionsUseCase.swift
//  POTI-iOS
//
//  Created by Neon on 8/31/26.
//

protocol FetchShippingOptionsUseCase {
    func execute() async throws -> [RegisterShippingOptionEntity]
}

final class DefaultFetchShippingOptionsUseCase: FetchShippingOptionsUseCase {
    private let repository: RegisterInterface

    init(repository: RegisterInterface) {
        self.repository = repository
    }

    func execute() async throws -> [RegisterShippingOptionEntity] {
        try await repository.fetchShippingOptions()
    }
}
