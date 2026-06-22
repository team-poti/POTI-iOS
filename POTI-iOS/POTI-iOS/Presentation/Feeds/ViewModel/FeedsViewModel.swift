//
//  FeedsViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import Combine

final class FeedsViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case didTapSortOption(option: FeedsSortOption)
        case loadNextPage
        case didTapItem(item: GroupItemModel)
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let showPotList: AnyPublisher<GroupItemModel, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: FeedsUseCase
    let sectionType: HomeSection
    let nickname: String
    private(set) var artistId: Int?
    
    private var cancellables = Set<AnyCancellable>()
    let output: Output
    
    private(set) var groupItems: [GroupItemModel] = []
    private var currentPage: Int = 0
    private var isFetching: Bool = false
    private var hasNextPage: Bool = true
    private(set) var currentSort: FeedsSortOption
    
    var currentSortText: String {
        return currentSort.text
    }
    
    // MARK: - Subject
    
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    private let showPotListSubject = PassthroughSubject<GroupItemModel, Never>()
    
    // MARK: - Initializer
    
    init(useCase: FeedsUseCase, sectionType: HomeSection, artistId: Int?, nickname: String) {
        self.useCase = useCase
        self.sectionType = sectionType
        self.artistId = artistId
        self.nickname = nickname
        
        if sectionType == .otherGroup {
            self.currentSort = .random
        } else {
            self.currentSort = .hot
        }
        
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher(),
            showPotList: showPotListSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchFeeds(isFirstPage: true)
        case .didTapSortOption(let option):
            updateSort(to: option)
        case .loadNextPage:
            fetchFeeds(isFirstPage: false)
        case .didTapItem(let item):
            guard let artistId = item.artistId, artistId != -1 else {
                return
            }
            showPotListSubject.send(item)
        }
    }
    
    // MARK: - Private Method
    
    private func fetchFeeds(isFirstPage: Bool) {
        guard !isFetching && (isFirstPage || hasNextPage) else { return }
        
        isFetching = true
        if isFirstPage {
            currentPage = 0
        }
        
        Task {
            do {
                let data = try await useCase.execute(
                    artistId: artistId,
                    sort: currentSort,
                    page: currentPage
                )
                
                let newItems = data.groupItems.map { $0.toGroupItemModel() }
                
                if isFirstPage {
                    self.groupItems = newItems
                    self.currentPage = 1
                } else {
                    self.groupItems.append(contentsOf: newItems)
                    self.currentPage += 1
                }
                
                self.hasNextPage = (newItems.count == 10)
                
                reloadDataSubject.send(())
            } catch {
                print("Error: \(error)")
            }
            isFetching = false
        }
    }
    
    private func updateSort(to newSort: FeedsSortOption) {
        guard currentSort != newSort else { return }
        
        self.currentSort = newSort
        self.currentPage = 0
        self.hasNextPage = true
        
        fetchFeeds(isFirstPage: true)
    }
}
