//
//  BaseResponseDTO.swift
//  POTI-iOS
//
//  Created by neon on 1/14/26.
//

struct BaseResponseDTO<T: Decodable>: Decodable {
    let code: Int
    let message: String
    let data: T?

    private enum CodingKeys: String, CodingKey {
        case code
        case message
        case msg
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        code = try container.decode(Int.self, forKey: .code)
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? container.decode(String.self, forKey: .msg)
        data = try container.decodeIfPresent(T.self, forKey: .data)
    }
}
