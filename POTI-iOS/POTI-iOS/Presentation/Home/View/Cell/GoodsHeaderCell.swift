//
//  GoodsHeaderCell.swift
//  POTI-iOS
//
//  Created by soomin on 1/14/26.
//

import UIKit

import SnapKit
import Then

protocol GoodsHeaderCellDelegate: AnyObject {
    func moreButtonDidTap(in section: Int)
}

final class GoodsHeaderCell: UICollectionReusableView {
    
    // MARK: - Properties
    
    weak var delegate: GoodsHeaderCellDelegate?
    private var sectionIndex: Int = 0
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let moreButton = UIButton()
    
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
        titleLabel.do {
            $0.setLabel("", font: .body16sb, color: .potiBlack)
        }
        
        moreButton.do {
            $0.titleLabel?.font = PotiFontManager.body14m.font
            $0.setTitle("더보기", for: .normal)
            $0.setTitleColor(.gray800, for: .normal)
        }
    }
    
    private func setUI() {
        addSubviews(titleLabel, moreButton)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
        }
    }
    
    private func addTarget() {
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Action
    
    @objc private func moreButtonTapped() {
        delegate?.moreButtonDidTap(in: sectionIndex)
    }
}

// MARK: - Configure

extension GoodsHeaderCell {
    func configure(text: String, section: Int) {
        titleLabel.setLabel(text, font: .body16sb, color: .potiBlack)
        self.sectionIndex = section
    }
}
