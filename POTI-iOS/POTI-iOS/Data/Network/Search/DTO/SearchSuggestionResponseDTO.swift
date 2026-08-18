//
//  SearchSuggestionResponseDTO.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

struct SearchSuggestionResponseDTO: Decodable {
    let suggestions: [SearchSuggestionDTO]

    func toEntity() -> [SearchSuggestionEntity] {
        return suggestions.map { $0.toEntity() }
    }
}
