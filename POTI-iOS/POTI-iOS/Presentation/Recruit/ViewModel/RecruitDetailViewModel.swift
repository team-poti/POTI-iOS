//
//  RecruitDetailViewModel.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import Combine

final class RecruitDetailViewModel: BaseViewModelType {
    private let currentUserRole: UserRole = .host
    private let initialPostId: Int
    private var detailEntity: RecruitDetailEntity?
    
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
        let naviPotInfo: AnyPublisher<Int, Never>
        let naviManageInfo: AnyPublisher<Int, Never>
    }
    
    // MARK: - Properties
    
    let output: Output
    private let postsSaleUseCase: PostsSaleUseCase
    private let viewStateMapper = RecruitDetailViewStateMapper()
    
    // MARK: - Subject
    
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    private let naviPotInfoSubject = PassthroughSubject<Int, Never>()
    private let naviManageInfoSubject = PassthroughSubject<Int, Never>()
    private let viewStateSubject = CurrentValueSubject<RecruitDetailViewState?, Never>(nil)
    
    // MARK: - Initializer
    
    init(
        postId: Int,
        postsSaleUseCase: PostsSaleUseCase
    ) {
        self.initialPostId = postId
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
                await fetchRecruitDetail(postId: initialPostId)
            }
        case .tapPotInfo:
            if let postId = self.detailEntity?.postId {
                naviPotInfoSubject.send(postId)
            }
        case .tapManageInfo:
            if let postId = self.detailEntity?.postId {
                naviManageInfoSubject.send(postId)
            }
        }
    }
    // MARK: - Private Method
    
    private func fetchRecruitDetail(postId: Int) async {
        do {
            let entity = try await postsSaleUseCase.execute(postId: postId)
            
            self.detailEntity = entity
            
            let state = viewStateMapper.map(entity: entity)
            viewStateSubject.send(state)
            reloadDataSubject.send()
        } catch {
            print("🚘 fetchRecruitDetail error:", error)
        }
    }
}
