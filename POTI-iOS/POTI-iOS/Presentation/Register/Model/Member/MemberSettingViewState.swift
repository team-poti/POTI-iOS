//
//  MemberSettingViewState.swift
//  POTI-iOS
//
//  Created by soomin on 8/11/26.
//

struct MemberSettingViewState: Equatable {
    enum Content: Equatable {
        case artistNotSelected
        case members([RegisterMemberItem])
        case noSelectedMembers
    }

    let content: Content
    let error: MemberSettingValidationError?
    let showsGuide: Bool
}

enum MemberSettingAction {
    case priceChanged(memberID: Int, price: Int?)
    case editButtonTapped
}

struct RegisterMemberSelectionRequest {
    let members: [RegisterMemberItem]
}
