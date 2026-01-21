//
//  OnboardingViewModel.swift
//  POTI-iOS
//
//  Created by neon on 1/21/26.
//

import Combine

final class OnboardingViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case validateNickname(String)
        case nicknameConfirmed(String)
        case loadArtists
        case artistSelected(Int)
        case submitWithArtist
        case submitWithoutArtist
    }
    
    // MARK: - Output
    
    struct Output {
        let nicknameValidation: AnyPublisher<NicknameValidationResult, Never>
        let artists: AnyPublisher<[IdolGroupModel], Never>
        let onboardingSuccess: AnyPublisher<Void, Never>
        let onboardingFailure: AnyPublisher<Error, Never>
    }
        
    enum NicknameValidationResult {
        case valid
        case duplicated
        case invalidFormat
        case containsProfanity
    }
    
    // MARK: - Properties
    
    private(set) var output: Output
        
    private var nickname: String = ""
    private var selectedArtistId: Int?
        
    private let nicknameValidationSubject = PassthroughSubject<NicknameValidationResult, Never>()
    private let artistsSubject = PassthroughSubject<[IdolGroupModel], Never>()
    private let onboardingSuccessSubject = PassthroughSubject<Void, Never>()
    private let onboardingFailureSubject = PassthroughSubject<Error, Never>()
            
    private var cancellables = Set<AnyCancellable>()
    private let onboardingArtistsUsecase: OnboardingArtistsUsecase
    private let validNicknameUseCase: ValidNicknameUseCase
    private let submitOnboardingUseCase: SubmitOnboardingUseCase
    
    init(
        onboardingArtistsUsecase: OnboardingArtistsUsecase,
        validNicknameUseCase: ValidNicknameUseCase,
        submitOnboardingUseCase: SubmitOnboardingUseCase
    ) {
        self.onboardingArtistsUsecase = onboardingArtistsUsecase
        self.validNicknameUseCase = validNicknameUseCase
        self.submitOnboardingUseCase = submitOnboardingUseCase
        
        self.output = Output(
            nicknameValidation: nicknameValidationSubject.eraseToAnyPublisher(),
            artists: artistsSubject.eraseToAnyPublisher(),
            onboardingSuccess: onboardingSuccessSubject.eraseToAnyPublisher(),
            onboardingFailure: onboardingFailureSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .validateNickname(let nickname):
            validateNickname(nickname)
            
        case .nicknameConfirmed(let nickname):
            self.nickname = nickname
            
        case .loadArtists:
            loadArtists()
            
        case .artistSelected(let artistId):
            self.selectedArtistId = artistId
            
        case .submitWithArtist:
            submitOnboarding(withArtist: true)
            
        case .submitWithoutArtist:
            submitOnboarding(withArtist: false)
        }
    }
}

extension OnboardingViewModel {
    private func validateNickname(_ nickname: String) {
        Task {
            do {
                let isDuplicated = try await validNicknameUseCase.execute(nickname)
                
                if isDuplicated {
                    nicknameValidationSubject.send(.duplicated)
                } else {
                    nicknameValidationSubject.send(.valid)
                }
            } catch let error as PotiError {
                switch error {
                case .apiError(let message) where message.contains("형식"):
                    nicknameValidationSubject.send(.invalidFormat)
                case .apiError(let message) where message.contains("비속어"):
                    nicknameValidationSubject.send(.containsProfanity)
                default:
                    onboardingFailureSubject.send(error)
                }
            } catch {
                onboardingFailureSubject.send(error)
            }
        }
    }
    
    private func loadArtists() {
        Task {
            do {
                let entity = try await onboardingArtistsUsecase.execute()
                let models = entity.artists.map { $0.toIdolGroupModel() }
                artistsSubject.send(models)
            } catch {
                PotiLogger.error(error)
                onboardingFailureSubject.send(error)
            }
        }
    }
    
    private func submitOnboarding(withArtist: Bool) {
        guard !nickname.isEmpty else {
            onboardingFailureSubject.send(PotiError.badRequest)
            return
        }
        
        Task {
            do {
                let artistId = withArtist ? selectedArtistId : nil
                
                _ = try await submitOnboardingUseCase.execute(
                    nickname: nickname,
                    favoriteArtistId: artistId
                )
                onboardingSuccessSubject.send(())
            } catch {
                PotiLogger.error(error)
                onboardingFailureSubject.send(error)
            }
        }
    }
}
