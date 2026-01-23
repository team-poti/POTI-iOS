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
        let selectedMemberData: AnyPublisher<(ids: [Int], names: [String]), Never>
    }
    
    let output: Output
    private let useCase: ArtistsUsecase
    private var cancellables = Set<AnyCancellable>()
    
    let artistId: Int
    private var isChangedInThisSession: Bool = false
    private var originalEntities: [ArtistsEntity] = []
    var currentArtistsList: [(name: String, isSelected: Bool)] {
        return artistsListSubject.value
    }
    private let initialSelectedIds: [Int]
    
    // MARK: - Subjects
    
    private let artistsListSubject = CurrentValueSubject<[(name: String, isSelected: Bool)], Never>([])
    private let isCompleteEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    private let selectedMemberDataSubject = PassthroughSubject<(ids: [Int], names: [String]), Never>()
    
    init(useCase: ArtistsUsecase, artistId: Int, selectedIds: [Int]) {
        self.useCase = useCase
        self.artistId = artistId
        self.initialSelectedIds = selectedIds
        
        self.output = Output(
            artistsList: artistsListSubject.eraseToAnyPublisher(),
            isCompleteEnabled: isCompleteEnabledSubject.eraseToAnyPublisher(),
            selectedMemberData: selectedMemberDataSubject.eraseToAnyPublisher()
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
            let selectedData = artistsListSubject.value.enumerated()
                .filter { $0.element.isSelected }
            
            let selectedIds = selectedData.compactMap { index, _ in
                index < originalEntities.count ? originalEntities[index].artistId : nil
            }
            
            let selectedNames = selectedData.map { $0.element.name }
            
            selectedMemberDataSubject.send((ids: selectedIds, names: selectedNames))
        }
    }
}

private extension ArtistsViewModel {
    func fetchArtistsList(artistId: Int) {
        Task {
            do {
                let entities = try await useCase.execute(artistId: artistId)
                
                if entities.isEmpty {
                    await MainActor.run {
                        artistsListSubject.send([])
                        isCompleteEnabledSubject.send(false)
                    }
                    return
                }
                
                self.originalEntities = entities
                
                let uiModels = entities.map { entity -> (name: String, isSelected: Bool) in
                    let isSelected = initialSelectedIds.contains(entity.artistId)
                    return (name: entity.artistName, isSelected: isSelected)
                }
                
                await MainActor.run {
                    artistsListSubject.send(uiModels)
                    self.isChangedInThisSession = false
                    isCompleteEnabledSubject.send(false)
                }
            } catch {
                print("Network Error: \(error)")
                await MainActor.run {
                    artistsListSubject.send([])
                    isCompleteEnabledSubject.send(false)
                }
            }
        }
    }
    
    func handleSelection(index: Int) {
        var current = artistsListSubject.value
        current[index].isSelected.toggle()
        artistsListSubject.send(current)
        
        notifyChange()
    }
    
    func handleReset() {
        let resetData = artistsListSubject.value.map { (name: $0.name, isSelected: false) }
        artistsListSubject.send(resetData)
        
        notifyChange()
    }
    
    private func notifyChange() {
        if !isChangedInThisSession {
            isChangedInThisSession = true
            isCompleteEnabledSubject.send(true)
        }
    }
}
