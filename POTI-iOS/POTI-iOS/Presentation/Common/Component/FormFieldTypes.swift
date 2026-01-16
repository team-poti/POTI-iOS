//
//  FormFieldTypes.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/15/26.
//

import Foundation

enum FormFieldVariant {
    case short
    case long
    case count(max: Int)
    case dropdown
    case search(mode: SearchMode)
}

enum SearchMode {
    case navigate   // 탭 시 다른 검색 화면으로 이동
    case suggest    // 입력 시 하단에 추천 리스트 표시
}

enum FormFieldUIState: Equatable {
    case normal
    case focused
    case error(String)
}
