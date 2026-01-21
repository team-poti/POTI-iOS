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
    }
    
    // MARK: - Properties
    
    let output: Output
    
    private let currentTypeSubject: CurrentValueSubject<MyPageHistoryType, Never>
    private let ongoingDataSubject = CurrentValueSubject<[MyPageHistoryModel], Never>([])
    private let completedDataSubject = CurrentValueSubject<[MyPageHistoryModel], Never>([])
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(initialType: MyPageHistoryType) {
        self.currentTypeSubject = CurrentValueSubject<MyPageHistoryType, Never>(initialType)
        
        self.output = Output(
            currentType: currentTypeSubject.eraseToAnyPublisher(),
            ongoingData: ongoingDataSubject.eraseToAnyPublisher(),
            completedData: completedDataSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher()
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
        
        // TODO: API 호출
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            // Mock data
            let mockOngoing = (0..<5).map { _ in
                MyPageHistoryModel(
                    id: UUID().uuidString,
                    artistName: "아이브",
                    productName: "러브다이브 위뮤",
                    status: "모집 완료",
                    thumbnailURL: nil
                )
            }
            
            let mockCompleted = (0..<3).map { _ in
                MyPageHistoryModel(
                    id: UUID().uuidString,
                    artistName: "아이브",
                    productName: "러브다이브 위뮤",
                    status: "모집 완료",
                    thumbnailURL: nil
                )
            }
            
            self.ongoingDataSubject.send(mockOngoing)
            self.completedDataSubject.send(mockCompleted)
            self.isLoadingSubject.send(false)
        }
    }
}
