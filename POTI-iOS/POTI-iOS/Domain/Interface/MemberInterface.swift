//
//  MemberInterface.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

protocol MemberInterface {
    func fetchMemberList(artistId: Int) async throws -> [MemberEntity]
}
