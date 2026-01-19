//
//  TokenRefreshService.swift
//  POTI-iOS
//
//  Created by neon on 1/19/26.
//

import Foundation

protocol TokenRefreshService {
    func refreshToken() async throws -> (accessToken: String, refreshToken: String)
}

final class DefaultTokenRefreshService: TokenRefreshService {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func refreshToken() async throws -> (accessToken: String, refreshToken: String) {
        guard let currentRefreshToken = KeychainManager.getRefreshToken() else {
            throw PotiError.unauthorized
        }
        
        let dto = try await networkService.request(
            target: AuthAPI.reissue(refreshToken: currentRefreshToken),
            type: TokenResponseDTO.self
        )
        
        return (dto.accessToken, dto.refreshToken)
    }
}
