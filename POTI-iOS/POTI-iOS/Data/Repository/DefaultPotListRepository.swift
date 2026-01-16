//
//  DefaultPotListRepository.swift
//  POTI-iOS
//
//  Created by mandoo on 1/16/26.
//

final class DefaultPotListRepository: PotListInterface {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchPotListData() async throws -> PotListEntity {
        
        // TODO: - 서버 데이터 연결하기
        
        //        let potListDTO = try await networkService.request(
        //            target: PotListAPI.fetchPotList,
        //            type: PotListDTO.self
        //        )
        //        return potListDTO.toEntity()
        
        return PotListEntity(postTitle: "아이브 포카", artistId: 2, artist: "아이브", currentPage: 1, hasNext: true, pots: [Pot(potId: 1, price: 4000, thumbnailUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5Y2aT5CXCSJTzpk-y6DdcXWwnE62Uo0jmxg&s", currentCount: 2, totalCount: 7, status: "RECRUITING", availableMembers: ["레이", "이서"], uploader: Uploader(userId: 1, nickname: "티티들", profileImage: "https://ecimg.cafe24img.com/pg1501b97666319045/leaz2023/file_data/b911e1548d898abe5c763017c331efba.jpg", rating: 4.7)), Pot(potId: 1, price: 4000, thumbnailUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5Y2aT5CXCSJTzpk-y6DdcXWwnE62Uo0jmxg&s", currentCount: 2, totalCount: 7, status: "RECRUITING", availableMembers: ["레이", "이서"], uploader: Uploader(userId: 1, nickname: "티티들", profileImage: "https://ecimg.cafe24img.com/pg1501b97666319045/leaz2023/file_data/b911e1548d898abe5c763017c331efba.jpg", rating: 4.7)), Pot(potId: 1, price: 4000, thumbnailUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5Y2aT5CXCSJTzpk-y6DdcXWwnE62Uo0jmxg&s", currentCount: 2, totalCount: 7, status: "RECRUITING", availableMembers: ["레이", "이서"], uploader: Uploader(userId: 1, nickname: "티티들", profileImage: "https://ecimg.cafe24img.com/pg1501b97666319045/leaz2023/file_data/b911e1548d898abe5c763017c331efba.jpg", rating: 4.7)), Pot(potId: 1, price: 4000, thumbnailUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5Y2aT5CXCSJTzpk-y6DdcXWwnE62Uo0jmxg&s", currentCount: 2, totalCount: 7, status: "RECRUITING", availableMembers: ["레이", "이서"], uploader: Uploader(userId: 1, nickname: "티티들", profileImage: "https://ecimg.cafe24img.com/pg1501b97666319045/leaz2023/file_data/b911e1548d898abe5c763017c331efba.jpg", rating: 4.7)), Pot(potId: 1, price: 4000, thumbnailUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5Y2aT5CXCSJTzpk-y6DdcXWwnE62Uo0jmxg&s", currentCount: 2, totalCount: 7, status: "CLOSED", availableMembers: ["레이", "이서"], uploader: Uploader(userId: 1, nickname: "티티들", profileImage: "https://ecimg.cafe24img.com/pg1501b97666319045/leaz2023/file_data/b911e1548d898abe5c763017c331efba.jpg", rating: 4.7))])
    }
}
