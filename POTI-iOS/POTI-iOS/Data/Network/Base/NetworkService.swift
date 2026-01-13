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

        let parameters = target.queryParameters ?? target.bodyParameters
        let encoding: ParameterEncoding =
            target.method == .get
            ? URLEncoding.default
            : JSONEncoding.default

        PotiLogger.network("➡️ \(target.method.rawValue) \(url)")

        do {
            return try await AF.request(
                url,
                method: target.method,
                parameters: parameters,
                encoding: encoding,
                headers: target.headers.value
            )
            .validate()
            .serializingDecodable(T.self)
            .value
        } catch {
            PotiLogger.error(error)
            throw PotiError.networkFail
        }
    }
}
