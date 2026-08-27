//
//  SettingsActionButton.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

import SnapKit
import Then

final class SettingsActionButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        self.do {
            $0.setTitle(title, for: .normal)
            $0.titleLabel?.font = PotiFontManager.button16sb.font
            $0.setTitleColor(.potiWhite, for: .normal)
            $0.backgroundColor = .gray700
            $0.layer.cornerRadius = 26
            $0.isEnabled = false
        }
        snp.makeConstraints {
            $0.height.equalTo(52)
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
        backgroundColor = enabled ? .potiBlack : .gray700
    }
}
