//
//  IdolGroupModel.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

struct IdolGroupModel {
    let id: Int
    let name: String
    let image: String
    
    // TODO: - 더미 데이터(추후 지울것)
    static func dummyGroups() -> [IdolGroupModel] {
        let sampleImage = "https://occ-0-8407-90.1.nflxso.net/dnm/api/v6/6AYY37jfdO6hpXcMjf9Yu5cnmO0/AAAABdsgLVkKKYiwBCjD8PtxEvP2NzSL2LrVwuvAjeTkAmrdMyTzo4bWmAP7GwLtuFgp0FwYf1CuBxfoPKwd9WTwVwTDkYWeX4qj7u80.jpg?r=1d8"
        return (1...15).map { index in
            IdolGroupModel(
                id: index,
                name: "앙티티",
                image: sampleImage
            )
        }
    }
}
