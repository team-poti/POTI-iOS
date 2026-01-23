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

    // MARK: - Callbacks

    var onPriceChanged: ((Int, Int?) -> Void)?

    // MARK: - UI

    private let titleLabel = UILabel()
    private let rowsStackView = UIStackView()
    private let bottomBoxView = UIView()

    private let emptyStateLabel = UILabel()
    private let errorStackView = UIStackView()
    private let errorIconView = UIImageView()
    private let errorLabel = UILabel()

    // MARK: - Lifecycle

    override func setStyle() {
        backgroundColor = .clear
        isUserInteractionEnabled = true

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
            $0.isHidden = true
            $0.isUserInteractionEnabled = true
        }

        bottomBoxView.do {
            $0.backgroundColor = .gray100
            $0.isUserInteractionEnabled = false
        }

        emptyStateLabel.do {
            $0.text = "아티스트를 먼저 선택해주세요"
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .gray700
            $0.textAlignment = .center
            $0.numberOfLines = 1
            $0.isHidden = false
            $0.isUserInteractionEnabled = false
        }

        errorStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.alignment = .center
            $0.distribution = .fill
            $0.isHidden = true
            $0.isUserInteractionEnabled = false
        }

        errorIconView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = UIImage.icnNotice
            $0.tintColor = .sementicRed
            $0.isUserInteractionEnabled = false
        }

        errorLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .sementicRed
            $0.numberOfLines = 0
            $0.isUserInteractionEnabled = false
        }
    }

    override func setUI() {
        addSubviews(titleLabel, errorStackView, emptyStateLabel, rowsStackView, bottomBoxView)
        errorStackView.addArrangedSubviews(errorIconView, errorLabel)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        errorStackView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
        }

        errorIconView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }

        emptyStateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(76)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        rowsStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        bottomBoxView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(rowsStackView.snp.bottom).offset(24)
            $0.top.greaterThanOrEqualTo(emptyStateLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(9)
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - Public

    func showEmpty(message: String) {
        emptyStateLabel.text = message
        emptyStateLabel.isHidden = false
        rowsStackView.isHidden = true
        hideEditedEmptyError()
    }

    func showMembers(names: [String]) {
        emptyStateLabel.isHidden = true
        rowsStackView.isHidden = false
        hideEditedEmptyError()

        rowsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (idx, name) in names.enumerated() {
            let row = MemberPriceRowView(index: idx)
            row.configure(name: name, price: nil)

            // 입력은 VC가 관리하지만, 여기서 index 전달은 해준다.
            row.onPriceChanged = { [weak self] index, price in
                self?.onPriceChanged?(index, price)
            }
            row.onBeginEditing = { [weak self] _ in
                // 필요하면 여기서 힌트 숨김 같은 UI 반응만 처리.
                _ = self
            }

            rowsStackView.addArrangedSubview(row)
        }

        setNeedsLayout()
        layoutIfNeeded()
    }

    func showEditedEmptyError(message: String = "멤버를 1명 이상 추가해주세요") {
        errorLabel.text = message
        errorStackView.isHidden = false
        setNeedsLayout()
    }

    func hideEditedEmptyError() {
        errorStackView.isHidden = true
        setNeedsLayout()
    }
}
