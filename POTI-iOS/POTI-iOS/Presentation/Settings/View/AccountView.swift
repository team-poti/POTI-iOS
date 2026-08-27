//
//  AccountView.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

import SnapKit
import Then

final class AccountView: BaseView {
    let logoutButton = SettingsMenuButton(title: "로그아웃")
    let withdrawalButton = SettingsMenuButton(title: "회원 탈퇴")
    private let nameRow = SettingsMenuButton(title: "이름", showsArrow: false)
    private let emailRow = SettingsMenuButton(title: "이메일", showsArrow: false)
    private let socialRow = SettingsMenuButton(title: "연결된 소셜 계정", showsArrow: false)
    private let infoStackView = UIStackView()
    private let actionStackView = UIStackView()
    private let dividerView = UIView()

    override func setStyle() {
        backgroundColor = .potiWhite
        [infoStackView, actionStackView].forEach {
            $0.do {
                $0.axis = .vertical
            }
        }
        dividerView.backgroundColor = .gray100
    }

    override func setUI() {
        infoStackView.addArrangedSubviews(nameRow, emailRow, socialRow)
        actionStackView.addArrangedSubviews(logoutButton, withdrawalButton)
        addSubviews(infoStackView, dividerView, actionStackView)
    }

    override func setLayout() {
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        dividerView.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(8)
        }
        actionStackView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func configure(_ account: AccountEntity) {
        nameRow.updateValue(account.nickname)
        emailRow.updateValue(account.email)
        socialRow.updateValue(account.socialAccount)
    }
}
