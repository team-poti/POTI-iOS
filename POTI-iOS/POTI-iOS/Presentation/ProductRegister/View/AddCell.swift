//
//  AddCell.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class AddCell: UICollectionViewCell {
    
    // MARK: - Identifier
    static let reuseId = "AddCell"
    
    // MARK: - Callback
    var onTapUpload: (() -> Void)?

    // MARK: - UI
    private let uploadButton = UIButton(type: .custom)

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setStyle()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup UI
    private func setUI() {
        contentView.addSubview(uploadButton)
        uploadButton.addTarget(self, action: #selector(didTapUpload), for: .touchUpInside)
    }

    // MARK: - Layout
    private func setLayout() {
        uploadButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(90)
        }
    }

    // MARK: - Style
    private func setStyle() {
        uploadButton.do {
            $0.setImage(
                UIImage(named: "btn-upload")?.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            $0.tintColor = nil
            $0.imageView?.contentMode = .scaleAspectFit
        }
    }

    // MARK: - Action
    @objc private func didTapUpload() {
        onTapUpload?()
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        onTapUpload = nil
    }
}
