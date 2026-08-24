//
//  ImageAddCell.swift
//  POTI-iOS
//
//  Created by soomin on 8/7/26.
//

import UIKit

import SnapKit
import Then

final class ImageAddCell: UICollectionViewCell {

    // MARK: - Property

    var onTapAdd: (() -> Void)?

    // MARK: - UI Component

    private let uploadButton = UIButton()

    // MARK: - Life Cycles

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
        setStyle()
        addTarget()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onTapAdd = nil
    }

    // MARK: - Private Methods

    private func setStyle() {
        uploadButton.do {
            $0.setImage(.btnUpload.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }

    private func setUI() {
        contentView.addSubview(uploadButton)
    }

    private func setLayout() {
        uploadButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(90)
        }
    }

    private func addTarget() {
        uploadButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    // MARK: - Action

    @objc private func addButtonTapped() {
        onTapAdd?()
    }
}
