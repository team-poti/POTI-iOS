//
//  MyPageViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/16/26.
//


final class MyPageViewController: BaseViewController<MyPageViewModel>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        .mypage
    }
    
    private let rootView = MyPageView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.action(.viewDidLoad)
    }
    
    override func addTarget() {
        /// 참여 내역 버튼
        rootView.participationView.onFilterChanged = { [weak self] type in
            self?.navigateToHistory(historyType: .participation, filterType: type)
        }
                
        /// 모집 내역 버튼
        rootView.recruitmentView.onFilterChanged = { [weak self] type in
            self?.navigateToHistory(historyType: .recruitment, filterType: type)
        }
    }
    
    private func navigateToHistory(historyType: MyPageHistoryType, filterType: MyPageNavigationType) {
        // filterType에 따라 초기 탭 결정
        let initialTab: MyPageHistoryViewController.HistoryTab
        
        switch filterType {
        case .all, .ongoing:
            initialTab = .ongoing  // 전체 or 진행중 → 진행중 탭
        case .completed:
            initialTab = .completed  // 종료 → 종료 탭
        }
        
        let containerVC = MyPageHistoryContainerViewController(initialType: historyType, initialTab: initialTab)
        navigationController?.pushViewController(containerVC, animated: true)
    }
}

enum MyPageFilterType {
    case all
    case ongoing
    case completed
}
