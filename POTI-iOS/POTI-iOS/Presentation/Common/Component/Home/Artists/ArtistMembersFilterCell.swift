//
//  ArtistMembersFilterCell.swift
//  POTI-iOS
//
//  Created by mandoo on 6/8/26.
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
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        backgroundContainerView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }
        
        memberNameLabel.do {
            $0.font = PotiFontManager.button16sb.font
        }
    }
    
    private func setUI() {
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(memberNameLabel)
    }
    
    private func setLayout() {
        backgroundContainerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        memberNameLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    // MARK: - Public Method
    
    func configure(name: String, isSelected: Bool) {
        memberNameLabel.text = name
        backgroundContainerView.backgroundColor = isSelected ? .poti600 : .gray100
        memberNameLabel.textColor = isSelected ? .potiWhite : .gray800
    }
}
