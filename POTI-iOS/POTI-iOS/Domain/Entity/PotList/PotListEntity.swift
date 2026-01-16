//
//  PotListEntity.swift
//  POTI-iOS
//
//  Created by mandoo on 1/16/26.
//

struct PotListEntity {
    let postTitle: String
    let artistId: Int
    let artist: String
    let currentPage: Int
    let hasNext: Bool
    let pots: [Pot]
    
    init(postTitle: String, artistId: Int, artist: String, currentPage: Int, hasNext: Bool, pots: [Pot]) {
        self.postTitle = postTitle
        self.artistId = artistId
        self.artist = artist
        self.currentPage = currentPage
        self.hasNext = hasNext
        self.pots = pots
    }
    
    func toPotModel() -> [PotModel] {
        return pots.map { $0.toPotModel() }
    }
}

struct Pot {
    let potId: Int
    let price: Int
    let thumbnailUrl: String
    let currentCount: Int
    let totalCount: Int
    let status: String
    let availableMembers: [String]
    let uploader: Uploader
    
    init(potId: Int, price: Int, thumbnailUrl: String, currentCount: Int, totalCount: Int, status: String, availableMembers: [String], uploader: Uploader) {
        self.potId = potId
        self.price = price
        self.thumbnailUrl = thumbnailUrl
        self.currentCount = currentCount
        self.totalCount = totalCount
        self.status = status
        self.availableMembers = availableMembers
        self.uploader = uploader
    }
    
    func toPotModel() -> PotModel {
        PotModel(uploader: uploader.toUploadModel(), profileImage: uploader.profileImage, rating: uploader.rating, currentCount: currentCount, totalCount: totalCount, availableMembers: availableMembers, price: price, thumbnailUrl: thumbnailUrl, status: status)
    }
}

struct Uploader {
    let userId: Int
    let nickname: String
    let profileImage: String
    let rating: Double
    
    init(userId: Int, nickname: String, profileImage: String, rating: Double) {
        self.userId = userId
        self.nickname = nickname
        self.profileImage = profileImage
        self.rating = rating
    }
    
    func toUploadModel() -> UploaderModel {
        UploaderModel(userId: userId, nickname: nickname, profileImage: profileImage, rating: rating)
    }
}
