//
//  ValidNicknameViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class ValidNicknameViewController: BaseViewController<OnboardingViewModel>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        .backButton
    }
    
    private let rootView = ValidNicknameView()
    private let factory: ViewControllerFactory
    
    init(viewModel: OnboardingViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func bindViewModel() {
        viewModel.output.nicknameValidation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .valid:
                    let nickname = self.rootView.validTextField.getText()
                    self.viewModel.action(.nicknameConfirmed(nickname))
                    self.moveToNextScreen()
                    
                case .duplicated:
                    self.rootView.validTextField.apply(state: .error("사용중인 닉네임이에요"))
                    
                case .invalidFormat:
                    self.rootView.validTextField.apply(state: .error("2글자 이상 적어주세요"))
                    
                case .containsProfanity:
                    self.rootView.validTextField.apply(state: .error("사용할 수 없는 문자가 있어요"))
                }
            }
            .store(in: &cancellables)
    }
    
    override func addTarget() {
        rootView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
}

extension ValidNicknameViewController {
    @objc private func nextButtonTapped() {
        let nickname = rootView.validTextField.getText()
        
        guard !nickname.isEmpty else {
            rootView.validTextField.apply(state: .error("2글자 이상 적어주세요"))
            return
        }
        viewModel.action(.validateNickname(nickname))
    }
    
    private func moveToNextScreen() {
        let selectFavoriteIdolGroupVC = factory.makeSelectFavoriteIdolGroupViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(selectFavoriteIdolGroupVC, animated: true)
    }
}
