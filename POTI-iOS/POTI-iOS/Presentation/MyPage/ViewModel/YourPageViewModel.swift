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
        guard userId > 0 else {
            errorSubject.send("유저 정보를 불러오지 못했습니다.")
            return
        }

        isLoadingSubject.send(true)

        Task {
            do {
                // 모집자 프로필은 공개 프로필 API(/api/v1/users/{userId}/profile)를 사용한다.
                let entity = try await getYourPageInformationUseCase.execute(userId: userId)
                let model = entity.toModel()
                await MainActor.run {
                    yourPageSubject.send(model)
                }
            } catch {
                await MainActor.run {
                    errorSubject.send("유저 정보를 불러오지 못했습니다.")
                }
            }
            await MainActor.run {
                isLoadingSubject.send(false)
            }
        }
    }
}
