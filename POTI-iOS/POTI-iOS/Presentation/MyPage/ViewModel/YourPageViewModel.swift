//
//  YourPageViewModel.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

import Combine

final class YourPageViewModel: BaseViewModelType {

    // MARK: - Input
    enum Input {
        case viewDidLoad
    }

    // MARK: - Output
    struct Output {
        let isLoading: AnyPublisher<Bool, Never>
        let yourPage: AnyPublisher<YourPageModel, Never>
        let error: AnyPublisher<String, Never>
    }

    let output: Output

    // MARK: - Private
    private let userId: Int
    private let getYourPageInformationUseCase: GetYourPageInformationUseCase

    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let yourPageSubject = PassthroughSubject<YourPageModel, Never>()
    private let errorSubject = PassthroughSubject<String, Never>()

    // MARK: - Init
    init(
        userId: Int,
        getYourPageInformationUseCase: GetYourPageInformationUseCase
    ) {
        self.userId = userId
        self.getYourPageInformationUseCase = getYourPageInformationUseCase
        self.output = Output(
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            yourPage: yourPageSubject.eraseToAnyPublisher(),
            error: errorSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Action
    func action(_ input: Input) {
        switch input {
        case .viewDidLoad:
            fetchYourPage()
        }
    }
}

extension YourPageViewModel {

    private func fetchYourPage() {
        isLoadingSubject.send(true)

        Task {
            do {
                let entity = try await getYourPageInformationUseCase.execute(userId: userId)
                let model = entity.toModel()
                yourPageSubject.send(model)
            } catch {
                errorSubject.send("유저 정보를 불러오지 못했습니다.")
            }
            isLoadingSubject.send(false)
        }
    }
}
