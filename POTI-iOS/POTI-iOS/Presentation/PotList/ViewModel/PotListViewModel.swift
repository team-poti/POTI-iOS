//
//  PotListViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import Combine

final class PotListViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case filterByMembers(members: [Int])
        case didTapSortOption(index: Int)
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: PotListUseCase
    let title: String
    let artistId: Int
    let artistName: String
    private var selectedMemberIds: [Int] = []
    
    var currentSort: String = "HOT"
    private var currentPage: Int = 0
    var currentSortIndex: Int {
        return currentSort == "HOT" ? 1 : 0
    }
    var currentSortText: String {
        return currentSort == "HOT" ? "인기순" : "최신순"
    }
    private var hasNextPage: Bool = true
    private var isFetching: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    let output: Output
    private(set) var pots: [FeedModel] = []
    
    // MARK: - Subject
    
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Initializer
    
    init(useCase: PotListUseCase, title: String, artistId: Int, artistName: String) {
        self.useCase = useCase
        self.title = title
        self.artistId = artistId
        self.artistName = artistName
        
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchPotListData(isFirstPage: true)
        case .didTapSortOption(let index):
            updateSort(index: index)
        case .filterByMembers(let ids):
            self.selectedMemberIds = ids
            fetchPotListData(isFirstPage: true)
        }
    }
    
    // MARK: - Private Method
    
    private func fetchPotListData(isFirstPage: Bool) {
        guard !isFetching && (isFirstPage || hasNextPage) else { return }
        isFetching = true
        
        Task {
            do {
                let potEntities = try await useCase.execute(
                    title: self.title,
                    artistId: self.artistId,
                    memberIds: self.selectedMemberIds,
                    sort: self.currentSort,
                    page: isFirstPage ? 0 : currentPage
                )
                
                let newPots = potEntities.toFeedModel()
                
                if isFirstPage {
                    self.pots = newPots
                    self.currentPage = 1
                } else {
                    self.pots.append(contentsOf: newPots)
                    self.currentPage += 1
                }
                self.hasNextPage = potEntities.hasNext
                
                await MainActor.run {
                    reloadDataSubject.send(())
                    isFetching = false
                }
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
        fetchPotListData(isFirstPage: true)
    }
}
