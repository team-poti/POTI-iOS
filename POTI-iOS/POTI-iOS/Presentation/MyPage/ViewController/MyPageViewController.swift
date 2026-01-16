//
//  MyPageViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/16/26.
//


final class MyPageViewController: BaseViewController<Any> {
    
    private let filterView = MyPageNavigationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 숫자 설정
        filterView.configure(counts: (all: 3, ongoing: 2, completed: 1))
        
        view.addSubview(filterView)
        
        filterView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
