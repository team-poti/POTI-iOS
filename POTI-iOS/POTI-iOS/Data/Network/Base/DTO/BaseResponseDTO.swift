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
}
