//
//  IdolGroupCell.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class IdolGroupCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let containerView = UIView()
    private let groupImageView = UIImageView()
    private let selectedImageView = UIImageView()
    private let nameLabel = UILabel()
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setStyle() {
        containerView.do {
            $0.layer.cornerRadius = 45
            $0.clipsToBounds = true
        }
        
        groupImageView.do {
            $0.contentMode = .scaleAspectFill
        }
        
        selectedImageView.do {
            $0.image = .imgSelected
            $0.contentMode = .scaleAspectFit
            $0.isHidden = true
        }
        
        nameLabel.do {
            $0.font = PotiFontManager.caption12m.font
            $0.textColor = .gray800
            $0.textAlignment = .center
        }
    }
    
    private func setUI() {
        contentView.addSubviews(containerView, nameLabel)
        containerView.addSubviews(groupImageView, selectedImageView)
    }
    
    private func setLayout() {
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(90)
        }
        
        groupImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        selectedImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    
    func configure(with item: IdolGroupModel) {
        nameLabel.text = item.name
        if let url = URL(string: item.image ?? "") {
            groupImageView.kf.setImage(
                with: url,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        }
        updateSelectedState()
    }
    
    private func updateSelectedState() {
        selectedImageView.isHidden = !isSelected
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        groupImageView.kf.cancelDownloadTask()
        groupImageView.image = nil
        nameLabel.text = nil
        isSelected = false
    }
}
