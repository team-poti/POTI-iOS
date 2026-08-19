//
//  SearchViewModel.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

import Foundation
import Combine

final class SearchViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case queryChanged(String)
        case submitSearch(String)
        case selectResult(Int)
        case loadNextPage
    }

    // MARK: - State

    enum Phase {
        case idle
        case loading
        case results
        case empty
        case error
    }

    struct State {
        let phase: Phase
    }

    // MARK: - Output

    struct Output {
        let render: AnyPublisher<State, Never>
        let showPotList: AnyPublisher<GoodsListItemModel, Never>
    }

    // MARK: - Properties

    private let searchPostsUseCase: SearchPostsUseCase
    private var searchDebounceTask: Task<Void, Never>?
    private var searchTask: Task<Void, Never>?
    private var searchRequestID = UUID()
    private var currentKeyword = ""
    private var currentPage = 0
    private var hasNextPage = false
    private var isFetching = false

    private(set) var results: [GoodsListItemModel] = []
    let output: Output

    // MARK: - Subjects

    private let renderSubject = CurrentValueSubject<State, Never>(State(phase: .idle))
    private let showPotListSubject = PassthroughSubject<GoodsListItemModel, Never>()

    // MARK: - Initializer

    init(searchPostsUseCase: SearchPostsUseCase) {
        self.searchPostsUseCase = searchPostsUseCase
        output = Output(render: renderSubject.eraseToAnyPublisher(), showPotList: showPotListSubject.eraseToAnyPublisher())
    }

    deinit {
        searchDebounceTask?.cancel()
        searchTask?.cancel()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {
        case .queryChanged(let query):
            updateQuery(query)
        case .submitSearch(let query):
            searchDebounceTask?.cancel()
            search(keyword: query, resetsResults: true)
        case .selectResult(let index):
            guard results.indices.contains(index) else { return }
            showPotListSubject.send(results[index])
        case .loadNextPage:
            guard hasNextPage else { return }
            search(keyword: currentKeyword, resetsResults: false)
        }
    }

    // MARK: - Private Methods

    private func updateQuery(_ query: String) {
        searchDebounceTask?.cancel()
        searchTask?.cancel()
        isFetching = false
        let keyword = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !keyword.isEmpty else {
            currentKeyword = ""
            results = []
            currentPage = 0
            hasNextPage = false
            renderSubject.send(State(phase: .idle))
            return
        }

        searchDebounceTask = Task { [weak self] in
            do {
                try await Task.sleep(for: .milliseconds(300))
                guard !Task.isCancelled, let self else { return }
                search(keyword: keyword, resetsResults: true)
            } catch is CancellationError {
                return
            } catch {
                return
            }
        }
    }

    private func search(keyword: String, resetsResults: Bool) {
        let trimmedKeyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKeyword.isEmpty else { return }

        if resetsResults {
            searchTask?.cancel()
            isFetching = false
            currentKeyword = trimmedKeyword
            currentPage = 0
            hasNextPage = false
            results = []
            renderSubject.send(State(phase: .loading))
        }
        guard !isFetching else { return }

        isFetching = true
        let requestedPage = currentPage
        searchRequestID = UUID()
        let requestID = searchRequestID
        searchTask = Task { [weak self, searchPostsUseCase] in
            defer {
                if self?.searchRequestID == requestID {
                    self?.isFetching = false
                }
            }

            do {
                let page = try await searchPostsUseCase.execute(keyword: trimmedKeyword, page: requestedPage)
                guard !Task.isCancelled, let self, currentKeyword == trimmedKeyword else { return }
                let newResults = page.results.map { $0.toGoodsListItemModel() }

                if resetsResults {
                    results = newResults
                } else {
                    results.append(contentsOf: newResults)
                }

                currentPage = page.currentPage + 1
                hasNextPage = page.hasNext
                let phase: Phase = results.isEmpty ? .empty : .results
                renderSubject.send(State(phase: phase))
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled, let self else { return }
                let phase: Phase = results.isEmpty ? .error : .results
                renderSubject.send(State(phase: phase))
            }
        }
    }
}
