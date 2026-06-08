//
//  PotListEntity.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
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
}

struct Pot {
    let potId: Int
    let price: Int
    let thumbnailUrl: String
    let currentCount: Int
    let totalCount: Int
    let status: String
    let availableMembers: [String]
    let recruiter: Recruiter

    init(potId: Int, price: Int, thumbnailUrl: String, currentCount: Int, totalCount: Int, status: String, availableMembers: [String], recruiter: Recruiter) {
        self.potId = potId
        self.price = price
        self.thumbnailUrl = thumbnailUrl
        self.currentCount = currentCount
        self.totalCount = totalCount
        self.status = status
        self.availableMembers = availableMembers
        self.recruiter = recruiter
    }
}

struct Recruiter {
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
}
