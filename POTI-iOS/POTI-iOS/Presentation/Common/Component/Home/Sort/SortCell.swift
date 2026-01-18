//
//  SortCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/16/26.
//

import UIKit

import SnapKit
import Then

final class SortCell: UITableViewCell {
    
    static let identifier: String = "SortCell"
    
    // MARK: - UI Components
    
    private let optionLabel = UILabel()
    private let selectIcon = UIImageView()
    private let separatorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        selectionStyle = .none
        backgroundColor = .potiWhite
        
        optionLabel.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
        }
        
        selectIcon.do {
            $0.image = .btnCheckboxSelected
        }
        
        separatorView.do {
            $0.backgroundColor = .gray300
        }
    }
    
    private func setUI() {
        contentView.addSubviews(optionLabel, selectIcon, separatorView)
    }
    
    private func setLayout() {
        optionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        selectIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(optionLabel)
            $0.size.equalTo(24)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(optionLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
}

extension SortCell {
    func configure(text: String, isSelected: Bool, isLast: Bool) {
        optionLabel.text = text
        selectIcon.isHidden = !isSelected
        separatorView.isHidden = isLast
    }
}

#Preview {
    SortBottomSheet(viewModel: SortViewModel(initialIndex: 0))
}
