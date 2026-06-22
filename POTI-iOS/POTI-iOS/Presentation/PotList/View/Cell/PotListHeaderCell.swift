//
//  PotListHeaderCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import UIKit

import SnapKit
import Then

protocol PotListHeaderCellDelegate: AnyObject {
    func memberFilterButtonDidTap()
    func sortButtonDidTap()
}

final class PotListHeaderCell: UICollectionReusableView {
    
    // MARK: - Property
    
    weak var delegate: PotListHeaderCellDelegate?
    
    // MARK: - UI Components
    
    private let memberFilterButton = UIButton()
    private let sortButton = UIButton()
    
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
        memberFilterButton.do {
            $0.setTitle("멤버 선택", for: .normal)
            $0.setTitleColor(.potiBlack, for: .normal)
            $0.titleLabel?.font = PotiFontManager.body14m.font
            $0.setImage(.icnArrowDownSm, for: .normal)
            $0.setImage(.icnArrowUpSm, for: .selected)
            $0.semanticContentAttribute = .forceRightToLeft
        }
        
        sortButton.do {
            $0.setTitleColor(.potiBlack, for: .normal)
            $0.titleLabel?.font = PotiFontManager.body14m.font
            $0.setImage(.icnArrowDownSm, for: .normal)
            $0.setImage(.icnArrowUpSm, for: .selected)
            $0.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    private func setUI() {
        addSubviews(memberFilterButton, sortButton)
    }
    
    private func setLayout() {
        memberFilterButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(13.5)
        }
        
        sortButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(13.5)
        }
    }
    
    // MARK: - Methods
    
    private func addTarget() {
        memberFilterButton.addTarget(self, action: #selector(leftFilterButtonTapped), for: .touchUpInside)
        sortButton.addTarget(self, action: #selector(rightFilterButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Action
    
    @objc private func leftFilterButtonTapped() {
        memberFilterButton.isSelected.toggle()
        delegate?.memberFilterButtonDidTap()
    }
    
    @objc private func rightFilterButtonTapped() {
        sortButton.isSelected.toggle()
        delegate?.sortButtonDidTap()
    }
}

// MARK: - Extension

extension PotListHeaderCell {
    func configure(memberFilterText: String, sortText: String) {
        memberFilterButton.setTitle(memberFilterText, for: .normal)
        sortButton.setTitle(sortText, for: .normal)
    }
    
    func setButtonSelectionState(isMemberFilter: Bool, isSelected: Bool) {
        let targetButton = isMemberFilter ? memberFilterButton : sortButton
        targetButton.isSelected = isSelected
    }
    
    func setSortButtonTitle(_ title: String) {
        sortButton.setTitle(title, for: .normal)
    }
}
