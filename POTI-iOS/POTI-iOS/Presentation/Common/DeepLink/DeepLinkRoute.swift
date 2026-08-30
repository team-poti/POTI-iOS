//
//  DeepLinkRoute.swift
//  POTI-iOS
//
//  Created by soomin on 8/24/26.
//

enum DeepLinkRoute: Equatable {
    case potDetail(postID: Int)
    case participantDetail(participationID: Int)
    case recruiterDetail(postID: Int)
    case participantManagement(postID: Int)
}
