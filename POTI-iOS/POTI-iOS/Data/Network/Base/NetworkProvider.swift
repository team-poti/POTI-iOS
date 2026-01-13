//
//  NetworkProvider.swift
//  POTI-iOS
//
//  Created by neon on 1/14/26.
//

import Alamofire
import Foundation

final class NetworkProvider {

    func request<T: Decodable>(
        target: BaseTargetType,
        type: T.Type
    ) async throws -> T {

        let url = URL(string: target.baseURL)!
            .appendingPathComponent(target.path)

        let parameters = target.queryParameters ?? target.bodyParameters

        let encoding: ParameterEncoding =
            target.method == .get
            ? URLEncoding.default
            : JSONEncoding.default

        PotiLogger.network("➡️ \(target.method.rawValue) \(url)")
        PotiLogger.network("Headers: \(target.headers.value)")
        PotiLogger.network("Parameters: \(parameters ?? [:])")

        do {
            let value = try await AF.request(
                url,
                method: target.method,
                parameters: parameters,
                encoding: encoding,
                headers: target.headers.value
            )
            .validate()
            .serializingDecodable(T.self)
            .value

            PotiLogger.network("✅ Success: \(target.path)")
            return value

        } catch {
            PotiLogger.error("❌ Network Error: \(error)" as! Error)
            throw NetworkError.networkFail
        }
    }
}
