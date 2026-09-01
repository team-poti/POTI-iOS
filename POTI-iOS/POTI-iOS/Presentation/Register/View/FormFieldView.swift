//
//  FormFieldView.swift
//  POTI-iOS
//
//  Created by soomin on 8/10/26.
//

import UIKit

import SnapKit
import Then

final class FormFieldView: BaseView {

    // MARK: - UI Components

    private let titleLabel = UILabel()
    private let fieldView: UIView

    // MARK: - Initializer

    init(title: String, fieldView: UIView) {
        self.fieldView = fieldView
        super.init(frame: .zero)
        titleLabel.setLabel(title, font: .body14sb, color: .potiBlack)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {
        titleLabel.setLabel(titleLabel.text ?? "", font: .body14sb, color: .potiBlack)
    }

    override func setUI() {
        addSubviews(titleLabel, fieldView)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }

        fieldView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
