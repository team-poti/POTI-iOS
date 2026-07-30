//
//  PotOptionsViewState.swift
//  POTI-iOS
//
//  Created by soomin on 7/28/26.
//

struct PotOptionsViewState {
    struct SelectedOption {
        let id: Int
        let name: String
        let priceText: String
    }
    
    let memberDropdownItems: [DropdownItem]
    let deliveryDropdownItems: [DropdownItem]
    let selectedMembers: [SelectedOption]
    let selectedDelivery: SelectedOption?
    let totalPriceText: String
    let isContinueEnabled: Bool
    
    static let initial = PotOptionsViewState(
        memberDropdownItems: [], deliveryDropdownItems: [],
        selectedMembers: [], selectedDelivery: nil,
        totalPriceText: "0원", isContinueEnabled: false
    )
}
