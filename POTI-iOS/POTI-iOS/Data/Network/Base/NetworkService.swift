//
//  NetworkService.swift
//  POTI-iOS
//
//  Created by neon on 1/14/26.
//

import Alamofire

final class NetworkService {

    func request<T: Decodable>(
        target: BaseTargetType,
        type: T.Type
    ) async throws -> T {
        
        let baseURL = try AppConfig.baseURL()
        let url = baseURL.appendingPathComponent(target.path)
        
        let parameters: Parameters?
        let parameterType: String
        
        if let query = target.queryParameters {
            parameters = query
            parameterType = "QUERY"
        } else if let body = target.bodyParameters {
            parameters = body
            parameterType = "BODY"
        } else {
            parameters = nil
            parameterType = "NONE"
        }
        
        let encoding: ParameterEncoding =
        target.method == .get || parameterType == "QUERY"
        ? URLEncoding.default
        : JSONEncoding.default
        
        PotiLogger.network("🌐 [REQUEST]")
        PotiLogger.network("URL: \(url)")
        PotiLogger.network("METHOD: \(target.method.rawValue)")
        PotiLogger.network("HEADER: \(target.headers.value)")
        PotiLogger.network("PARAMS: \(parameterType)")
        PotiLogger.network("DETAIL: \(parameters ?? [:])")
        
        let response = await AF.request(
            url,
            method: target.method,
            parameters: parameters,
            encoding: encoding,
            headers: target.headers.value
        )
        .validate(statusCode: 200..<600)
        .serializingDecodable(BaseResponseDTO<T>.self)
        .response
        
        switch response.result {
            
        case .success(let baseResponse):
            PotiLogger.network("🌐 [RESPONSE START]")

            guard let http = response.response else {
                let error = PotiError.networkFail
                PotiLogger.error(error)
                throw error
            }

            PotiLogger.network("STATUS : \(http.statusCode)")
            PotiLogger.network("HEADER : \(http.headers)")
            
            if let data = response.data,
               let jsonString = String(data: data, encoding: .utf8) {
                PotiLogger.network("BODY : \(jsonString)")
            }
            
            if (200...299).contains(baseResponse.code) {
                guard let data = baseResponse.data else {
                    let error = PotiError.decodingError
                    PotiLogger.error(error)
                    throw error
                }
                return data
            } else {
                let error = mapErrorCode(baseResponse.code, message: baseResponse.message)
                PotiLogger.error(error)
                throw error
            }
    
        case .failure:
            guard let http = response.response else {
                let error = PotiError.networkFail
                PotiLogger.error(error)
                throw error
            }
            
            let statusCode = http.statusCode
            
            let error: PotiError
            switch statusCode {
            case 400:
                error = .badRequest
            case 401:
                error = .unauthorized
            case 404:
                error = .notFound
            case 500...599:
                error = .internalServerError
            default:
                error = .networkFail
            }
            
            PotiLogger.error(error)
            
            PotiLogger.network("❌ [RESPONSE FAIL]")
            PotiLogger.network("STATUS : \(statusCode)")
            PotiLogger.network("PATH : \(target.path)")
            PotiLogger.network("DESCRIPTION : \(http.debugDescription)")
            
            throw error
        }
    }
    
    private func mapErrorCode(_ code: Int, message: String) -> PotiError {
        switch code {
        case 40100:
            return .invalidToken
        case 40101:
            return .tokenExpired
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 404:
            return .notFound
        case 500...599:
            return .internalServerError
        default:
            return .apiError(message: message)
        }
    }
}
