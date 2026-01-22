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
    .init(memberOptionId: 1, memberName: "원영", memberOptionPrice: 17000),
    .init(memberOptionId: 2, memberName: "레이", memberOptionPrice: 9000),
    .init(memberOptionId: 3, memberName: "이서", memberOptionPrice: 17000),
    .init(memberOptionId: 4, memberName: "유진", memberOptionPrice: 15000),
    .init(memberOptionId: 5, memberName: "가을", memberOptionPrice: 9000),
    .init(memberOptionId: 6, memberName: "리즈", memberOptionPrice: 10000),
])
