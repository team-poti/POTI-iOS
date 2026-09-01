//
//  ArtistMembersFilterCell.swift
//  POTI-iOS
//
//  Created by soomin on 6/8/26.
//

import UIKit

import SnapKit
import Then

final class ArtistMembersFilterCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let backgroundContainerView = UIView()
    private let memberNameLabel = UILabel()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        backgroundContainerView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }
        
        memberNameLabel.do {
            $0.setLabel("", font: .button16sb)
        }
    }
    
    private func setUI() {
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(memberNameLabel)
    }
    
    private func setLayout() {
        backgroundContainerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        memberNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-1)
        }
    }
    
    // MARK: - Public Method
    
    func configure(name: String, isSelected: Bool) {
        memberNameLabel.setLabel(name, font: .button16sb)
        backgroundContainerView.backgroundColor = isSelected ? .poti600 : .gray100
        memberNameLabel.textColor = isSelected ? .potiWhite : .gray800
    }
}
