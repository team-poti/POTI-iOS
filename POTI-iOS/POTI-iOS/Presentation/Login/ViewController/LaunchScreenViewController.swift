//
//  LaunchScreenViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/14/26.
//

import UIKit

import Combine
import Lottie
import SnapKit
import Then

final class LaunchScreenViewController: BaseViewController<LaunchScreenViewModel> {
    
    private let factory: ViewControllerFactory
    private let potiLogoView = LottieAnimationView(name: "splash")
    
    init(viewModel: LaunchScreenViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .poti600
        
        setStyle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.viewModel.action(.viewDidLoad)
        }
    }
    
    private func setStyle() {
        potiLogoView.do {
            $0.play()
        }
    }
    
    override func setUI() {
        view.addSubview(potiLogoView)
    }
    
    override func setLayout() {
        potiLogoView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(126)
        }
    }
    
    override func bindViewModel() {
        viewModel.output.navigationDestination
            .receive(on: DispatchQueue.main)
            .sink { [weak self] destination in
                guard let self else { return }
                
                switch destination {
                case .tabBar:
                    self.navigateToTabBar()
                case .login:
                    self.navigateToLogin()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Navigation

extension LaunchScreenViewController {
    
    private func navigateToTabBar() {
        let tabBar = factory.makePotiTabBar()
        switchRootViewController(to: tabBar)
    }
    
    private func navigateToLogin() {
        let loginVC = factory.makeLoginViewController()
        switchRootViewController(to: loginVC)
    }
}
