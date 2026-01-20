//
//  PotDetailModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

struct PotDetailModel {
    let status: String
    let artist: String
    let title: String
    let price: Int
    let uploadTime: String
    let content: String
    let deadline: String
    let uploader: UploaderModel
    let shippingOptions: [ShippingOptionModel]
    let participants: [ParticipantInfoModel]
    let images: [String]
    let currentCount: Int
    let totalCount: Int
}
