//
//  DefaultAuthRepository.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

final class DefaultAuthRepository: AuthInterface {

    func login() -> Bool {
        // TODO: 나중에 네트워크 연결
        PotiLogger.network("Mock Login Success")
        return true
    }
}
