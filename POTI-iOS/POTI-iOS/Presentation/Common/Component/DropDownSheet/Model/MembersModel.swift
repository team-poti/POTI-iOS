//
//  Members.swift
//  POTI-iOS
//
//  Created by mandoo on 1/20/26.
//

struct MemberModel {
    let memberOptionId: Int
    let memberName: String
    let memberOptionPrice: Int
}

let mockMembers: [MemberModel] = .init([
    .init(memberOptionId: 1, memberName: "1", memberOptionPrice: 10000),
    .init(memberOptionId: 2, memberName: "2", memberOptionPrice: 5000),
    .init(memberOptionId: 3, memberName: "3", memberOptionPrice: 17000),
    .init(memberOptionId: 4, memberName: "4", memberOptionPrice: 10000),
    .init(memberOptionId: 5, memberName: "5", memberOptionPrice: 5000),
    .init(memberOptionId: 6, memberName: "6", memberOptionPrice: 17000),
    .init(memberOptionId: 7, memberName: "7", memberOptionPrice: 10000),
])
