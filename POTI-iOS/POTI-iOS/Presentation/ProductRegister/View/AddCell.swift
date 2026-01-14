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
    
    // MARK: - Properties
    
    static let identifier = "AddCell"
    
    var onTapUpload: (() -> Void)?

    // MARK: - UI Components
    
    private let uploadButton = UIButton(type: .custom)

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setStyle()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Custom Method
    
    private func setUI() {
        contentView.addSubview(uploadButton)
        uploadButton.addTarget(self, action: #selector(didTapUpload), for: .touchUpInside)
    }

    private func setLayout() {
        uploadButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(90)
        }
    }

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

    // MARK: - Action Method
    
    @objc private func didTapUpload() {
        onTapUpload?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onTapUpload = nil
    }
}
