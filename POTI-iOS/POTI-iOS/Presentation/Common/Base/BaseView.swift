//
//  BaseView.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/9/26.
//

import UIKit

class BaseView: UIView {

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Method

    /// UI 컴포넌트 속성 설정 (do 메서드)
    func setStyle() {}

    /// UI 위계 설정 (addSubview)
    func setUI() {}

    /// 오토레이아웃 설정
    func setLayout() {}
}
