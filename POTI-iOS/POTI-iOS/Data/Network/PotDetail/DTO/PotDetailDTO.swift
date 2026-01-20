//
//  PotDetailDTO.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

struct PotDetailDTO: Decodable {
    let postId: Int
    let isMyPost: Bool
    let status: String
    let artist: String
    let artistId: Int
    let title: String
    let price: Int
    let uploadTime: String
    let deadline: String
    let images: [PostImageDTO]
    let content: String
    let shippingOptions: [ShippingOptionDTO]
    let uploader: UploaderDTO
    let currentCount: Int
    let totalCount: Int
    let participants: [ParticipantDTO]
    
    func toEntity() -> PotDetailEntity {
        return PotDetailEntity(
            postId: postId,
            isMyPost: isMyPost,
            status: status,
            artist: artist,
            title: title,
            price: price,
            uploadTime: uploadTime,
            deadline: deadline,
            images: images.map { $0.imageUrl },
            content: content,
            shippingOptions: shippingOptions.map { $0.toEntity() },
            uploader: uploader.toEntity(),
            currentCount: currentCount,
            totalCount: totalCount,
            participants: participants.map { $0.toEntity() }
        )
    }
}

struct PostImageDTO: Decodable {
    let sortOrder: Int
    let imageUrl: String
}

struct ShippingOptionDTO: Decodable {
    let shippingId: Int
    let name: String
    let price: Int
    
    func toEntity() -> ShippingOption {
        return ShippingOption(
            shippingId: shippingId,
            name: name,
            price: price
        )
    }
}

struct UploaderDTO: Decodable {
    let userId: Int
    let nickname: String
    let profileImage: String?
    let rating: Double
    let reviewCount: Int
    
    func toEntity() -> Uploader {
        return Uploader(
            userId: userId,
            nickname: nickname,
            profileImage: profileImage ?? "",
            rating: rating,
            reviewCount: reviewCount
        )
    }
}

struct ParticipantDTO: Decodable {
    let userId: Int
    let nickname: String
    let profileImage: String?
    let rating: Double
    let selectedMembers: [String]
    
    func toEntity() -> ParticipantInfo {
        return ParticipantInfo(
            userId: userId,
            nickname: nickname,
            profileImage: profileImage ?? "",
            rating: rating,
            selectedMembers: selectedMembers
        )
    }
}
