//
//  ProductImageSectionView.swift
//  POTI-iOS
//
//  Created by soomin on 8/4/26.
//

import UIKit

import SnapKit
import Then

final class ProductImageSectionView: BaseView {

    // MARK: - UI Components

    private let titleLabel = UILabel()
    private(set) var imagePickerView = ImagePickerView()

    // MARK: - Custom Methods

    override func setStyle() {
        titleLabel.do {
            $0.setLabel("상품 정보", font: .title18sb, color: .potiBlack)
        }
    }

    override func setUI() {
        addSubviews(titleLabel, imagePickerView)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        imagePickerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.greaterThanOrEqualTo(90)
            $0.bottom.equalToSuperview()
        }
    }
}
