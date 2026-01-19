//
//  AuthInterceptor.swift
//  POTI-iOS
//
//  Created by neon on 1/19/26.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    
    private actor RefreshState {
        var isRefreshing = false
        var requestsToRetry: [(RetryResult) -> Void] = []
        
        func setRefreshing(_ value: Bool) {
            isRefreshing = value
        }
        
        func addRequest(_ completion: @escaping (RetryResult) -> Void) {
            requestsToRetry.append(completion)
        }
        
        func completeAll(with result: RetryResult) {
            requestsToRetry.forEach { $0(result) }
            requestsToRetry.removeAll()
        }
        
        func getIsRefreshing() -> Bool {
            return isRefreshing
        }
    }
        
    private let refreshState = RefreshState()
    private let tokenRefreshService: TokenRefreshService
    
    init(tokenRefreshService: TokenRefreshService) {
        self.tokenRefreshService = tokenRefreshService
    }
    
    // MARK: - Adapt
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        if urlRequest.url?.path.contains("/auth/reissue") == true {
            completion(.success(urlRequest))
            return
        }
        
        if let token = KeychainManager.getAccessToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            PotiLogger.network("🔐 Authorization 헤더 자동 추가")
        }
        
        completion(.success(urlRequest))
    }
    
    // MARK: - Retry
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        if let potiError = error as? PotiError, potiError.needsRelogin {
            PotiLogger.error(potiError)
            KeychainManager.deleteAllTokens()
            completion(.doNotRetry)
            return
        }
        
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
        
        Task {
            await refreshState.addRequest(completion)
            
            let isAlreadyRefreshing = await refreshState.getIsRefreshing()
            guard !isAlreadyRefreshing else {
                PotiLogger.debug("토큰 갱신 대기 중...")
                return
            }
            
            await refreshToken()
        }
    }
    
    private func refreshToken() async {
        await refreshState.setRefreshing(true)
        
        do {
            let result = try await tokenRefreshService.refreshToken()
            
            KeychainManager.saveTokens(
                accessToken: result.accessToken,
                refreshToken: result.refreshToken
            )
            PotiLogger.debug("토큰 갱신 성공")
            
            await refreshState.setRefreshing(false)
            await refreshState.completeAll(with: .retry)
            
        } catch let error as PotiError where error.needsRelogin {
            PotiLogger.error(error)
            KeychainManager.deleteAllTokens()
            
            await refreshState.setRefreshing(false)
            await refreshState.completeAll(with: .doNotRetryWithError(error))
            
        } catch {
            PotiLogger.error(error)
            KeychainManager.deleteAllTokens()
            
            await refreshState.setRefreshing(false)
            await refreshState.completeAll(with: .doNotRetry)
        }
    }
}
