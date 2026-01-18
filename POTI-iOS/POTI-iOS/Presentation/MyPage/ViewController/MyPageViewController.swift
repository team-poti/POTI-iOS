//
//  MyPageViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/16/26.
//


final class MyPageViewController: BaseViewController<Any>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        .mypage
    }
    
    private let rootView = MyPageView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func addTarget() {
        rootView.participationView.onFilterChanged  = { [weak self] type in
            switch type {
            case .all:
                print("전체 선택됨")
                // 전체 데이터 로드
            case .ongoing:
                print("진행중 선택됨")
                // 진행중 데이터 로드
            case .completed:
                print("종료 선택됨")
                // 종료 데이터 로드
            }
        }
        
        rootView.recruitmentView.onFilterChanged  = { [weak self] type in
            switch type {
            case .all:
                print("전체 선택됨")
                // 전체 데이터 로드
            case .ongoing:
                print("진행중 선택됨")
                // 진행중 데이터 로드
            case .completed:
                print("종료 선택됨")
                // 종료 데이터 로드
            }
        }
    }
}
