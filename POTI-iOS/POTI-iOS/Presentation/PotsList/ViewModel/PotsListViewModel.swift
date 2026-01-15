//
//  PotsListViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

import Foundation

import Combine

final class PotsListViewModel {

    // MARK: - Input

    let viewDidLoad = PassthroughSubject<Void, Never>()

    // MARK: - Output

    @Published private(set) var pots: [Pot] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        bindInput()
    }

    private func bindInput() {
        viewDidLoad
            .sink { [weak self] in
                self?.fetchPotsListData()
            }
            .store(in: &cancellables)
    }

    // TODO: - 서버 데이터로 변경하기

    private func fetchPotsListData() {
        self.pots = [
            Pot(user: UserEntity(id: 1, nickname: "수민이다"), profileImage: "https://sitem.ssgcdn.com/95/80/89/item/1000571898095_i1_750.jpg", rating: 4.8, currentCount: 6, totalCount: 7, availableMembers: ["원영", "유진", "이서", "레이","원영", "유진", "이서", "레이","원영", "유진", "이서", "레이"], price: 5000, thumbnailUrl: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", status: "RECURTING"),
            Pot(user: UserEntity(id: 2, nickname: "나연이다"), profileImage: "https://sitem.ssgcdn.com/95/80/89/item/1000571898095_i1_750.jpg", rating: 4.8, currentCount: 6, totalCount: 7, availableMembers: ["원영", "유진", "이서", "레이"], price: 5000, thumbnailUrl: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", status: "RECURTING"),
            Pot(user: UserEntity(id: 3, nickname: "서현이다"), profileImage: "https://sitem.ssgcdn.com/95/80/89/item/1000571898095_i1_750.jpg", rating: 4.8, currentCount: 6, totalCount: 7, availableMembers: ["원영", "유진", "이서", "레이"], price: 5000, thumbnailUrl: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", status: "RECURTING"),
            Pot(user: UserEntity(id: 4, nickname: "정환이다"), profileImage: "https://sitem.ssgcdn.com/95/80/89/item/1000571898095_i1_750.jpg", rating: 4.8, currentCount: 6, totalCount: 7, availableMembers: ["원영", "유진", "이서", "레이"], price: 5000, thumbnailUrl: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", status: "RECURTING"),
            Pot(user: UserEntity(id: 5, nickname: "수민이다"), profileImage: "https://sitem.ssgcdn.com/95/80/89/item/1000571898095_i1_750.jpg", rating: 4.8, currentCount: 6, totalCount: 7, availableMembers: ["원영", "유진", "이서", "레이"], price: 5000, thumbnailUrl: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", status: "RECURTING"),
        ]
    }
}
