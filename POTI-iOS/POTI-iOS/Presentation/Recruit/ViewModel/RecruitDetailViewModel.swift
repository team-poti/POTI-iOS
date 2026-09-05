//
//  RecruitDetailViewModel.swift
//  POTI-iOS
//
//  Created by Neon on 1/13/26.
//

import UIKit

import Combine

final class RecruitDetailViewModel: BaseViewModelType {
    private let currentUserRole: UserRole = .host
    private let initialPostId: Int
    private var detailEntity: RecruitDetailEntity?
    private var isDeleting = false
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case tapPotInfo
        case tapManageInfo
        case tapDelete
    }
    
    // MARK: - Output
    
    struct Output {
        let viewState: AnyPublisher<RecruitDetailViewState, Never>
        let naviPotInfo: AnyPublisher<Int, Never>
        let naviManageInfo: AnyPublisher<Int, Never>
        let showError: AnyPublisher<String, Never>
        let postDeleted: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    let output: Output
    private let postsSaleUseCase: PostsSaleUseCase
    private let deletePostUseCase: DeletePostUseCase
    private let viewStateMapper = RecruitDetailViewStateMapper()
    
    // MARK: - Subject
    
    private let naviPotInfoSubject = PassthroughSubject<Int, Never>()
    private let naviManageInfoSubject = PassthroughSubject<Int, Never>()
    private let viewStateSubject = CurrentValueSubject<RecruitDetailViewState?, Never>(nil)
    private let errorSubject = PassthroughSubject<String, Never>()
    private let postDeletedSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Initializer
    
    init(
        postId: Int,
        postsSaleUseCase: PostsSaleUseCase,
        deletePostUseCase: DeletePostUseCase
    ) {
        self.initialPostId = postId
        self.postsSaleUseCase = postsSaleUseCase
        self.deletePostUseCase = deletePostUseCase
        self.output = Output(
            viewState: viewStateSubject
                .compactMap { $0 }
                .eraseToAnyPublisher(),
            naviPotInfo: naviPotInfoSubject.eraseToAnyPublisher(),
            naviManageInfo: naviManageInfoSubject.eraseToAnyPublisher(),
            showError: errorSubject.eraseToAnyPublisher(),
            postDeleted: postDeletedSubject.eraseToAnyPublisher()
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
        case .tapDelete:
            guard !isDeleting else { return }
            isDeleting = true
            Task { [weak self] in
                await self?.deletePost()
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
        } catch {
            errorSubject.send("분철 정보를 불러오지 못했어요")
        }
    }

    private func deletePost() async {
        defer { isDeleting = false }

        guard let detailEntity, detailEntity.totalCount == 0 else {
            errorSubject.send("참여자가 있으면 모집글을 삭제할 수 없어요.")
            return
        }

        do {
            try await deletePostUseCase.execute(postId: detailEntity.postId)
            postDeletedSubject.send(())
        } catch {
            errorSubject.send("모집글을 삭제하지 못했어요.")
        }
    }
}
