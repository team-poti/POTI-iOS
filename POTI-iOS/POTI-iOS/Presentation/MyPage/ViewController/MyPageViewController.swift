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
    
    init(viewModel: MyPageViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.action(.viewDidLoad)
    }
    
    override func bindViewModel() {
        viewModel.output.myPage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.rootView.configure(with: model)
            }
            .store(in: &cancellables)
        
        viewModel.output.error
            .receive(on: DispatchQueue.main)
            .sink { message in
                print(message)
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
    }
    
    private func navigateToHistory(historyType: MyPageHistoryType, filterType: MyPageNavigationType) {
        let initialTab: MyPageHistoryViewController.HistoryTab
        
        switch filterType {
        case .all, .ongoing:
            initialTab = .ongoing
        case .completed:
            initialTab = .completed
        }
        
        let containerVC = factory.makeMyPageHistoryContainerViewController(initialType: historyType, initialTab: initialTab)
        navigationController?.pushViewController(containerVC, animated: true)
    }
}

enum MyPageFilterType {
    case all
    case ongoing
    case completed
}
