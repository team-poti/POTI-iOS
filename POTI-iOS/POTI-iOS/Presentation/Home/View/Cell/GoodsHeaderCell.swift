//
//  GoodsHeaderCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import UIKit

import Combine
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
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
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
            $0.trailing.top.equalToSuperview()
        }
    }
    
    // MARK: - Private Method
    
    private func addTarget() {
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
    
    @objc private func moreButtonTapped() {
        delegate?.moreButtonDidTap(in: sectionIndex)
    }
}

// MARK: - Extension

extension GoodsHeaderCell {
    func configure(text: String?, section: Int) {
        titleLabel.text = text
        self.sectionIndex = section
    }
}
