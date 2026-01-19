//
//  DetailEmptyCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class DetailEmptyCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let messageLabel = UILabel()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        messageLabel.do {
            $0.text = "현재 참여 중인 사용자가 없어요"
            $0.textColor = .gray700
            $0.font = PotiFontManager.body14m.font
            $0.textAlignment = .center
        }
    }
    
    private func setUI() {
        addSubview(messageLabel)
    }
    
    private func setLayout() {
        messageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(40)
        }
    }
}
