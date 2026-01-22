//
//  RecruitDetailViewModel.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import Combine

final class RecruitDetailViewModel: BaseViewModelType {
    private let currentUserRole: UserRole = .host //임시 0122
    private let postId: Int
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case tapPotInfo
        case tapManageInfo
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
        let viewState: AnyPublisher<RecruitDetailViewState, Never>
        let naviPotInfo: AnyPublisher<Void, Never>
        let naviManageInfo: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    let output: Output
    private let postsSaleUseCase: PostsSaleUseCase
    private let viewStateMapper = RecruitDetailViewStateMapper()
    
    // MARK: - Subject
    
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    private let naviPotInfoSubject = PassthroughSubject<Void, Never>()
    private let naviManageInfoSubject = PassthroughSubject<Void, Never>()
    private let viewStateSubject = CurrentValueSubject<RecruitDetailViewState?, Never>(nil)
    
    // MARK: - Initializer
    
    init(
        postId: Int,
        postsSaleUseCase: PostsSaleUseCase
    ) {
        self.postId = postId
        self.postsSaleUseCase = postsSaleUseCase
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher(),
            viewState: viewStateSubject
                .compactMap { $0 }
                .eraseToAnyPublisher(),
            naviPotInfo: naviPotInfoSubject.eraseToAnyPublisher(),
            naviManageInfo: naviManageInfoSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            Task {
                await fetchRecruitDetail(postId: postId)
            }
        case .tapPotInfo:
            naviPotInfoSubject.send()
        case .tapManageInfo:
            naviManageInfoSubject.send()
        }
    }
    // MARK: - Private Method
    
    private func fetchRecruitDetail(postId: Int) async {
        do {
            let entity = try await postsSaleUseCase.execute(postId: postId)
            let state = viewStateMapper.map(entity: entity)
            
            viewStateSubject.send(state)
            reloadDataSubject.send()
        } catch {
            print("🚘 fetchRecruitDetail error:", error)
        }
    }
}
