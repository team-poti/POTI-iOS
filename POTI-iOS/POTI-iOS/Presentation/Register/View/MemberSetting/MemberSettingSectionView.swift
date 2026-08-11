//
//  MemberSettingSectionView.swift
//  POTI-iOS
//
//  Created by soomin on 8/10/26.
//

import UIKit

import SnapKit
import Then

final class MemberSettingSectionView: BaseView {

    // MARK: - Properties

    var onAction: ((MemberSettingAction) -> Void)?

    private var renderedMemberIDs: [Int] = []
    private var bottomSpacingConstraint: Constraint?

    // MARK: - UI Components

    private let titleLabel = UILabel()
    private let errorView = ValidationErrorView()

    private let contentStackView = UIStackView()
    private let memberContainerView = UIView()
    private let memberRowsStackView = UIStackView()

    private let emptyStateContainerView = UIView()
    private let emptyStateLabel = UILabel()

    private let guideView = UIImageView()
    private let guideLabel = UILabel()
    private let editButton = UIButton()
    private let bottomSpacingView = UIView()
    private let grayLineView = UIView()

    // MARK: - Custom Methods

    override func setStyle() {
        titleLabel.do {
            $0.text = "멤버 설정"
            $0.font = PotiFontManager.title18sb.font
            $0.textColor = .potiBlack
        }

        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
        }

        memberRowsStackView.do {
            $0.axis = .vertical
            $0.spacing = 20
        }

        emptyStateLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray700
            $0.textAlignment = .center
        }

        guideView.do {
            $0.image = .imgHint
            $0.isHidden = true
            $0.isUserInteractionEnabled = true
        }

        guideLabel.do {
            $0.text = "모집자 본인이 보유할 멤버는 꼭 제외해주세요!"
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .poti600
            $0.textAlignment = .center
        }

        editButton.do {
            var configuration = UIButton.Configuration.filled()
            var title = AttributedString("멤버 편집")
            title.font = PotiFontManager.button14sb.font
            configuration.attributedTitle = title
            configuration.image = .icnEditWhite
            configuration.imagePadding = 5
            configuration.baseBackgroundColor = .potiBlack
            configuration.baseForegroundColor = .gray300
            configuration.cornerStyle = .medium
            $0.configuration = configuration
        }

        grayLineView.backgroundColor = .gray100
    }

    override func setUI() {
        addSubviews(titleLabel, errorView, contentStackView, grayLineView, guideView)
        memberContainerView.addSubview(memberRowsStackView)
        emptyStateContainerView.addSubview(emptyStateLabel)
        guideView.addSubview(guideLabel)
        contentStackView.addArrangedSubviews(memberContainerView, emptyStateContainerView, editButton, bottomSpacingView)
        contentStackView.setCustomSpacing(24, after: memberContainerView)
        contentStackView.setCustomSpacing(24, after: emptyStateContainerView)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(16)
        }

        errorView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }

        contentStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        memberRowsStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        emptyStateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(76)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(52)
        }

        editButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }

        bottomSpacingView.snp.makeConstraints {
            bottomSpacingConstraint = $0.height.equalTo(0).constraint
        }

        grayLineView.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(9)
        }

        guideView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(58)
            $0.bottom.equalTo(editButton.snp.top).offset(-9)
        }

        guideLabel.snp.makeConstraints {
            $0.center.equalToSuperview().offset(-6)
        }
    }

    func render(_ state: MemberSettingViewState) {
        errorView.setMessage(state.error?.message)
        guideView.isHidden = !state.showsGuide

        switch state.content {
        case .artistNotSelected:
            renderEmptyState(message: "아티스트를 먼저 선택해주세요", showsEditButton: false)

        case .members(let members):
            renderMembers(members)

        case .noSelectedMembers:
            renderEmptyState(message: "선택한 멤버가 없어요", showsEditButton: true)
        }

        if state.showsGuide { bringSubviewToFront(guideView) }
    }

    private func renderEmptyState(message: String, showsEditButton: Bool) {
        renderedMemberIDs = []
        memberRowsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        memberContainerView.isHidden = true
        emptyStateContainerView.isHidden = false
        emptyStateLabel.text = message
        editButton.isHidden = !showsEditButton
        bottomSpacingConstraint?.update(offset: showsEditButton ? 24 : 0)
    }

    private func renderMembers(_ members: [RegisterMemberItem]) {
        memberContainerView.isHidden = false
        emptyStateContainerView.isHidden = true
        editButton.isHidden = false
        bottomSpacingConstraint?.update(offset: 24)
        let memberIDs = members.map(\.id)
        guard renderedMemberIDs != memberIDs else { return }
        renderedMemberIDs = memberIDs

        memberRowsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        members.forEach { member in
            let rowView = MemberPriceRowView(memberID: member.id)
            rowView.configure(name: member.name, price: member.price)
            rowView.onAction = { [weak self] in self?.onAction?($0) }
            memberRowsStackView.addArrangedSubview(rowView)
        }
    }

    override func addTarget() {
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func editButtonTapped() {
        onAction?(.editButtonTapped)
    }
}
