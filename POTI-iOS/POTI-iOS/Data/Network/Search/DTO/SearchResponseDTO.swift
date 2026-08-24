//
//  SearchResponseDTO.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

struct SearchResponseDTO: Decodable {
    let content: [SearchResultDTO]
    let hasNext: Bool

    func toEntity(currentPage: Int) -> SearchResultPageEntity {
        return SearchResultPageEntity(results: content.map { $0.toEntity() }, currentPage: currentPage, hasNext: hasNext)
    }
}
