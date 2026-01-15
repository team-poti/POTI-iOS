//
//  ValidNicknameViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class ValidNicknameViewController: BaseViewController<Any>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        .backButton
    }
    
    private let rootView = ValidNicknameView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func addTarget() {
        rootView.nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }
}

extension ValidNicknameViewController {
    @objc private func nextButtonDidTap() {
        // TODO: - 추후 이동 로직 뷰모델 안에 넣기
        let selectFavoriteGroupViewController = SelectFavoriteGroupViewController()
        self.navigationController?.pushViewController(selectFavoriteGroupViewController, animated: true)
    }
}
