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
        case filterByMembers(members: [Int], names: [String])
        case didTapSortOption(index: Int)
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let sortTitle = CurrentValueSubject<String, Never>("최신순")
        let filterTitle = CurrentValueSubject<String, Never>("멤버 선택")
    }
    
    // MARK: - Properties
    
    private let useCase: PotListUseCase
    let title: String
    let artistId: Int
    let artistName: String
    var selectedMemberIds: [Int] = []
    
    var currentSort: String = "LATEST"
    
    var currentSortIndex: Int {
        switch currentSort {
        case "LATEST": return 0
        case "DEADLINE": return 1
        case "RATING": return 2
        default: return 0
        }
    }
    
    var currentSortText: String {
        switch currentSort {
        case "LATEST": return "최신순"
        case "DEADLINE": return "마감임박순"
        case "RATING": return "평점순"
        default: return "최신순"
        }
    }
    
    private var currentPage: Int = 0
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
        
        self.output.sortTitle.send(currentSortText)
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchPotListData(isFirstPage: true)
        case .didTapSortOption(let index):
            updateSort(index: index)
        case .filterByMembers(let ids, let names):
            self.selectedMemberIds = ids
            updateFilterTitle(names: names)
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
        let newSort: String
        switch index {
        case 0: newSort = "LATEST"
        case 1: newSort = "DEADLINE"
        case 2: newSort = "RATING"
        default: newSort = "LATEST"
        }
        
        guard currentSort != newSort else { return }
        
        self.currentSort = newSort
        self.currentPage = 0
        self.hasNextPage = true
        
        self.output.sortTitle.send(currentSortText)
        fetchPotListData(isFirstPage: true)
    }
    
    private func updateFilterTitle(names: [String]) {
        if names.isEmpty {
            output.filterTitle.send("멤버 선택")
            return
        }
        
        switch names.count {
        case 1:
            output.filterTitle.send(names[0])
        case 2:
            output.filterTitle.send("\(names[0]), \(names[1])")
        default:
            let extraCount = names.count - 2
            output.filterTitle.send("\(names[0]), \(names[1]) 외 \(extraCount)명")
        }
    }
}
