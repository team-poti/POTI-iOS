//
//  MemberResponseDTO.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

struct MemberResponseDTO: Decodable {
    let data: MemberDataDTO
}

struct MemberDataDTO: Decodable {
    let members: [MemberDTO]
}

struct MemberDTO: Decodable {
    let memberId: Int
    let name: String
    
    func toEntity() -> MemberEntity {
        return MemberEntity(memberId: memberId, memberName: name)
    }
}
