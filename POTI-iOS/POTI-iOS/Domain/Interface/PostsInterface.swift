//
//  PostsInterface.swift
//  POTI-iOS
//
//  Created by mandoo on 1/20/26.
//

protocol PostsInterface {
    func fetchOrderOptions(postId: Int) async throws -> PotOptionsEntity
}
