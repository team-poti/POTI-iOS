//
//  GoodsListViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import Foundation

import Combine

final class GoodsListViewModel {
    
    // MARK: - Input
    
    let viewDidLoad = PassthroughSubject<Void, Never>()
    
    // MARK: - Output
    
    @Published private(set) var popularGoods: [Goods] = []
    @Published private(set) var recentGoods: [Goods] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bindInput()
    }
    
    private func bindInput() {
        viewDidLoad
            .sink { [weak self] in
                self?.fetchGoodsListData()
            }
            .store(in: &cancellables)
    }
    
    // TODO: - 서버 데이터로 변경하기
    
    private func fetchGoodsListData() {
        self.popularGoods = [
            Goods(id: 0, artistName: "아이브", productName: "아이브앨범", imageURL: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", numberOfPot: 10),
            Goods(id: 1, artistName: "아이브", productName: "아이브앨범", imageURL: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", numberOfPot: 20),
            Goods(id: 2, artistName: "아이브", productName: "아이브앨범", imageURL: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", numberOfPot: 1),
            Goods(id: 3, artistName: "아이브", productName: "아이브앨범", imageURL: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", numberOfPot: 2),
            Goods(id: 4, artistName: "아이브", productName: "아이브앨범", imageURL: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", numberOfPot: 3)
        ]
        
        self.recentGoods = [
            Goods(id: 0, artistName: "아이브", productName: "아이브앨범", imageURL: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", numberOfPot: 10),
            Goods(id: 1, artistName: "아이브", productName: "아이브앨범", imageURL: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", numberOfPot: 20),
            Goods(id: 2, artistName: "아이브", productName: "아이브앨범", imageURL: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", numberOfPot: 1),
            Goods(id: 3, artistName: "아이브", productName: "아이브앨범", imageURL: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", numberOfPot: 2),
            Goods(id: 4, artistName: "아이브", productName: "아이브앨범", imageURL: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", numberOfPot: 3)
        ]
    }
}

