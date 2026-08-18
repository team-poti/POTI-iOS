//
//  SearchSuggestionDTO.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

struct SearchSuggestionDTO: Decodable {
    let type: String
    let value: String

    func toEntity() -> SearchSuggestionEntity {
        let suggestionType: SearchSuggestionType

        switch type {
        case "ARTIST":
            suggestionType = .artist
        case "TITLE":
            suggestionType = .title
        default:
            suggestionType = .unknown
        }

        return SearchSuggestionEntity(type: suggestionType, value: value)
    }
}
