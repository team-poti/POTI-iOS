//
//  ShippingSettingSectionView.swift
//  POTI-iOS
//
//  Created by soomin on 8/11/26.
//

import UIKit

import SnapKit
import Then

final class ShippingSettingSectionView: BaseView {

    // MARK: - Properties

    var onAction: ((ShippingSettingAction) -> Void)?
    var onInputFocus: ((UIView) -> Void)?

    private var renderedOptionIDs: [Int] = []
    private var rowViews: [Int: ShippingRowView] = [:]

    // MARK: - UI Components

    private let titleLabel = UILabel()
    private let errorView = ValidationErrorView()
    private let rowsStackView = UIStackView()

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .clear

        titleLabel.do {
            $0.setLabel("배송 설정", font: .title18sb, color: .potiBlack)
        }

        rowsStackView.do {
            $0.axis = .vertical
            $0.spacing = 20
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }

    override func setUI() {
        addSubviews(titleLabel, errorView, rowsStackView)
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

        rowsStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
        }
    }

    // MARK: - Private Method

    private func makeRows(for options: [RegisterShippingOptionItem]) {
        rowsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        renderedOptionIDs = options.map(\.deliveryMethodID)
        rowViews.removeAll()

        options.forEach { option in
            let rowView = ShippingRowView(deliveryMethodID: option.deliveryMethodID)
            rowView.onAction = { [weak self] in self?.onAction?($0) }
            rowView.onInputFocus = { [weak self] in self?.onInputFocus?($0) }
            rowViews[option.deliveryMethodID] = rowView
            rowsStackView.addArrangedSubview(rowView)
        }
    }

    // MARK: - Public Method

    func render(_ state: ShippingSettingViewState) {
        errorView.setMessage(state.error?.message)

        let optionIDs = state.options.map(\.deliveryMethodID)
        if renderedOptionIDs != optionIDs {
            makeRows(for: state.options)
        }

        state.options.forEach { rowViews[$0.deliveryMethodID]?.render($0) }
    }
}
