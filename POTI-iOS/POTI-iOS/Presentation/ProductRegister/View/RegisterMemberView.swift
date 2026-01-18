//
//  RegisterMemberView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class RegisterMemberView: BaseView {

    // MARK: - Property

    private var rowViews: [MemberPriceRowView] = []

    private var isEmptyState: Bool = true

    private var rowsTopOffsetConstraint: Constraint?
    private var editTopOffsetConstraint: Constraint?
    private var editButtonHeightConstraint: Constraint?
    private var bottomBoxHeightConstraint: Constraint?
    private var bottomTopToEditConstraint: Constraint?
    private var bottomTopToEmptyLabelConstraint: Constraint?

    // MARK: - UI Components

    private let titleLabel = UILabel()
    private let rowsStackView = UIStackView()
    private let editButton = UIButton(type: .system)
    private let bottomBoxView = UIView()
    private let emptyStateLabel = UILabel()


    // MARK: - Life Cycle


    // MARK: - Custom Method

    override func setStyle() {
        backgroundColor = .clear

        titleLabel.do {
            $0.text = "멤버 설정"
            $0.font = PotiFontManager.title18sb.font
            $0.textColor = .potiBlack
        }

        rowsStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 20
        }

        editButton.do {
            var config = UIButton.Configuration.filled()

            config.title = "멤버 편집"
            config.attributedTitle = AttributedString(
                "멤버 편집",
                attributes: AttributeContainer([
                    .font: PotiFontManager.button14sb.font
                ])
            )

            config.baseForegroundColor = .gray300
            config.background.backgroundColor = .potiBlack
            config.background.cornerRadius = 8

            if let image = UIImage(named: "icn-edit")
            {
                config.image = image
                config.imagePlacement = .leading
                config.imagePadding = 4
            }

            config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)

            $0.configuration = config
            $0.configurationUpdateHandler = { button in
                guard var updated = button.configuration else { return }
                updated.baseForegroundColor = .gray300
                updated.background.backgroundColor = .potiBlack
                button.configuration = updated
            }
        }

        bottomBoxView.do {
            $0.backgroundColor = .gray100
        }

        emptyStateLabel.do {
            $0.text = "아티스트를 먼저 선택해주세요"
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .gray700
            $0.textAlignment = .center
            $0.numberOfLines = 1
            $0.isHidden = true
        }
    }

    override func setUI() {
        addSubviews(titleLabel, rowsStackView, editButton, bottomBoxView, emptyStateLabel)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        rowsStackView.snp.makeConstraints {
            rowsTopOffsetConstraint = $0.top.equalTo(titleLabel.snp.bottom).offset(24).constraint
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        editButton.snp.makeConstraints {
            editTopOffsetConstraint = $0.top.equalTo(rowsStackView.snp.bottom).offset(24).constraint
            $0.horizontalEdges.equalToSuperview().inset(16)
            editButtonHeightConstraint = $0.height.equalTo(56).constraint
        }

        bottomBoxView.snp.makeConstraints {
            bottomTopToEditConstraint = $0.top.equalTo(editButton.snp.bottom).offset(24).constraint
            bottomTopToEmptyLabelConstraint = $0.top.equalTo(emptyStateLabel.snp.bottom).offset(76).constraint
            $0.horizontalEdges.equalToSuperview()
            bottomBoxHeightConstraint = $0.height.equalTo(9).constraint
            $0.bottom.equalToSuperview()
        }

        emptyStateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(76)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        applyEmptyStateLayout()
    }

    private func applyEmptyStateLayout() {
        isEmptyState = true

        emptyStateLabel.isHidden = false
        rowsStackView.isHidden = true
        editButton.isHidden = true
        bottomBoxView.isHidden = false

        rowsTopOffsetConstraint?.update(offset: 0)
        editTopOffsetConstraint?.update(offset: 0)

        bottomTopToEditConstraint?.deactivate()
        bottomTopToEmptyLabelConstraint?.activate()

        editButtonHeightConstraint?.update(offset: 0)
        bottomBoxHeightConstraint?.update(offset: 9)

        setNeedsLayout()
        layoutIfNeeded()
    }

    private func applyFilledStateLayout() {
        isEmptyState = false

        emptyStateLabel.isHidden = true
        rowsStackView.isHidden = false
        editButton.isHidden = false
        bottomBoxView.isHidden = false

        rowsTopOffsetConstraint?.update(offset: 24)
        editTopOffsetConstraint?.update(offset: 24)

        bottomTopToEmptyLabelConstraint?.deactivate()
        bottomTopToEditConstraint?.activate()

        editButtonHeightConstraint?.update(offset: 56)
        bottomBoxHeightConstraint?.update(offset: 9)

        setNeedsLayout()
        layoutIfNeeded()
    }

    func configure(members: [String]) {
        rowViews.forEach { $0.removeFromSuperview() }
        rowViews.removeAll()
        rowsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (idx, name) in members.enumerated() {
            let row = MemberPriceRowView(index: idx)
            row.setName(name)

            rowsStackView.addArrangedSubview(row)
            rowViews.append(row)
        }

        if members.isEmpty {
            applyEmptyStateLayout()
        } else {
            applyFilledStateLayout()
        }
    }

    func setPrice(_ text: String, at index: Int) {
        guard rowViews.indices.contains(index) else { return }
        rowViews[index].setPrice(text)
    }

    func setEditButtonTarget(_ target: Any?, action: Selector) {
        editButton.addTarget(target, action: action, for: .touchUpInside)
    }

    func collectPrices() -> [Int: Int] {
        endEditing(true)

        var result: [Int: Int] = [:]

        for row in rowViews {
            let index = row.index
            if let price = row.currentPrice {
                result[index] = price
            }
        }

        return result
    }
}
