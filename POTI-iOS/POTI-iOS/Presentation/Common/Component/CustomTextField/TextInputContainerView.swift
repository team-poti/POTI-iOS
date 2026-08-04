//
//  TextInputContainerView.swift
//  POTI-iOS
//
//  Created by soomin on 8/3/26.
//

import UIKit

import SnapKit
import Then

final class TextInputContainerView: BaseView {

    // MARK: - UI Components

    let contentView = UIView()

    private let stackView = UIStackView()
    private let errorView = TextFieldErrorView()
    private var minimumHeightConstraint: Constraint?

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .clear

        stackView.do {
            $0.axis = .vertical
            $0.spacing = 8
        }

        contentView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray300.cgColor
        }
    }

    override func setUI() {
        addSubview(stackView)
        stackView.addArrangedSubviews(contentView, errorView)
    }

    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            minimumHeightConstraint = $0.height.greaterThanOrEqualTo(52).constraint
        }
    }

    // MARK: - Public Methods

    func setMinimumHeight(_ height: CGFloat) {
        minimumHeightConstraint?.update(offset: height)
    }

    func render(isFocused: Bool, validationState: TextFieldValidationState) {
        switch validationState {
        case .normal:
            contentView.layer.borderColor = isFocused ? UIColor.potiBlack.cgColor : UIColor.gray300.cgColor
            errorView.hide()
        case .error(let message):
            contentView.layer.borderColor = UIColor.sementicRed.cgColor
            errorView.show(message: message)
        }
    }
}
