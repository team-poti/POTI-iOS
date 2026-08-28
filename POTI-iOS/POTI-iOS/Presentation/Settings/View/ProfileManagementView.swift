//
//  ProfileManagementView.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class ProfileManagementView: BaseView {
    let nicknameField = SettingsFieldView(title: "닉네임", placeholder: "닉네임을 입력하세요")
    let editImageButton = UIButton(type: .system)
    let saveButton = SettingsActionButton(title: "저장")
    private let profileImageView = UIImageView(image: UIImage(resource: .profilepic))

    override func setStyle() {
        backgroundColor = .potiWhite
        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        editImageButton.do {
            $0.backgroundColor = .gray900
            $0.setImage(UIImage(resource: .icnEdit2).withRenderingMode(.alwaysOriginal), for: .normal)
            $0.layer.cornerRadius = 18
        }
    }

    override func setUI() {
        addSubviews(
            profileImageView,
            editImageButton,
            nicknameField,
            saveButton
        )
    }

    override func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(98)
        }
        editImageButton.snp.makeConstraints {
            $0.trailing.equalTo(profileImageView).offset(8)
            $0.bottom.equalTo(profileImageView)
            $0.size.equalTo(36)
        }
        nicknameField.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        saveButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }

    func configure(_ profile: ProfileManagementEntity) {
        nicknameField.textField.text = profile.nickname
        updateSaveButtonState()

        guard let profileImageURL = profile.profileImageURL,
              let url = URL(string: profileImageURL),
              url.scheme != nil else {
            profileImageView.kf.cancelDownloadTask()
            profileImageView.image = UIImage(resource: .profilepic)
            return
        }

        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(resource: .profilepic)
        )
    }

    func setProfileImage(_ image: UIImage) {
        profileImageView.kf.cancelDownloadTask()
        profileImageView.image = image
    }

    var nickname: String {
        nicknameField.textField.text ?? ""
    }

    var canSave: Bool {
        !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func updateSaveButtonState() {
        saveButton.setEnabled(canSave)
    }
}
