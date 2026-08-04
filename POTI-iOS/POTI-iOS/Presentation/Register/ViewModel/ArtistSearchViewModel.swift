//
//  ArtistSearchViewModel.swift
//  POTI-iOS
//
//  Created by soomin on 8/3/26.
//

import Foundation

import Combine

final class ArtistSearchViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case queryChanged(String)
        case artistSelected(ArtistSearchResultEntity)
        case confirmButtonTapped
    }

    // MARK: - State

    enum SearchPhase {
        case idle
        case loading
        case results
        case empty
        case error
    }

    struct State {
        var query = ""
        var artists: [ArtistSearchResultEntity] = []
        var selectedArtist: ArtistSearchResultEntity?
        var phase: SearchPhase = .idle

        var isDoneEnabled: Bool { selectedArtist != nil }
    }

    // MARK: - Output

    struct Output {
        let state: AnyPublisher<State, Never>
        let didSelectArtist: AnyPublisher<ArtistSearchResultEntity, Never>
    }

    let output: Output

    // MARK: - Properties

    private let artistSearchUseCase: ArtistSearchUseCase
    private var searchTask: Task<Void, Never>?
    private var currentSearchID: UUID?
    private let stateSubject = CurrentValueSubject<State, Never>(State())
    private let didSelectArtistSubject = PassthroughSubject<ArtistSearchResultEntity, Never>()

    private enum Constant {
        static let debounceDuration = Duration.milliseconds(300)
    }

    // MARK: - Initializer

    init(artistSearchUseCase: ArtistSearchUseCase) {
        self.artistSearchUseCase = artistSearchUseCase
        output = Output(state: stateSubject.eraseToAnyPublisher(), didSelectArtist: didSelectArtistSubject.eraseToAnyPublisher())
    }

    // MARK: - Deinitializer

    deinit {
        searchTask?.cancel()
    }

    // MARK: - Public Method

    func action(_ trigger: Input) {
        switch trigger {
        case .queryChanged(let query):
            handleQueryChange(query)
        case .artistSelected(let artist):
            selectArtist(artist)
        case .confirmButtonTapped:
            confirmSelection()
        }
    }

    // MARK: - Private Methods

    private func handleQueryChange(_ query: String) {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        searchTask?.cancel()
        currentSearchID = nil

        updateState {
            $0.query = query
            $0.artists = []
            $0.selectedArtist = nil
            $0.phase = query.isEmpty ? .idle : .loading
        }

        guard !query.isEmpty else { return }
        search(query: query)
    }

    private func selectArtist(_ artist: ArtistSearchResultEntity) {
        updateState {
            $0.selectedArtist = artist
            $0.phase = .results
        }
    }

    private func confirmSelection() {
        guard let artist = stateSubject.value.selectedArtist else { return }
        didSelectArtistSubject.send(artist)
    }

    private func search(query: String) {
        let searchID = UUID()
        currentSearchID = searchID

        searchTask = Task { @MainActor [weak self, artistSearchUseCase] in
            do {
                try await Task.sleep(for: Constant.debounceDuration)
                let artists = try await artistSearchUseCase.execute(keyword: query)
                try Task.checkCancellation()

                guard let self, self.currentSearchID == searchID, self.stateSubject.value.query == query else { return }
                self.updateState {
                    $0.artists = artists
                    $0.phase = artists.isEmpty ? .empty : .results
                }
                self.finishSearch(id: searchID)
            } catch is CancellationError {
                self?.finishSearch(id: searchID)
                return
            } catch {
                guard let self, self.currentSearchID == searchID, self.stateSubject.value.query == query else { return }
                self.updateState {
                    $0.artists = []
                    $0.phase = .error
                }
                self.finishSearch(id: searchID)
            }
        }
    }

    private func finishSearch(id: UUID) {
        guard currentSearchID == id else { return }
        searchTask = nil
        currentSearchID = nil
    }

    private func updateState(_ update: (inout State) -> Void) {
        var state = stateSubject.value
        update(&state)
        stateSubject.send(state)
    }
}
