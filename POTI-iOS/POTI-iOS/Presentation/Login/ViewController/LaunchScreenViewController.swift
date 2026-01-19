//
//  LaunchScreenViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/14/26.
//

import UIKit

import SnapKit
import Then

public final class LaunchScreenViewController: UIViewController {
    
    private let factory: ViewControllerFactory
    private let potiLogoView = UIImageView()
    
    init(factory: ViewControllerFactory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .poti600
        
        setStyle()
        setUI()
        setLayout()
        checkAuthStatus()
    }
    
    private func setStyle() {
        potiLogoView.do {
            $0.image = .imgLottie
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setUI() {
        view.addSubview(potiLogoView)
    }
    
    private func setLayout() {
        potiLogoView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension LaunchScreenViewController {
    private func checkAuthStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.isValidAuthStatus()
        }
    }
    
    private func isValidAuthStatus() {
        let hasToken = KeychainManager.hasValidToken()
        
        if hasToken {
            navigateToTabBar()
            PotiLogger.debug("토큰 존재")
        } else {
            navigateToLogin()
            PotiLogger.debug("토큰 없음")
        }
    }
    
    private func navigateToTabBar() {
        let tabBar = factory.makePotiTabBar()
        switchRootViewController(to: tabBar)
    }
    
    private func navigateToLogin() {
        let loginVC = factory.makeLoginViewController()
        let navVC = UINavigationController(rootViewController: loginVC)
        switchRootViewController(to: navVC)
    }
}
