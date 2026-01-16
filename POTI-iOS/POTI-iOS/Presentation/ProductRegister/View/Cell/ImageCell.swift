//
//  ImageCell.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class ImageCell: UICollectionViewCell {

    // MARK: - Property
    
    var onTapDelete: (() -> Void)?

    // MARK: - UI Components
    
    private let boxView = UIView()
    private let imageView = UIImageView()
    private let deleteButton = UIButton(type: .custom)

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setStyle()
        addTarget()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Custom Method
    
    private func setStyle() {
        boxView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }

        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }

        deleteButton.do {
            $0.setImage(
                UIImage(named: "btn-delete-light")?.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            $0.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    private func setUI() {
        contentView.addSubview(boxView)
        boxView.addSubviews(imageView, deleteButton)
    }

    private func setLayout() {
        boxView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(90)
        }

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(5)
            $0.width.height.equalTo(22)
        }
    }
    
    // MARK: - Action Method

    private func addTarget() {
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
    }

    func configure(image: UIImage) {
        imageView.image = image
    }

    @objc private func didTapDelete() {
        onTapDelete?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onTapDelete = nil
        imageView.image = nil
    }
}
