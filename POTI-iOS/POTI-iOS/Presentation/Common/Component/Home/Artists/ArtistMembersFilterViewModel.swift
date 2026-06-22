//
//  ArtistMembersFilterViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 6/8/26.
//

import Combine

final class ArtistMembersFilterViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case selectMember(index: Int)
        case tapReset
        case tapComplete
    }
    
    // MARK: - Output
    
    struct Output {
        let membersList: AnyPublisher<[(name: String, isSelected: Bool)], Never>
        let isCompleteEnabled: AnyPublisher<Bool, Never>
        let selectedMemberData: AnyPublisher<(ids: [Int], names: [String]), Never>
    }
    
    let output: Output
    private let useCase: ArtistMembersUseCase
    private var cancellables = Set<AnyCancellable>()
    
    let artistId: Int
    private var isChangedInThisSession: Bool = false
    private var originalEntities: [ArtistsEntity] = []
    
    var currentMembersList: [(name: String, isSelected: Bool)] {
        return membersListSubject.value
    }
    private let initialSelectedIds: [Int]
    
    // MARK: - Subjects
    
    private let membersListSubject = CurrentValueSubject<[(name: String, isSelected: Bool)], Never>([])
    private let isCompleteEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    private let selectedMemberDataSubject = PassthroughSubject<(ids: [Int], names: [String]), Never>()
    
    // MARK: - Initializer
    
    init(useCase: ArtistMembersUseCase, artistId: Int, selectedIds: [Int]) {
        self.useCase = useCase
        self.artistId = artistId
        self.initialSelectedIds = selectedIds
        
        self.output = Output(
            membersList: membersListSubject.eraseToAnyPublisher(),
            isCompleteEnabled: isCompleteEnabledSubject.eraseToAnyPublisher(),
            selectedMemberData: selectedMemberDataSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchMembersList()
        case .selectMember(let index):
            handleSelection(index: index)
        case .tapReset:
            handleReset()
        case .tapComplete:
            handleComplete()
        }
    }
}

private extension ArtistMembersFilterViewModel {
    func fetchMembersList() {
        Task {
            do {
                let entities = try await useCase.execute(artistId: self.artistId)
                
                if entities.isEmpty {
                    await MainActor.run {
                        membersListSubject.send([])
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
                    membersListSubject.send(uiModels)
                    self.isChangedInThisSession = false
                    isCompleteEnabledSubject.send(false)
                }
            } catch {
                print("⚠️ 아티스트 멤버 로드 실패: \(error)")
                await MainActor.run {
                    membersListSubject.send([])
                    isCompleteEnabledSubject.send(false)
                }
            }
        }
    }
    
    func handleSelection(index: Int) {
        var current = membersListSubject.value
        current[index].isSelected.toggle()
        membersListSubject.send(current)
        notifyChange()
    }
    
    func handleReset() {
        let resetData = membersListSubject.value.map { (name: $0.name, isSelected: false) }
        membersListSubject.send(resetData)
        notifyChange()
    }
    
    func handleComplete() {
        let selectedData = membersListSubject.value.enumerated().filter { $0.element.isSelected }
        
        let selectedIds = selectedData.compactMap { index, _ in
            index < originalEntities.count ? originalEntities[index].artistId : nil
        }
        
        let selectedNames = selectedData.map { $0.element.name }
        selectedMemberDataSubject.send((ids: selectedIds, names: selectedNames))
    }
    
    func notifyChange() {
        if !isChangedInThisSession {
            isChangedInThisSession = true
            isCompleteEnabledSubject.send(true)
        }
    }
}
