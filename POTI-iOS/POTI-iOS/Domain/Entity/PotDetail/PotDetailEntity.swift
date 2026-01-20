//
//  PotDetailEntity.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

struct PotDetailEntity {
    let postId: Int
    let isMyPost: Bool
    let status: String
    let artist: String
    let title: String
    let price: Int
    let uploadTime: String
    let deadline: String
    let images: [String]
    let content: String
    let shippingOptions: [ShippingOption]
    let uploader: Uploader
    let currentCount: Int
    let totalCount: Int
    let participants: [ParticipantInfo]
    
    init(postId: Int, isMyPost: Bool, status: String, artist: String, title: String, price: Int, uploadTime: String, deadline: String, images: [String], content: String, shippingOptions: [ShippingOption], uploader: Uploader, currentCount: Int, totalCount: Int, participants: [ParticipantInfo]) {
        self.postId = postId
        self.isMyPost = isMyPost
        self.status = status
        self.artist = artist
        self.title = title
        self.price = price
        self.uploadTime = uploadTime
        self.deadline = deadline
        self.images = images
        self.content = content
        self.shippingOptions = shippingOptions
        self.uploader = uploader
        self.currentCount = currentCount
        self.totalCount = totalCount
        self.participants = participants
    }

    func toPotDetailModel() -> PotDetailModel {
        return PotDetailModel(
            status: status,
            artist: artist,
            title: title,
            price: price,
            uploadTime: uploadTime,
            content: content,
            deadline: deadline,
            uploader: uploader.toUploaderModel(),
            shippingOptions: shippingOptions.map { $0.toShippingOptionModel() },
            participants: participants.map { $0.toParticipantInfoModel() },
            images: images,
            currentCount: currentCount,
            totalCount: totalCount
        )
    }
}

struct ParticipantInfo {
    let userId: Int
    let nickname: String
    let profileImage: String
    let rating: Double
    let selectedMembers: [String]
    
    func toParticipantInfoModel() -> ParticipantInfoModel {
        return ParticipantInfoModel(
            userId: userId,
            nickname: nickname,
            profileImage: profileImage,
            rating: rating,
            selectedMembers: selectedMembers
        )
    }
}

struct Uploader {
    let userId: Int
    let nickname: String
    let profileImage: String
    let rating: Double
    let reviewCount: Int
    
    func toUploaderModel() -> UploaderModel {
        return UploaderModel(
            userId: userId,
            nickname: nickname,
            profileImage: profileImage,
            rating: rating,
            reviewCount: reviewCount
        )
    }
}

struct ShippingOption {
    let shippingId: Int
    let name: String
    let price: Int
    
    func toShippingOptionModel() -> ShippingOptionModel {
        return ShippingOptionModel(
            shippingId: shippingId,
            name: name,
            price: price
        )
    }
}
