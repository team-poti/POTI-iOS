//
//  ProductInfoSectionView.swift
//  POTI-iOS
//
//  Created by soomin on 8/4/26.
//

import UIKit

import SnapKit
import Then

final class ProductInfoSectionView: BaseView {

    // MARK: - UI Components

    private let stackView = UIStackView()
    private let imageSectionView = ProductImageSectionView()
    private let formView = ProductFormView()
    private let dividerView = UIView()

    var imagePickerView: ImagePickerView { imageSectionView.imagePickerView }
    var productFormView: ProductFormView { formView }

    // MARK: - Custom Methods

    override func setStyle() {
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 0
        }
        dividerView.backgroundColor = .gray100
    }

    override func setUI() {
        addSubview(stackView)
        stackView.addArrangedSubviews(imageSectionView, formView, dividerView)
    }

    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        dividerView.snp.makeConstraints {
            $0.height.equalTo(9)
        }
    }
}
