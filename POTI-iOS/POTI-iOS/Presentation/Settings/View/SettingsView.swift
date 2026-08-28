//
//  SettingsView.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

import SnapKit
import Then

final class SettingsView: BaseView {
    let accountButton = SettingsMenuButton(title: "내 계정")
    let profileButton = SettingsMenuButton(title: "내 프로필 관리")
    let addressButton = SettingsMenuButton(title: "내 주소 관리")
    let notificationButton = SettingsMenuButton(title: "알림 설정")
    let policyButton = SettingsMenuButton(title: "개인정보 처리방침 및 이용 약관")
    private let versionRow = SettingsMenuButton(title: "버전 정보", value: "1.0.0", showsArrow: false)
    private let contentStackView = UIStackView()

    private lazy var informationSection = SettingsSectionView(
        title: "내 정보",
        rows: [accountButton, profileButton, addressButton]
    )
    private lazy var appSection = SettingsSectionView(
        title: "앱 설정",
        rows: [notificationButton],
        topInset: 12
    )
    private lazy var serviceSection = SettingsSectionView(
        title: "서비스 정보",
        rows: [policyButton, versionRow],
        topInset: 12
    )

    override func setStyle() {
        backgroundColor = .potiWhite
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
        }
    }

    override func setUI() {
        contentStackView.addArrangedSubviews(
            informationSection,
            makeDivider(),
            appSection,
            makeDivider(),
            serviceSection
        )
        addSubview(contentStackView)
    }

    override func setLayout() {
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.horizontalEdges.equalToSuperview()
        }
    }

    private func makeDivider() -> UIView {
        let view = UIView().then {
            $0.backgroundColor = .gray100
        }
        view.snp.makeConstraints {
            $0.height.equalTo(8)
        }
        return view
    }
}
