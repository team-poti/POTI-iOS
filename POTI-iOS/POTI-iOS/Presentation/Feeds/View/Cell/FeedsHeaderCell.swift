//
//  FeedsHeaderCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import UIKit

import SnapKit
import Then

protocol FeedsHeaderCellDelegate: AnyObject {
    func filterButtonDidTap()
}

final class FeedsHeaderCell: UICollectionReusableView {
    
    // MARK: - Property
    
    weak var delegate: FeedsHeaderCellDelegate?
    
    // MARK: - UI Components
    
    private let filterButton = UIButton()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
        addTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        self.backgroundColor = .potiWhite
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = .icnArrowDownSm
        configuration.imagePlacement = .trailing
        configuration.background.backgroundColor = .clear
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        filterButton.do {
            $0.configuration = configuration
            // 💡 화살표 이미지 색상도 글자색과 맞추기 위해 tintColor는 유지합니다.
            $0.tintColor = .potiBlack
            
            $0.configurationUpdateHandler = { button in
                guard var updatedConfiguration = button.configuration else { return }
                updatedConfiguration.image = button.isSelected ? .icnArrowUpSm : .icnArrowDownSm
                button.configuration = updatedConfiguration
            }
        }
    }
    
    private func setUI() {
        addSubviews(filterButton)
    }
    
    private func setLayout() {
        filterButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Private Method
    
    private func addTarget() {
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Action
    
    @objc private func filterButtonTapped() {
        delegate?.filterButtonDidTap()
    }
}

// MARK: - Extension

extension FeedsHeaderCell {
    func configure(text: String, isFilterVisible: Bool) {
        if var updatedConfig = filterButton.configuration {
            var titleAttributes = AttributeContainer()
            titleAttributes.font = PotiFontManager.body14m.font
            titleAttributes.foregroundColor = .potiBlack
            
            updatedConfig.attributedTitle = AttributedString(text, attributes: titleAttributes)
            
            filterButton.configuration = updatedConfig
        }
        
        filterButton.isHidden = !isFilterVisible
    }
    
    func setFilterButtonState(isSelected: Bool) {
        filterButton.isSelected = isSelected
    }
}

