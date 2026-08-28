//
//  MyPageHistoryHeaderView.swift
//  POTI-iOS
//
//  Created by Neon on 8/27/26.
//

import UIKit

import SnapKit
import Then

final class MyPageHistoryHeaderView: BaseView {
    var onTypeSelected: ((MyPageHistoryType) -> Void)?

    private let recruitmentButton = UIButton(type: .system)
    private let participationButton = UIButton(type: .system)
    private let stackView = UIStackView()

    override func setStyle() {
        backgroundColor = .potiWhite

        configureButton(
            recruitmentButton,
            title: "모집내역",
            type: .recruitment
        )
        configureButton(
            participationButton,
            title: "참여내역",
            type: .participation
        )

        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 8
        }
    }

    override func setUI() {
        stackView.addArrangedSubviews(
            recruitmentButton,
            participationButton
        )
        addSubview(stackView)
    }

    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview()
        }
    }

    func updateSelection(_ type: MyPageHistoryType) {
        update(
            recruitmentButton,
            selected: type == .recruitment
        )
        update(
            participationButton,
            selected: type == .participation
        )
    }
}

private extension MyPageHistoryHeaderView {
    func configureButton(
        _ button: UIButton,
        title: String,
        type: MyPageHistoryType
    ) {
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 4,
            bottom: 0,
            trailing: 4
        )
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = PotiFontManager.title18sb.font
            return attributes
        }
        configuration.background.backgroundColor = .clear
        configuration.background.backgroundColorTransformer = UIConfigurationColorTransformer { _ in
            .clear
        }
        button.configuration = configuration
        button.tag = type.tag
        button.addTarget(
            self,
            action: #selector(typeButtonTapped(_:)),
            for: .touchUpInside
        )
    }

    func update(_ button: UIButton, selected: Bool) {
        button.isSelected = selected
        var configuration = button.configuration
        configuration?.baseForegroundColor = selected ? .potiBlack : .gray500
        configuration?.background.backgroundColor = .clear
        button.configuration = configuration
    }

    @objc func typeButtonTapped(_ sender: UIButton) {
        guard let type = MyPageHistoryType(tag: sender.tag) else { return }
        onTypeSelected?(type)
    }
}

private extension MyPageHistoryType {
    var tag: Int {
        switch self {
        case .recruitment:
            return 0
        case .participation:
            return 1
        }
    }

    init?(tag: Int) {
        switch tag {
        case 0:
            self = .recruitment
        case 1:
            self = .participation
        default:
            return nil
        }
    }
}
