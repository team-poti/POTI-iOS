//
//  MaPageNavigationButton.swift
//  POTI-iOS
//
//  Created by neon on 1/16/26.
//

enum FilterType: Int, CaseIterable {
    case all = 0
    case ongoing = 1
    case completed = 2
    
    var title: String {
        switch self {
        case .all: return "전체"
        case .ongoing: return "진행중"
        case .completed: return "종료"
        }
    }
}
