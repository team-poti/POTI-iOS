//
//  AuthenticationRequirement.swift
//  POTI-iOS
//
//  Created by Neon on 8/31/26.
//

import UIKit

enum LoginRequiredAction {
    case register
    case participate
    case history

    var message: String {
        switch self {
        case .register:
            return "분철을 등록하려면 로그인이 필요해요"
        case .participate:
            return "분철에 참여하려면 로그인이 필요해요"
        case .history:
            return "분철 내역을 확인하려면 로그인이 필요해요"
        }
    }
}

enum AuthenticationSession {
    static var isAuthenticated: Bool {
        KeychainManager.hasValidToken()
    }
}

extension UIViewController {
    @discardableResult
    func requireLogin(
        for action: LoginRequiredAction,
        factory: ViewControllerFactory
    ) -> Bool {
        guard !AuthenticationSession.isAuthenticated else {
            return true
        }

        loadViewIfNeeded()
        guard let hostView = tabBarController?.view ?? navigationController?.view ?? view else {
            return false
        }
        guard !hostView.subviews.contains(where: { $0 is CustomAlertView }) else {
            return false
        }

        let alert = CustomAlertView(
            title: "로그인 후 이용 가능해요",
            message: action.message,
            cancelTitle: "다음에 하기",
            confirmTitle: "로그인 하기",
            onLeftButton: {},
            onRightButton: { [weak self] in
                self?.switchRootViewController(to: factory.makeLoginViewController())
            }
        )
        alert.show(on: hostView)
        return false
    }

    func moveToLogin(factory: ViewControllerFactory) {
        switchRootViewController(to: factory.makeLoginViewController())
    }
}
