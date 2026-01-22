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
    
    private let registerArtistsUseCase: RegisterArtistsUseCase
    private var searchTask: Task<Void, Never>?
    private let debounceNanos: UInt64 = 300_000_000

    private var currentQuery: String = ""

    private var currentArtists: [RegisterArtistEntity] = []
    private var selectedArtist: RegisterArtistEntity?

    private let isDoneEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    private let artistsSubject = CurrentValueSubject<[RegisterArtistEntity], Never>([])
    private let didSelectArtistSubject = PassthroughSubject<RegisterArtistEntity, Never>()

    // MARK: - Life Cycle

    init(registerArtistsUseCase: RegisterArtistsUseCase) {
        self.registerArtistsUseCase = registerArtistsUseCase
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

            // 입력이 바뀌면 선택 상태는 해제
            selectedArtist = nil
            isDoneEnabledSubject.send(false)

            // 빈 검색어면 리스트 비우기
            if trimmed.isEmpty {
                setArtists([])
                return
            }

            // 이전 검색 취소
            searchTask?.cancel()

            let requestedQuery = trimmed
            searchTask = Task { [weak self] in
                guard let self else { return }

                try? await Task.sleep(nanoseconds: self.debounceNanos)
                guard !Task.isCancelled else { return }

                // 최신 query인지 확인
                guard self.currentQuery == requestedQuery else { return }

                do {
                    let artists = try await self.registerArtistsUseCase.execute(keyword: requestedQuery)
                    await MainActor.run {
                        print("[ArtistSearchVM] artists fetched count:", artists.count)
                        self.setArtists(artists)
                    }
                } catch {
                    await MainActor.run {
                        print("[ArtistSearchVM] fetchArtists error:", error)
                        self.setArtists([])
                    }
                }
            }

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

    private func setArtists(_ artists: [RegisterArtistEntity]) {
        currentArtists = artists
        artistsSubject.send(artists)

        if let selected = selectedArtist,
           !artists.contains(where: { $0.artistId == selected.artistId }) {
            selectedArtist = nil
            isDoneEnabledSubject.send(false)
        }
    }
}
