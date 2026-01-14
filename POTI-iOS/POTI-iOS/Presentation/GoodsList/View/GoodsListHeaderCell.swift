//
//  GoodsListHeaderCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import UIKit

import SnapKit
import Then

protocol GoodsListHeaderCellDelegate: AnyObject {
    func filterButtonDidTap()
}

final class GoodsListHeaderCell: UICollectionReusableView {
    
    // MARK: - Property
    
    weak var delegate: GoodsListHeaderCellDelegate?
    
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
        filterButton.do {
            
            // TODO: - 정렬 바텀시트 추가 후 변경 텍스트로 변경하기
            
            $0.setTitle("인기순", for: .normal)
            $0.setTitleColor(.potiBlack, for: .normal)
            $0.titleLabel?.font = PotiFontManager.body14m.font
            $0.setImage(.icnArrowDownSm, for: .normal)
            $0.setImage(.icnArrowUpSm, for: .selected)
            $0.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    private func setUI() {
        addSubviews(filterButton)
    }
    
    private func setLayout() {
        filterButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview()
        }
    }
    
    // MARK: - Private Method
    
    private func addTarget() {
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Action
    
    @objc private func filterButtonTapped() {
        filterButton.isSelected.toggle()
        delegate?.filterButtonDidTap()
    }
}

// MARK: - Extension

extension GoodsListHeaderCell {
    func configure() {
        
        // TODO: - 정렬 바텀시트랑 연결하기
        
    }
}

