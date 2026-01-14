//
//  HomeViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import Foundation

import Combine

final class HomeViewModel {
    
    // MARK: - Input
    
    let viewDidLoad = PassthroughSubject<Void, Never>()
    
    // MARK: - Output
    
    @Published private(set) var banners: [Banner] = []
    @Published private(set) var myGroupGoods: [Goods] = []
    @Published private(set) var otherGroupGoods: [Goods] = []
    @Published private(set) var nickName: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bindInput()
    }
    
    private func bindInput() {
        viewDidLoad
            .sink { [weak self] in
                self?.fetchHomeData()
            }
            .store(in: &cancellables)
    }
    
    // TODO: - 서버 데이터로 변경하기
    
    private func fetchHomeData() {
        self.banners = [
            Banner(id: 0, imageURL: "https://sports.hankooki.com/news/photo/202406/6865580_1085568_126.jpeg"),
            Banner(id: 1, imageURL: "https://sports.hankooki.com/news/photo/202406/6865580_1085568_126.jpeg"),
            Banner(id: 2, imageURL: "https://sports.hankooki.com/news/photo/202406/6865580_1085568_126.jpeg")
        ]
        
        self.myGroupGoods = [
            Goods(id: 0, artistName: "아이브", productName: "아이브앨범", imageURL: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", numberOfPot: 10),
            Goods(id: 1, artistName: "아이브", productName: "아이브앨범", imageURL: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", numberOfPot: 20),
            Goods(id: 2, artistName: "아이브", productName: "아이브앨범", imageURL: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", numberOfPot: 1),
            Goods(id: 3, artistName: "아이브", productName: "아이브앨범", imageURL: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", numberOfPot: 2),
            Goods(id: 4, artistName: "아이브", productName: "아이브앨범", imageURL: "https://dimg.donga.com/wps/SPORTS/IMAGE/2025/08/25/132250320.1.jpg", numberOfPot: 3)
        ]
        
        self.otherGroupGoods = [
            Goods(id: 0, artistName: "아일릿", productName: "아일릿 앨범~", imageURL: "https://img.segye.com/content/image/2024/04/16/20240416533728.jpg", numberOfPot: 10),
            Goods(id: 1, artistName: "아일릿", productName: "아일릿 앨범~", imageURL: "https://img.segye.com/content/image/2024/04/16/20240416533728.jpg", numberOfPot: 20),
            Goods(id: 2, artistName: "아일릿", productName: "아일릿 앨범~", imageURL: "https://img.segye.com/content/image/2024/04/16/20240416533728.jpg", numberOfPot: 1),
            Goods(id: 3, artistName: "아일릿", productName: "아일릿 앨범~", imageURL: "https://img.segye.com/content/image/2024/04/16/20240416533728.jpg", numberOfPot: 2),
            Goods(id: 4, artistName: "아일릿", productName: "아일릿 앨범~", imageURL: "https://img.segye.com/content/image/2024/04/16/20240416533728.jpg", numberOfPot: 3)
        ]
        
        self.nickName = "앙티"
    }
}
