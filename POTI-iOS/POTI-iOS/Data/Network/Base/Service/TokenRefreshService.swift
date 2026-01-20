//
//  TokenRefreshService.swift
//  POTI-iOS
//
//  Created by neon on 1/19/26.
//

import Foundation

protocol TokenRefreshService: Sendable {
    func refreshToken() async throws -> TokenResponseDTO
}

final class DefaultTokenRefreshService: TokenRefreshService {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func refreshToken() async throws -> TokenResponseDTO {
        guard let currentRefreshToken = KeychainManager.getRefreshToken() else {
            throw PotiError.unauthorized
        }
        
        do {
            let dto = try await networkService.request(
                target: AuthAPI.reissue(refreshToken: currentRefreshToken),
                type: TokenResponseDTO.self
            )
            
            return dto
        } catch let error as PotiError {
            throw error
        } catch {
            throw PotiError.networkFail
        }
    }
}
