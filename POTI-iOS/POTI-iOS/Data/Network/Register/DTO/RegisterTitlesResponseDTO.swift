//
//  RegisterTitlesResponseDTO.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/22/26.
//

struct RegisterTitlesResponseDTO: Decodable {
    let titles: [String?]
}

extension RegisterTitlesResponseDTO {
    func toEntities() -> [String?] {
        titles
    }
}
