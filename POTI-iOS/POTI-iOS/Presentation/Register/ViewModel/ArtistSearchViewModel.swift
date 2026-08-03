import Foundation

import Combine

@MainActor
final class ArtistSearchViewModel: BaseViewModelType {
    enum Input {
        case queryChanged(String)
        case selectArtist(ArtistSearchResultEntity)
        case tapDone
    }

    enum SearchPhase {
        case idle
        case loading
        case results
        case empty
        case error(message: String)
    }

    struct State {
        var query = ""
        var artists: [ArtistSearchResultEntity] = []
        var selectedArtist: ArtistSearchResultEntity?
        var phase: SearchPhase = .idle

        var isDoneEnabled: Bool { selectedArtist != nil }
    }

    struct Output {
        let state: AnyPublisher<State, Never>
        let didSelectArtist: AnyPublisher<ArtistSearchResultEntity, Never>
    }

    let output: Output

    private let artistSearchUseCase: ArtistSearchUseCase
    private var searchTask: Task<Void, Never>?
    private let stateSubject = CurrentValueSubject<State, Never>(State())
    private let didSelectArtistSubject = PassthroughSubject<ArtistSearchResultEntity, Never>()

    init(artistSearchUseCase: ArtistSearchUseCase) {
        self.artistSearchUseCase = artistSearchUseCase
        output = Output(
            state: stateSubject.eraseToAnyPublisher(),
            didSelectArtist: didSelectArtistSubject.eraseToAnyPublisher()
        )
    }

    deinit {
        searchTask?.cancel()
    }

    func action(_ trigger: Input) {
        switch trigger {
        case .queryChanged(let query):
            search(query: query)
        case .selectArtist(let artist):
            updateState {
                $0.selectedArtist = artist
                $0.phase = .results
            }
        case .tapDone:
            guard let artist = stateSubject.value.selectedArtist else { return }
            didSelectArtistSubject.send(artist)
        }
    }

    private func search(query: String) {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        searchTask?.cancel()

        updateState {
            $0.query = query
            $0.artists = []
            $0.selectedArtist = nil
            $0.phase = query.isEmpty ? .idle : .loading
        }

        guard !query.isEmpty else { return }

        searchTask = Task { [weak self, artistSearchUseCase] in
            do {
                try await Task.sleep(for: .milliseconds(300))
                let artists = try await artistSearchUseCase.execute(keyword: query)
                try Task.checkCancellation()

                guard let self, self.stateSubject.value.query == query else { return }
                self.updateState {
                    $0.artists = artists
                    $0.phase = artists.isEmpty ? .empty : .results
                }
            } catch is CancellationError {
                return
            } catch {
                guard let self, self.stateSubject.value.query == query else { return }
                self.updateState {
                    $0.artists = []
                    $0.phase = .error(message: "검색 중 문제가 발생했어요\n잠시 후 다시 시도해주세요")
                }
            }
        }
    }

    private func updateState(_ update: (inout State) -> Void) {
        var state = stateSubject.value
        update(&state)
        stateSubject.send(state)
    }
}
