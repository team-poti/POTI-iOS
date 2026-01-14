//
//  ProductInfoView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class ProductInfoView: BaseView {

    // MARK: - Output

    var onTapAddImage: (() -> Void)?
    var onTapDeleteImage: ((Int) -> Void)?

    // MARK: - UI

    private let imagePickerView = ImagePickerView()

    private let titleLabel = UILabel()

    // MARK: - Override

    override func setStyle() {
        backgroundColor = .clear

        titleLabel.do {
            $0.text = "상품 정보"
            $0.font = PotiFontManager.title18sb.font
            $0.textColor = .potiBlack
        }

        imagePickerView.onTapAdd = { [weak self] in
            self?.onTapAddImage?()
        }

        imagePickerView.onTapDelete = { [weak self] index in
            self?.onTapDeleteImage?(index)
        }

        // TODO: imageCollectionView
    }

    override func setUI() {
        addSubview(titleLabel)
        addSubview(imagePickerView)

        // TODO: 아래 필드들은 다음 단계에서 하나씩 추가
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }

        imagePickerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(90)
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - Public

    func setImages(_ images: [UIImage]) {
        imagePickerView.setImages(images)
    }
}

#Preview {
    ProductInfoView()
}
