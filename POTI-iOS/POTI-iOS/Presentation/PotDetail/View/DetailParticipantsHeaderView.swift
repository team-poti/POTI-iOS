//
//  DetailParticipantsHeaderView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class DetailParticipantsHeaderView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        titleLabel.do {
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
            $0.text = "참여자"
        }
        
        countLabel.do {
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .poti600
        }
    }
    
    private func setUI() {
        addSubviews(titleLabel, countLabel)
    }
    
    private func setLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
    }
    
    func configure(currentCount: Int, totalCount: Int) {
        countLabel.text = "\(currentCount)/\(totalCount)"
    }
}
