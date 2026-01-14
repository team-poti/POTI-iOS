//
//  DefaultAuthRepository.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

final class DefaultAuthRepository: AuthInterface {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func login(socialType: String, token: String) async throws -> LoginResponseEntity {
        let result = try await networkService.request(
            target: AuthAPI.login(socialType: socialType, token: token), type: LoginResponseDTO.self
            )
        return result.toLoginResponseEntity()
    }
}
