//
//  MemberCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/16/26.
//

import UIKit

import SnapKit
import Then

enum MemberCellStyle {
    case selected
    case unselected
}

final class MemberCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let backgroundContainerView = UIView()
    private var memberNameLabel = UILabel()
    
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
            $0.backgroundColor = .poti600
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }
        
        memberNameLabel.do {
            $0.font = PotiFontManager.button16sb.font
        }
    }
    
    private func setUI() {
        addSubview(backgroundContainerView)
        backgroundContainerView.addSubviews(memberNameLabel)
    }
    
    private func setLayout() {
        backgroundContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        memberNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension MemberCell {
    func configure(name: String, style: MemberCellStyle) {
        memberNameLabel.text = name
        
        switch style {
        case .selected:
            backgroundContainerView.do {
                $0.backgroundColor = .poti600
            }
            memberNameLabel.do {
                $0.textColor = .potiWhite
            }
            
        case .unselected:
            backgroundContainerView.do {
                $0.backgroundColor = .gray100
            }
            memberNameLabel.do {
                $0.textColor = .gray800
            }
        }
    }
}
