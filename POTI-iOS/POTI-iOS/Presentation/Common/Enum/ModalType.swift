//
//  ModalType.swift
//  POTI-iOS
//
//  Created by soomin on 7/30/26.
//

enum ModalType {
    case participate
    case register
    
    var title: String {
        switch self {
        case .participate:
            "참여자 안내 사항"
        case .register:
            "모집자 안내사항"
        }
    }
    
    var pointText: String {
        switch self {
        case .participate:
            "참여 전 꼭 확인해 주세요!"
        case .register:
            "모집 전 꼭 확인해 주세요!"
        }
    }
}
