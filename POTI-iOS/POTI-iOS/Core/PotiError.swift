//
//  PotiError.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/9/26.
//

import Foundation

enum PotiError: Error, LocalizedError, Equatable {
    case apiError(message: String)
    case badRequest
    case unauthorized
    case tokenExpired
    case invalidToken
    case notFound
    case internalServerError
    case decodingError
    case networkFail
    case missingConfig(key: String)
    case kakaoOuathError
    case invalidPresignedUrl
    
    var needsRelogin: Bool {
        switch self {
        case .tokenExpired, .invalidToken:
            return true
        default:
            return false
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .apiError(let message):
            return message
        case .badRequest:
            return "잘못된 요청입니다"
        case .unauthorized:
            return "인증이 필요합니다"
        case .tokenExpired:
            return "만료된 토큰입니다"
        case .invalidToken:
            return "유효하지 않은 토큰입니다"
        case .notFound:
            return "리소스를 찾을 수 없습니다"
        case .internalServerError:
            return "서버 오류가 발생했습니다"
        case .decodingError:
            return "데이터 변환 중 오류가 발생했습니다"
        case .networkFail:
            return "네트워크 연결에 실패했습니다"
        case .missingConfig(let key):
            return "\(key) 설정이 누락되었습니다."
        case .kakaoOuathError:
            return "카카오톡 로그인에 실패했습니다."
        case .invalidPresignedUrl:
            return "유효하지 않은 업로드 URL입니다"
        }
    }
}
