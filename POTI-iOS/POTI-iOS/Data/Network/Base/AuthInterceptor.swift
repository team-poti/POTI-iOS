//
//  AuthInterceptor.swift
//  POTI-iOS
//
//  Created by neon on 1/19/26.
//
//
//  AuthInterceptor.swift
//  POTI-iOS
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    private let tokenRefreshService: TokenRefreshService
    
    init(tokenRefreshService: TokenRefreshService) {
        self.tokenRefreshService = tokenRefreshService
    }
    
    // MARK: - Adapt
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        if let token = KeychainManager.getAccessToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            PotiLogger.network("🔐 Authorization 헤더 자동 추가")
        }
        
        completion(.success(urlRequest))
    }
    
    // MARK: - Retry
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        if request.request?.url?.path.contains("reissue") == true {
            PotiLogger.error(NSError(domain: "토큰 갱신 실패", code: 401))
            KeychainManager.deleteAllTokens()
            completion(.doNotRetry)
            return
        }
        
        requestsToRetry.append(completion)
        
        guard !isRefreshing else {
            PotiLogger.debug("🔄 토큰 갱신 대기 중...")
            return
        }
        
        refreshToken()
    }
    
    private func refreshToken() {
        isRefreshing = true
        
        Task {
            do {
                let (accessToken, refreshToken) = try await tokenRefreshService.refreshToken()
                
                KeychainManager.saveTokens(
                    accessToken: accessToken,
                    refreshToken: refreshToken
                )
                PotiLogger.debug("토큰 갱신 성공")
                
                await MainActor.run {
                    self.isRefreshing = false
                    self.requestsToRetry.forEach { $0(.retry) }
                    self.requestsToRetry.removeAll()
                }
            } catch {
                PotiLogger.error(error)
                KeychainManager.deleteAllTokens()
                
                await MainActor.run {
                    self.isRefreshing = false
                    self.requestsToRetry.forEach { $0(.doNotRetry) }
                    self.requestsToRetry.removeAll()
                }
            }
        }
    }
}
