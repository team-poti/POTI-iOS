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
}
