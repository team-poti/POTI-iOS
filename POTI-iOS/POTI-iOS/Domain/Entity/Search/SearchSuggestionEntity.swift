//
//  SearchSuggestionEntity.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

enum SearchSuggestionType {
    case artist
    case title
    case unknown
}

struct SearchSuggestionEntity {
    let type: SearchSuggestionType
    let value: String
}
