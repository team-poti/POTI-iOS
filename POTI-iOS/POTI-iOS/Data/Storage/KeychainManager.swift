//
//  KeychainManager.swift
//  POTI-iOS
//
//  Created by neon on 1/19/26.
//

import Foundation
import Security

enum KeyType: String, CaseIterable {
    case accessToken
    case refreshToken
}

enum KeychainManager {
    
    // MARK: - Save
    
    static func save(key: KeyType, token: String) {
        let data = token.data(using: .utf8, allowLossyConversion: false) as Any
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            PotiLogger.debug("Keychain \(key.rawValue) 저장 성공")
        } else {
            PotiLogger.error(NSError(domain: "Keychain Save Error", code: Int(status)))
        }
    }
    
    // MARK: - Load
    
    static func load(key: KeyType) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess {
            PotiLogger.debug("Keychain \(key.rawValue) 로드 실패 (없음)")
            return nil
        }
        
        guard let data = item as? Data,
              let token = String(data: data, encoding: .utf8) else {
            PotiLogger.error(NSError(domain: "Keychain Decoding Error", code: -1))
            return nil
        }
        
        PotiLogger.debug("Keychain \(key.rawValue) 로드 성공")
        return token
    }
    
    // MARK: - Delete
    
    static func delete(key: KeyType) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ]
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            PotiLogger.debug("Keychain \(key.rawValue) 삭제 성공")
        } else {
            PotiLogger.debug("Keychain \(key.rawValue) 삭제 실패 (없음)")
        }
    }
    
    // MARK: - Convenience Methods
    
    static func saveTokens(accessToken: String, refreshToken: String?) {
        save(key: .accessToken, token: accessToken)
        if let refreshToken = refreshToken {
            save(key: .refreshToken, token: refreshToken)
        }
    }
    
    static func getAccessToken() -> String? {
        return load(key: .accessToken)
    }
    
    static func getRefreshToken() -> String? {
        return load(key: .refreshToken)
    }
    
    static func deleteAllTokens() {
        KeyType.allCases.forEach { delete(key: $0) }
        PotiLogger.debug("모든 토큰 삭제 완료")
    }
    
    static func hasValidToken() -> Bool {
        let hasToken = getAccessToken() != nil
        PotiLogger.debug("Keychain accessToken 존재 여부: \(hasToken)")
        return hasToken
    }
}
