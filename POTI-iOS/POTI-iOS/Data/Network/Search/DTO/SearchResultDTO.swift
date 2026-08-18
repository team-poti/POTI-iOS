//
//  SearchResultDTO.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

struct SearchResultDTO: Decodable {
    let artist: String
    let artistId: Int
    let postImage: String?
    let postTitle: String
    let postCount: Int
    let tag: String?

    func toEntity() -> SearchResultEntity {
        return SearchResultEntity(artist: artist, artistId: artistId, postImage: postImage, postTitle: postTitle, postCount: postCount, tag: tag)
    }
}
