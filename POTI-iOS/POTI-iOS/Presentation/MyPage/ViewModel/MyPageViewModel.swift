//
//  MyPageViewModel.swift
//  POTI-iOS
//
//  Created by neon on 1/20/26.
//

import Combine

final class MyPageViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
    }
    
    // MARK: - Output
    
    struct Output {
        let isLoading: AnyPublisher<Bool, Never>
        let myPage: AnyPublisher<MyPageModel, Never>
        let error: AnyPublisher<String, Never>
    }
    
    // MARK: - Properties
    
    public let output: Output
    
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let myPageSubject = PassthroughSubject<MyPageModel, Never>()
    private let errorSubject = PassthroughSubject<String, Never>()

    private let getMyPageInformationUseCase: GetMyPageInformationUseCase

    
    // MARK: - Init
    init(getMyPageInformationUseCase: GetMyPageInformationUseCase) {
        self.getMyPageInformationUseCase = getMyPageInformationUseCase
        self.output = Output(
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            myPage: myPageSubject.eraseToAnyPublisher(),
            error: errorSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    public func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchMyPage()
        }
    }
}

extension MyPageViewModel {
    private func fetchMyPage() {
        isLoadingSubject.send(true)
        
        Task {
            do {
                let entity = try await getMyPageInformationUseCase.execute()
                let model = entity.toModel()
                myPageSubject.send(model)
            } catch {
                errorSubject.send("마이페이지 정보를 불러오지 못했습니다.")
            }
            isLoadingSubject.send(false)
        }
    }
}
