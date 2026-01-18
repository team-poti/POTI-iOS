//
//  RegisterNoticeView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit

final class RegisterNoticeView: BaseView {

    // MARK: - Property

    private var text: String = ""

    // MARK: - UI Components

    private let noticeLabel = UILabel()

    // MARK: - Custom Method

    func configure(text: String) {
        self.text = text
        noticeLabel.text = text
    }

    // MARK: - UI Setting

    override func setStyle() {
        backgroundColor = .clear

        noticeLabel.do {
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.font = PotiFontManager.caption12m.font
            $0.textColor = .gray800
        }
    }

    override func setUI() {
        addSubview(noticeLabel)
    }

    override func setLayout() {
        noticeLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
}
