//
//  ArtistSearchViewModel.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/19/26.
//

import Foundation

import Combine

final class ArtistSearchViewModel: BaseViewModelType {

    // MARK: - Properties

    enum Input {
        case queryChanged(String)
        case selectArtist(index: Int)
        case tapDone
    }

    struct Output {
        let isDoneEnabled: AnyPublisher<Bool, Never>
        let artists: AnyPublisher<[RegisterArtistEntity], Never>
        let didSelectArtist: AnyPublisher<RegisterArtistEntity, Never>
    }

    let output: Output
    
    private var currentQuery: String = ""

    private var currentArtists: [RegisterArtistEntity] = []
    private var selectedArtist: RegisterArtistEntity?

    private let isDoneEnabledSubject = CurrentValueSubject<Bool, Never>(false)

    private let artistsSubject = CurrentValueSubject<[RegisterArtistEntity], Never>([])

    private let didSelectArtistSubject = PassthroughSubject<RegisterArtistEntity, Never>()

    // MARK: - Life Cycle

    init() {
        self.output = Output(
            isDoneEnabled: isDoneEnabledSubject.eraseToAnyPublisher(),
            artists: artistsSubject.eraseToAnyPublisher(),
            didSelectArtist: didSelectArtistSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Custom Method

    func action(_ trigger: Input) {
        switch trigger {
        case .queryChanged(let query):
            let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
            currentQuery = trimmed

            selectedArtist = nil
            isDoneEnabledSubject.send(false)

        case .selectArtist(let index):
            guard currentArtists.indices.contains(index) else { return }
            let artist = currentArtists[index]
            selectedArtist = artist
            isDoneEnabledSubject.send(true)

        case .tapDone:
            guard let selectedArtist else {
                isDoneEnabledSubject.send(false)
                return
            }
            didSelectArtistSubject.send(selectedArtist)
        }
    }

    func setArtists(_ artists: [RegisterArtistEntity]) {
        currentArtists = artists
        artistsSubject.send(artists)

        // 현재 선택이 목록에 없으면 선택 해제
        if let selected = selectedArtist,
           !artists.contains(where: { $0.artistId == selected.artistId }) {
            selectedArtist = nil
            isDoneEnabledSubject.send(false)
        }
    }
}
