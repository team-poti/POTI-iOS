//
//  ArtistMembersFilterViewModel.swift
//  POTI-iOS
//
//  Created by soomin on 6/8/26.
//

import Combine

struct SelectableArtistMember: Equatable {
    let id: Int
    let name: String
    var isSelected: Bool
}

enum ArtistMembersSelectionMode {
    case filter
    case registration

    var title: String {
        switch self {
        case .filter: "멤버 선택"
        case .registration: "멤버 편집"
        }
    }

    var resetTitle: String {
        switch self {
        case .filter: "초기화"
        case .registration: "전체 선택"
        }
    }
}

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
        let members: AnyPublisher<[SelectableArtistMember], Never>
        let isCompleteEnabled: AnyPublisher<Bool, Never>
        let selectedMembers: AnyPublisher<[SelectableArtistMember], Never>
    }

    let output: Output
    let mode: ArtistMembersSelectionMode

    var currentMembers: [SelectableArtistMember] { membersSubject.value }

    private let useCase: ArtistMembersUseCase?
    private let artistId: Int?
    private let initialSelectedIDs: Set<Int>
    private let prefetchedMembers: [SelectableArtistMember]?
    // MARK: - Subjects

    private let membersSubject = CurrentValueSubject<[SelectableArtistMember], Never>([])
    private let isCompleteEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    private let selectedMembersSubject = PassthroughSubject<[SelectableArtistMember], Never>()

    // MARK: - Initializer

    init(useCase: ArtistMembersUseCase, artistId: Int, selectedIds: [Int]) {
        self.useCase = useCase
        self.artistId = artistId
        self.initialSelectedIDs = Set(selectedIds)
        self.prefetchedMembers = nil
        self.mode = .filter
        self.output = Output(
            members: membersSubject.eraseToAnyPublisher(),
            isCompleteEnabled: isCompleteEnabledSubject.eraseToAnyPublisher(),
            selectedMembers: selectedMembersSubject.eraseToAnyPublisher()
        )
    }

    init(members: [SelectableArtistMember]) {
        self.useCase = nil
        self.artistId = nil
        self.initialSelectedIDs = Set(members.filter(\.isSelected).map(\.id))
        self.prefetchedMembers = members
        self.mode = .registration
        self.output = Output(
            members: membersSubject.eraseToAnyPublisher(),
            isCompleteEnabled: isCompleteEnabledSubject.eraseToAnyPublisher(),
            selectedMembers: selectedMembersSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            loadMembers()
        case .selectMember(let index):
            toggleMember(at: index)
        case .tapReset:
            resetSelection()
        case .tapComplete:
            completeSelection()
        }
    }
}

private extension ArtistMembersFilterViewModel {
    func loadMembers() {
        if let prefetchedMembers {
            membersSubject.send(prefetchedMembers)
            isCompleteEnabledSubject.send(false)
            return
        }

        guard let useCase, let artistId else { return }

        Task { [weak self] in
            guard let self else { return }
            do {
                let members = try await useCase.execute(artistId: artistId)
                await MainActor.run { self.updateMembers(members) }
            } catch {
                PotiLogger.error(error)
                await MainActor.run {
                    self.membersSubject.send([])
                    self.isCompleteEnabledSubject.send(false)
                }
            }
        }
    }

    func updateMembers(_ members: [ArtistMemberEntity]) {
        let selectableMembers = members.map {
            SelectableArtistMember(id: $0.memberId, name: $0.name, isSelected: initialSelectedIDs.contains($0.memberId))
        }
        membersSubject.send(selectableMembers)
        isCompleteEnabledSubject.send(false)
    }

    func toggleMember(at index: Int) {
        var members = membersSubject.value
        guard members.indices.contains(index) else { return }
        members[index].isSelected.toggle()
        membersSubject.send(members)
        updateCompleteButtonState()
    }

    func resetSelection() {
        var members = membersSubject.value

        switch mode {
        case .filter:
            for index in members.indices {
                members[index].isSelected = false
            }
            membersSubject.send(members)
            updateCompleteButtonState()

        case .registration:
            guard !members.isEmpty else { return }
            let shouldSelectAll = !members.allSatisfy(\.isSelected)
            for index in members.indices {
                members[index].isSelected = shouldSelectAll
            }
            membersSubject.send(members)
            isCompleteEnabledSubject.send(!shouldSelectAll)
        }
    }

    func updateCompleteButtonState() {
        let selectedIDs = Set(membersSubject.value.filter(\.isSelected).map(\.id))
        isCompleteEnabledSubject.send(selectedIDs != initialSelectedIDs)
    }

    func completeSelection() {
        selectedMembersSubject.send(membersSubject.value.filter(\.isSelected))
    }
}
