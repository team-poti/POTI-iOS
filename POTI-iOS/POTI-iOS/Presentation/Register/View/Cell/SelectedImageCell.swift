//
//  SelectedImageCell.swift
//  POTI-iOS
//
//  Created by soomin on 8/7/26.
//

import UIKit

import SnapKit
import Then

final class SelectedImageCell: UICollectionViewCell {

    // MARK: - Property

    var onTapDelete: (() -> Void)?

    // MARK: - UI Components

    private let containerView = UIView()
    private let imageView = UIImageView()
    private let deleteButton = UIButton()

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
        setStyle()
        setAddTarget()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onTapDelete = nil
        imageView.image = nil
    }

    // MARK: - Private Methods

    private func setStyle() {
        containerView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }

        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }

        deleteButton.do {
            $0.setImage(.btnDeleteLight.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
        }
    }

    private func setUI() {
        contentView.addSubview(containerView)
        containerView.addSubviews(imageView, deleteButton)
    }

    private func setLayout() {
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(90)
        }

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(5)
            $0.size.equalTo(22)
        }
    }
    
    private func setAddTarget() {
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }

    // MARK: - Public Method

    func configure(image: UIImage) {
        imageView.image = image
    }

    // MARK: - Action

    @objc private func deleteButtonTapped() {
        onTapDelete?()
    }
}
