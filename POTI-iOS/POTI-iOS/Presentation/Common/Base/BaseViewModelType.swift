//
//  BaseViewModelType.swift
//  POTI-iOS
//
//  Created by neon on 1/14/26.
//

/// ViewModel의 기본 프로토콜
///
/// **사용 방법:**
/// 1. Input은 enum으로 만들어서 "사용자가 할 수 있는 액션"을 정의
/// 2. Output은 struct로 만들어서 "화면에 보여줄 Publisher"들을 정의
/// 3. action() 메서드에서 Input에 따라 비즈니스 로직 실행
///
/// **예제:**
/// ```swift
/// final class LoginViewModel: BaseViewModelType {
///
///     // 1. 사용자 액션 정의
///     enum Input {
///         case loginButtonTap
///         case logoutButtonTap
///     }
///
///     // 2. 화면에 전달할 데이터 정의
///     struct Output {
///         let loginSuccess: AnyPublisher<Void, Never>
///         let loginFailure: AnyPublisher<Error, Never>
///     }
///
///     let output: Output
///
///     // 3. Subject들 생성
///     private let loginSuccessSubject = PassthroughSubject<Void, Never>()
///     private let loginFailureSubject = PassthroughSubject<Error, Never>()
///
///     init() {
///         // 4. Output 초기화
///         self.output = Output(
///             loginSuccess: loginSuccessSubject.eraseToAnyPublisher(),
///             loginFailure: loginFailureSubject.eraseToAnyPublisher()
///         )
///     }
///
///     // 5. 액션 처리
///     func action(_ trigger: Input) {
///         switch trigger {
///         case .loginButtonTap:
///             handleLogin()
///         case .logoutButtonTap:
///             handleLogout()
///         }
///     }
/// }
/// ```
///
/// **ViewController에서 사용:**
/// ```swift
/// // 액션 전달
/// viewModel.action(.loginButtonTap)
///
/// // 결과 구독
/// viewModel.output.loginSuccess
///     .sink { print("성공!") }
///     .store(in: &cancellables)
/// ```
// ViewModelTemplate.swift (참고용)

/*
 📝 ViewModel 작성 가이드
 
 1단계: Input(사용자 액션) 정의
 ────────────────────────────
 enum Input {
     case buttonTap          // 버튼 탭
     case textChanged(String) // 텍스트 변경
     case viewDidLoad        // 화면 로드
 }
 
 2단계: Output(화면 데이터) 정의
 ────────────────────────────
 struct Output {
     let isLoading: AnyPublisher<Bool, Never>
     let userData: AnyPublisher<User, Never>
     let error: AnyPublisher<Error, Never>
 }
 
 3단계: Subject 생성 & Output 초기화
 ────────────────────────────
 private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
 private let userDataSubject = PassthroughSubject<User, Never>()
 
 init() {
     self.output = Output(
         isLoading: isLoadingSubject.eraseToAnyPublisher(),
         userData: userDataSubject.eraseToAnyPublisher()
     )
 }
 
 4단계: action() 메서드 구현
 ────────────────────────────
 func action(_ trigger: Input) {
     switch trigger {
     case .buttonTap:
         isLoadingSubject.send(true)
         // 비즈니스 로직
     case .textChanged(let text):
         // 텍스트 처리
     case .viewDidLoad:
         // 초기 데이터 로드
     }
 }
*/
public protocol BaseViewModelType {
    
    /// 사용자 액션 타입 (enum으로 정의하세요)
    /// - 예: case loginButtonTap, logoutButtonTap
    associatedtype Input
    
    /// 화면에 전달할 데이터 타입 (struct로 정의하세요)
    /// - 예: let loginSuccess: AnyPublisher<Void, Never>
    associatedtype Output
    
    /// 화면에 전달할 데이터 (읽기 전용)
    var output: Output { get }
    
    /// 사용자 액션을 처리하는 메서드
    /// - Parameter trigger: 사용자가 수행한 액션
    func action(_ trigger: Input)
}
