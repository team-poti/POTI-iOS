//
//  RegisterTitlesResponseDTO.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/22/26.
//

struct RegisterTitlesResponseDTO: Decodable {
    let code: Int
    let msg: String
    let data: DataDTO

    struct DataDTO: Decodable {
        let titles: [String]
    }
}

extension RegisterTitlesResponseDTO {
    func toEntities() -> [String] {
        data.titles
    }
}
