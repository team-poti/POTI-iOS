//
//  FCMTokenSyncService.swift
//  POTI-iOS
//
//  Created by soomin on 8/26/26.
//

protocol FCMTokenSyncService: AnyObject {
    func synchronize(token: String?) async
    func deleteToken() async throws
}
