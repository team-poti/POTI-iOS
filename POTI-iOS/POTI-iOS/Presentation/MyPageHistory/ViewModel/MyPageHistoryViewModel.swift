//
//  MyPageHistoryViewModel.swift
//  POTI-iOS
//
//  Created by neon on 1/20/26.
//

import Foundation
import Combine

enum MyPageHistoryType {
    case participation
    case recruitment
    
    var title: String {
        switch self {
        case .participation: return "참여 내역"
        case .recruitment: return "모집 내역"
        }
    }
    
    var opposite: MyPageHistoryType {
        switch self {
        case .participation: return .recruitment
        case .recruitment: return .participation
        }
    }
    
    func emptyMessage(for isOngoing: Bool) -> String {
        switch (self, isOngoing) {
        case (.recruitment, true):
            return "진행 중인 모집 내역이 없어요"
        case (.recruitment, false):
            return "지난 모집 내역이 없어요"
        case (.participation, true):
            return "진행 중인 참여 내역이 없어요"
        case (.participation, false):
            return "지난 참여 내역이 없어요"
        }
    }
}

final class MyPageHistoryViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case switchButtonTapped
        case refreshRequested
    }
    
    // MARK: - Output
    
    struct Output {
        let currentType: AnyPublisher<MyPageHistoryType, Never>
        let ongoingData: AnyPublisher<[MyPageHistoryModel], Never>
        let completedData: AnyPublisher<[MyPageHistoryModel], Never>
        let isLoading: AnyPublisher<Bool, Never>
        let ongoingCount: AnyPublisher<Int, Never>
        let completedCount: AnyPublisher<Int, Never>
    }
    
    // MARK: - Properties
    
    let output: Output
    
    private let currentTypeSubject: CurrentValueSubject<MyPageHistoryType, Never>
    private let ongoingDataSubject = CurrentValueSubject<[MyPageHistoryModel], Never>([])
    private let completedDataSubject = CurrentValueSubject<[MyPageHistoryModel], Never>([])
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let ongoingCountSubject = CurrentValueSubject<Int, Never>(0)
    private let completedCountSubject = CurrentValueSubject<Int, Never>(0)
    
    private var cancellables = Set<AnyCancellable>()
    
    private let myPagePostsHistoryUseCase: MyPagePostsHistoryUseCase
    private let myPageParticipationsHistoryUseCase: MyPageParticipationsHistoryUseCase
    
    // MARK: - Initializer
    
    init(
        initialType: MyPageHistoryType,
        myPagePostsHistoryUseCase: MyPagePostsHistoryUseCase,
        myPageParticipationsHistoryUseCase: MyPageParticipationsHistoryUseCase
    ) {
        self.myPagePostsHistoryUseCase = myPagePostsHistoryUseCase
        self.myPageParticipationsHistoryUseCase = myPageParticipationsHistoryUseCase
        self.currentTypeSubject = CurrentValueSubject<MyPageHistoryType, Never>(initialType)
        
        self.output = Output(
            currentType: currentTypeSubject.eraseToAnyPublisher(),
            ongoingData: ongoingDataSubject.eraseToAnyPublisher(),
            completedData: completedDataSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            ongoingCount: ongoingCountSubject.eraseToAnyPublisher(),
            completedCount: completedCountSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchData()
            
        case .switchButtonTapped:
            let newType = currentTypeSubject.value.opposite
            currentTypeSubject.send(newType)
            fetchData()
            
        case .refreshRequested:
            fetchData()
        }
    }
    
    // MARK: - Methods
    
    private func fetchData() {
        isLoadingSubject.send(true)
        Task {
            do {
                switch currentTypeSubject.value {
                case .recruitment:
                    async let ongoing = myPagePostsHistoryUseCase.execute(status: "IN_PROGRESS")
                    async let completed = myPagePostsHistoryUseCase.execute(status: "COMPLETED")
                    
                    let ongoingResult = try await ongoing
                    let completedResult = try await completed
                    
                    ongoingDataSubject.send(
                        ongoingResult.groupBuyPosts.map { $0.toModel() }
                    )
                    
                    completedDataSubject.send(
                        completedResult.groupBuyPosts.map { $0.toModel() }
                    )
                    
                    ongoingCountSubject.send(ongoingResult.inProgressCount)
                    completedCountSubject.send(ongoingResult.completedCount)
                    
                case .participation:
                    async let ongoing = myPageParticipationsHistoryUseCase.execute(status: "IN_PROGRESS")
                    async let completed = myPageParticipationsHistoryUseCase.execute(status: "COMPLETED")
                    
                    let ongoingResult = try await ongoing
                    let completedResult = try await completed
                    
                    ongoingDataSubject.send(
                        ongoingResult.participations.map { $0.toModel() }
                    )
                    
                    completedDataSubject.send(
                        completedResult.participations.map { $0.toModel() }
                    )
                    
                    ongoingCountSubject.send(ongoingResult.inProgressCount)
                    completedCountSubject.send(ongoingResult.completedCount)
                }
                
                isLoadingSubject.send(false)
            } catch {
                isLoadingSubject.send(false)
            }
        }
    }
}
