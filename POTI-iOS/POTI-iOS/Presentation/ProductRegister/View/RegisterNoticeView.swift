//
//  RegisterNoticeView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class RegisterNoticeView: BaseView {

    // MARK: - Property

    private var bodyLabels: [UILabel] = []

    // MARK: - UI Components

    private let stackView = UIStackView()
    private let titleLabel = UILabel()

    // MARK: - Custom Method

    func configure(title: String, bodyTexts: [String]) {
        titleLabel.text = title

        bodyLabels.forEach { $0.removeFromSuperview() }
        bodyLabels.removeAll()

        let labels: [UILabel] = bodyTexts.map { text in
            let label = UILabel()
            label.do {
                $0.numberOfLines = 0
                $0.textAlignment = .left
                $0.font = PotiFontManager.caption12m.font
                $0.textColor = .gray800
                $0.text = text
            }
            return label
        }

        bodyLabels = labels

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackView.addArrangedSubview(titleLabel)
        labels.forEach { stackView.addArrangedSubview($0) }
    }

    func configure(text: String) {
        let parts = text
            .components(separatedBy: "\n\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        if parts.isEmpty {
            configure(title: "", bodyTexts: [])
            return
        }

        let title = parts.first ?? ""
        let body = Array(parts.dropFirst())
        configure(title: title, bodyTexts: body)
    }

    // MARK: - UI Setting

    override func setStyle() {
        backgroundColor = .clear

        stackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .fill
        }

        titleLabel.do {
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .potiBlack
        }
    }

    override func setUI() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
    }

    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
}
