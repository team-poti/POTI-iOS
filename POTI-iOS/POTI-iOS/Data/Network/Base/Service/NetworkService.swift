//
//  NetworkService.swift
//  POTI-iOS
//
//  Created by neon on 1/14/26.
//

import Foundation
import Alamofire

final class NetworkService: Sendable {
    
    private let interceptor: AuthInterceptor?
    
    init(interceptor: AuthInterceptor? = nil) {
        self.interceptor = interceptor
    }

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
        PotiLogger.network("URL: \(NetworkLogSanitizer.url(url))")
        PotiLogger.network("METHOD: \(target.method.rawValue)")
        PotiLogger.network("HEADER: \(NetworkLogSanitizer.headers(target.headers))")
        PotiLogger.network("PARAMS: \(parameterType)")
        PotiLogger.network("DETAIL: \(NetworkLogSanitizer.parameters(parameters))")
        
        let response = await AF.request(
            url,
            method: target.method,
            parameters: parameters,
            encoding: encoding,
            headers: target.headers,
            interceptor: interceptor
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
            PotiLogger.network("HEADER : \(NetworkLogSanitizer.headers(http.headers))")
            
            if let data = response.data {
                PotiLogger.network("BODY : \(NetworkLogSanitizer.body(data))")
            }
            
            if (200...299).contains(baseResponse.code) {
                if let data = baseResponse.data {
                    return data
                } else {
                    if T.self == EmptyResponse.self {
                        return EmptyResponse() as! T
                    } else {
                        let error = PotiError.decodingError
                        PotiLogger.error(error)
                        throw error
                    }
                }
            } else {
                let error = mapErrorCode(baseResponse.code, message: baseResponse.message)
                PotiLogger.error(error)
                throw error
            }
    
        case .failure(let underlyingError):
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

            if let data = response.data,
               !data.isEmpty {
                PotiLogger.network("BODY : \(NetworkLogSanitizer.body(data))")
            }
            PotiLogger.network("UNDERLYING ERROR : \(underlyingError)")
            
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

// MARK: - Network Log Sanitizer

private enum NetworkLogSanitizer {
    private static let maskedValue = "***"
    private static let sensitiveHeaderNames = ["authorization", "cookie", "set-cookie"]

    static func url(_ url: URL) -> String {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url.absoluteString }

        components.queryItems = components.queryItems?.map { item in
            isSensitive(item.name) ? URLQueryItem(name: item.name, value: maskedValue) : item
        }
        return components.url?.absoluteString ?? url.absoluteString
    }

    static func headers(_ headers: HTTPHeaders) -> [String: String] {
        Dictionary(uniqueKeysWithValues: headers.map { header in
            let value = sensitiveHeaderNames.contains(header.name.lowercased()) ? maskedValue : header.value
            return (header.name, value)
        })
    }

    static func parameters(_ parameters: Parameters?) -> Any {
        sanitize(parameters ?? [:])
    }

    static func body(_ data: Data) -> String {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data),
              let sanitizedData = try? JSONSerialization.data(withJSONObject: sanitize(jsonObject)),
              let sanitizedBody = String(data: sanitizedData, encoding: .utf8) else {
            return "<non-JSON body: \(data.count) bytes>"
        }
        return sanitizedBody
    }

    private static func sanitize(_ value: Any) -> Any {
        if let dictionary = value as? [String: Any] {
            return dictionary.reduce(into: [String: Any]()) { result, element in
                result[element.key] = isSensitive(element.key) ? maskedValue : sanitize(element.value)
            }
        }

        if let array = value as? [Any] {
            return array.map(sanitize)
        }

        return value
    }

    private static func isSensitive(_ key: String) -> Bool {
        key.lowercased().contains("token")
    }
}
