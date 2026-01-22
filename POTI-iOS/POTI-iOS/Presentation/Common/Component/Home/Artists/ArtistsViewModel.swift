//
//  ArtistsViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/17/26.
//

import Combine

final class ArtistsViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad(artistId: Int)
        case selectArtist(index: Int)
        case tapReset
        case tapComplete
    }
    
    // MARK: - Output
    
    struct Output {
        let artistsList: AnyPublisher<[(name: String, isSelected: Bool)], Never>
        let isCompleteEnabled: AnyPublisher<Bool, Never>
        let selectedMemberIds: AnyPublisher<[Int], Never>
    }
    
    let output: Output
    private let useCase: ArtistsUsecase
    private var cancellables = Set<AnyCancellable>()
    
    let artistId: Int
    private var originalEntities: [ArtistsEntity] = []
    var currentArtistsList: [(name: String, isSelected: Bool)] {
        return artistsListSubject.value
    }
    
    // MARK: - Subjects
    
    private let artistsListSubject = CurrentValueSubject<[(name: String, isSelected: Bool)], Never>([])
    private let isCompleteEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    private let selectedMemberIdsSubject = PassthroughSubject<[Int], Never>()
    
    init(useCase: ArtistsUsecase, artistId: Int) {
        self.useCase = useCase
        self.artistId = artistId
        
        self.output = Output(
            artistsList: artistsListSubject.eraseToAnyPublisher(),
            isCompleteEnabled: isCompleteEnabledSubject.eraseToAnyPublisher(),
            selectedMemberIds: selectedMemberIdsSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad(let artistId):
            fetchArtistsList(artistId: artistId)
        case .selectArtist(let index):
            handleSelection(index: index)
        case .tapReset:
            handleReset()
        case .tapComplete:
            handleComplete()
        }
    }
}

private extension ArtistsViewModel {
    func fetchArtistsList(artistId: Int) {
        Task {
            do {
                let entities = try await useCase.execute(artistId: artistId)
                self.originalEntities = entities
                
                let uiModels = entities.map { (name: $0.artistName, isSelected: false) }
                artistsListSubject.send(uiModels) 
            } catch {
                print("Failed to fetch members: \(error)")
            }
        }
    }
    
    func handleSelection(index: Int) {
        var current = artistsListSubject.value
        current[index].isSelected.toggle()
        artistsListSubject.send(current)
        
        let hasSelection = current.contains { $0.isSelected }
        isCompleteEnabledSubject.send(hasSelection)
    }
    
    func handleReset() {
        let resetData = artistsListSubject.value.map { (name: $0.name, isSelected: false) }
        artistsListSubject.send(resetData)
        isCompleteEnabledSubject.send(false)
    }
    
    func handleComplete() {
        let selectedIds = artistsListSubject.value.enumerated()
            .filter { $0.element.isSelected }
            .compactMap { index, _ -> Int? in
                if index < originalEntities.count {
                    return originalEntities[index].artistId
                }
                return nil
            }
        
        selectedMemberIdsSubject.send(selectedIds)
    }
}
