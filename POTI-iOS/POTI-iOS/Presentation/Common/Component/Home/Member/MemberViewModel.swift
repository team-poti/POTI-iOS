//
//  MemberViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/17/26.
//

import Combine

final class MemberViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad(artistId: Int)
        case selectMember(index: Int)
        case tapReset
        case tapComplete
    }
    
    // MARK: - Output
    
    struct Output {
        let memberList: AnyPublisher<[(name: String, isSelected: Bool)], Never>
        let isCompleteEnabled: AnyPublisher<Bool, Never>
        let selectedMembers: AnyPublisher<[String], Never>
    }
    
    let output: Output
    private let useCase: MemberUsecase
    private var cancellables = Set<AnyCancellable>()
    
    var currentMemberList: [(name: String, isSelected: Bool)] {
            return memberListSubject.value
    }
    
    // MARK: - Subjects
    
    private let memberListSubject = CurrentValueSubject<[(name: String, isSelected: Bool)], Never>([])
    private let isCompleteEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    private let selectedMembersSubject = PassthroughSubject<[String], Never>()
    
    init(useCase: MemberUsecase) {
        self.useCase = useCase
        
        self.output = Output(
            memberList: memberListSubject.eraseToAnyPublisher(),
            isCompleteEnabled: isCompleteEnabledSubject.eraseToAnyPublisher(),
            selectedMembers: selectedMembersSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad(let artistId):
            fetchMembers(artistId: artistId)
        case .selectMember(let index):
            handleSelection(index: index)
        case .tapReset:
            handleReset()
        case .tapComplete:
            handleComplete()
        }
    }
}

private extension MemberViewModel {
    func fetchMembers(artistId: Int) {
        Task {
            do {
                let entities = try await useCase.execute(artistId: artistId)
                let uiModels = entities.map { (name: $0.memberName, isSelected: false) }
                memberListSubject.send(uiModels)
            } catch {
                print("Failed to fetch members: \(error)")
            }
        }
    }
    func handleSelection(index: Int) {
        var current = memberListSubject.value
        current[index].isSelected.toggle()
        memberListSubject.send(current)
        
        let hasSelection = current.contains { $0.isSelected }
        isCompleteEnabledSubject.send(hasSelection)
    }
    
    func handleReset() {
        let resetData = memberListSubject.value.map { (name: $0.name, isSelected: false) }
        memberListSubject.send(resetData)
        isCompleteEnabledSubject.send(false)
    }
    
    func handleComplete() {
        let selected = memberListSubject.value
            .filter { $0.isSelected }
            .map { $0.name }
        selectedMembersSubject.send(selected)
    }
}
