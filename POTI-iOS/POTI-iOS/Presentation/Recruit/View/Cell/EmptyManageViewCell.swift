//
//  EmptyManageViewCell.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class EmptyManageViewCell: UITableViewCell {
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .potiWhite
        
        setUI()
        setStyle()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Component
    
    private let titleLabel = UILabel()
    
    // MARK: - Custom Method
    
    private func setStyle() {
        titleLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray700
            $0.text = "아직 참여자가 없어요"
        }
    }
    
    private func setUI() {
        titleLabel.addSubview(titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(52)
        }
    }
}
