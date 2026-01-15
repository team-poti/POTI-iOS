//
//  SelectFavoriteGroupViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class SelectFavoriteGroupViewController: BaseViewController<Any>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        .backButton
    }
    
    private let rootView = SelectFavoriteGroupView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func addTarget() {
        rootView.skipButton.addTarget(self, action: #selector(skipButtonDidTap), for: .touchUpInside)
        rootView.startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    }
}

extension SelectFavoriteGroupViewController {
    @objc private func skipButtonDidTap() {
        // TODO: - 루트뷰 탭바로 바꾸기
    }
    
    @objc private func startButtonDidTap() {
        // TODO: - 서버에 선택한 그룹 id 보내기 + 루트뷰 탭바로 바꾸기
    }
}
