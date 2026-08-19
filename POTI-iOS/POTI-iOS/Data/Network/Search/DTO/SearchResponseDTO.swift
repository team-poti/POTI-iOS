//
//  SearchResponseDTO.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

struct SearchResponseDTO: Decodable {
    let content: [SearchResultDTO]
    let number: Int
    let last: Bool

    func toEntity() -> SearchResultPageEntity {
        return SearchResultPageEntity(results: content.map { $0.toEntity() }, currentPage: number, hasNext: !last)
    }
}
