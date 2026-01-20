//
//  MyPageHistoryContainerViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/20/26.
//

import UIKit

import Combine

final class MyPageHistoryContainerViewController: BaseViewController<MyPageHistoryViewModel>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        return .backWithButton(title: currentType.title)
    }
    
    // MARK: - Properties
    
    private var currentChildVC: MyPageHistoryViewController?
    private var currentType: MyPageHistoryType = .participation
    
    init(initialType: MyPageHistoryType) {
        let viewModel = MyPageHistoryViewModel(initialType: initialType)
        self.currentType = initialType
        super.init(viewModel: viewModel)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.action(.viewDidLoad)
        switchChildViewController()
    }
    
    override func bindViewModel() {
        viewModel.output.currentType
            .sink { [weak self] type in
                self?.currentType = type
                self?.switchChildViewController()
                self?.updateNavigationBar()
            }
            .store(in: &cancellables)
    }
    
    private func updateNavigationBar() {
        PotiNavigationBar.configure(
            navigationItem: navigationItem,
            navigationController: navigationController,
            style: .backWithButton(title: currentType.title),
            target: self
        )
    }
    
    private func switchChildViewController() {
        if let currentChildVC = currentChildVC {
            currentChildVC.willMove(toParent: nil)
            currentChildVC.view.removeFromSuperview()
            currentChildVC.removeFromParent()
        }
        
        let childVC = MyPageHistoryViewController(viewModel: viewModel)
        addChild(childVC)
        view.addSubview(childVC.view)
        childVC.view.frame = view.bounds
        childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childVC.didMove(toParent: self)
        
        currentChildVC = childVC
    }
    
    // MARK: - Navigation Actions
    
    override func changeButtonTapped() {
        viewModel.action(.switchButtonTapped)
    }
}
