//
//  PotModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

struct PotModel {
    var uploader: UploaderModel
    let profileImage: String
    let rating: Double
    let currentCount: Int
    let totalCount: Int
    let availableMembers: [String]
    let price: Int
    let thumbnailUrl: String
    var status: String
}
