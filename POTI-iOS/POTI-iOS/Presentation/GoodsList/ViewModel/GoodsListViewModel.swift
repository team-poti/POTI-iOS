//
//  GoodsListViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import Combine

final class GoodsListViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case didTapSortOption(index: Int)
        case loadNextPage
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: GoodsListUseCase
    let sectionType: HomeSection
    let nickname: String
    private(set) var artistId: Int
    
    func getArtistId() -> Int {
        return self.artistId
    }
    
    private var cancellables = Set<AnyCancellable>()
    let output: Output
    
    private(set) var groupItems: [GroupItemModel] = []
    private var currentPage: Int = 0
    private var isFetching: Bool = false
    private var hasNextPage: Bool = true
    
    var currentSort: String = "HOT"
    
    var currentSortText: String {
        return currentSort == "HOT" ? "인기순" : "최신순"
    }
    
    // MARK: - Subject
    
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Initializer
    
    init(useCase: GoodsListUseCase, sectionType: HomeSection, artistId: Int, nickname: String) {
        self.useCase = useCase
        self.sectionType = sectionType
        self.artistId = artistId
        self.nickname = nickname
        
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchGoodsList(isFirstPage: true)
        case .didTapSortOption(let index):
            updateSort(index: index)
        case .loadNextPage:
            fetchGoodsList(isFirstPage: false)
        }
    }
    
    // MARK: - Private Method
    
    private func fetchGoodsList(isFirstPage: Bool) {
        guard !isFetching && (isFirstPage || hasNextPage) else { return }
        
        isFetching = true
        if isFirstPage { currentPage = 0 }
        
        Task {
            do {
                let data = try await useCase.execute(
                    artistId: artistId,
                    sort: currentSort,
                    page: currentPage
                )
                
                let newItems = data.toGroupItemModel()
                
                if isFirstPage {
                    self.groupItems = newItems
                    self.currentPage = 1
                } else {
                    self.groupItems.append(contentsOf: newItems)
                    self.currentPage += 1
                }
                
                self.hasNextPage = data.hasNext
                
                reloadDataSubject.send(())
                isFetching = false
            } catch {
                isFetching = false
                print("Error: \(error)")
            }
        }
    }
    
    private func updateSort(index: Int) {
        let newSort = (index == 0) ? "LATEST" : "HOT"
        guard currentSort != newSort else { return }
        self.currentSort = newSort
        self.currentPage = 0
        self.hasNextPage = true
        fetchGoodsList(isFirstPage: true)
    }
}
