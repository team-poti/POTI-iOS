//
//  DefaultMemberRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

final class DefaultMemberRepository: MemberInterface {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchMemberList(artistId: Int) async throws -> [MemberEntity] {
        
        // TODO: - 서버 데이터 연결하기
        
        //        let memberData = try await networkService.request(
        //            target: MemberAPI.fetchMemberList(artistId: artistId),
        //            type: MemberDataDTO.self
        //        )
        //        return memberData.members.map { $0.toEntity() }
        
        return [
            MemberEntity(memberId: 1, memberName: "원영"),
            MemberEntity(memberId: 1, memberName: "유진"),
            MemberEntity(memberId: 2, memberName: "가을"),
            MemberEntity(memberId: 3, memberName: "레이"),
            MemberEntity(memberId: 4, memberName: "원영"),
            MemberEntity(memberId: 5, memberName: "리즈"),
            MemberEntity(memberId: 6, memberName: "이서")
        ]
    }
}
