//
//  MyPageViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/16/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class MyPageViewController: BaseViewController<MyPageViewModel>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        .mypage
    }
    
    private let rootView = MyPageView()
    private let factory: ViewControllerFactory
    private var nickname = ""
    
    init(viewModel: MyPageViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }
    
    override func loadView() {
        self.view = rootView
    }

    override func alarmButtonTapped() {
        guard AuthenticationSession.isAuthenticated else { return }

        let notificationViewController = factory.makeNotificationViewController()
        notificationViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(notificationViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray100
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isGuest = !AuthenticationSession.isAuthenticated
        rootView.setGuestMode(isGuest)
        if !isGuest {
            viewModel.action(.viewDidLoad)
        }
    }
    
    override func bindViewModel() {
        viewModel.output.myPage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.nickname = model.nickname
                self?.rootView.configure(with: model)
            }
            .store(in: &cancellables)
        
        viewModel.output.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.presentLoadFailureAlert(message: message)
            }
            .store(in: &cancellables)
    }
    
    override func addTarget() {
        rootView.participationView.onFilterChanged = { [weak self] type in
            self?.navigateToHistory(historyType: .participation, filterType: type)
        }
                
        rootView.recruitmentView.onFilterChanged = { [weak self] type in
            self?.navigateToHistory(historyType: .recruitment, filterType: type)
        }

        rootView.profileInformationView.idolButton.addTarget(
            self,
            action: #selector(idolButtonDidTap),
            for: .touchUpInside
        )

        rootView.guestView.loginButton.addTarget(
            self,
            action: #selector(loginButtonDidTap),
            for: .touchUpInside
        )
    }
    
    private func navigateToHistory(historyType: MyPageHistoryType, filterType: MyPageNavigationType) {
        let initialTab: MyPageHistoryViewController.HistoryTab
        
        switch filterType {
        case .ongoing:
            initialTab = .ongoing
        case .completed:
            initialTab = .completed
        }
        
        let containerVC = factory.makeMyPageHistoryContainerViewController(
            initialType: historyType,
            initialTab: initialTab,
            entryPoint: .myPage
        )
        navigationController?.pushViewController(containerVC, animated: true)
    }

    @objc private func idolButtonDidTap() {
        guard !nickname.isEmpty else { return }

        let viewController = factory.makeMyPageFavoriteIdolGroupViewController(nickname: nickname)
        viewController.hidesBottomBarWhenPushed = true
        viewController.onFavoriteUpdated = { [weak self] in
            self?.viewModel.action(.viewDidLoad)
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

    override func settingButtonTapped() {
        guard AuthenticationSession.isAuthenticated else { return }
        let viewController = factory.makeSettingsViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func loginButtonDidTap() {
        moveToLogin(factory: factory)
    }

    private func presentLoadFailureAlert(message: String) {
        guard presentedViewController == nil else { return }

        let alert = UIAlertController(
            title: "마이페이지를 불러오지 못했어요",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "다시 시도", style: .default) { [weak self] _ in
            self?.viewModel.action(.viewDidLoad)
        })
        present(alert, animated: true)
    }
}

enum MyPageFilterType {
    case all
    case ongoing
    case completed
}
