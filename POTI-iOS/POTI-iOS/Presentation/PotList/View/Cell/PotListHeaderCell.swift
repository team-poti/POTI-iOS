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
    func rightFilterButtonDidTap()
    func leftFilterButtonDidTap()
}

final class PotListHeaderCell: UICollectionReusableView {

    // MARK: - Property

    weak var delegate: PotListHeaderCellDelegate?

    // MARK: - UI Components

    private let leftFilterButton = UIButton()
    private let rightFilterButton = UIButton()

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
        leftFilterButton.do {

            // TODO: - 멤버선택 바텀시트 추가 후 변경 텍스트로 변경하기

            $0.setTitle("멤버 선택", for: .normal)
            $0.setTitleColor(.potiBlack, for: .normal)
            $0.titleLabel?.font = PotiFontManager.body14m.font
            $0.setImage(.icnArrowDownSm, for: .normal)
            $0.setImage(.icnArrowUpSm, for: .selected)
            $0.semanticContentAttribute = .forceRightToLeft
        }
        
        rightFilterButton.do {
            $0.setTitleColor(.potiBlack, for: .normal)
            $0.titleLabel?.font = PotiFontManager.body14m.font
            $0.setImage(.icnArrowDownSm, for: .normal)
            $0.setImage(.icnArrowUpSm, for: .selected)
            $0.semanticContentAttribute = .forceRightToLeft
        }
    }

    private func setUI() {
        addSubviews(leftFilterButton, rightFilterButton)
    }

    private func setLayout() {
        leftFilterButton.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        rightFilterButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview()
        }
    }

    // MARK: - Private Method

    private func addTarget() {
        leftFilterButton.addTarget(self, action: #selector(leftFilterButtonTapped), for: .touchUpInside)
        
        rightFilterButton.addTarget(self, action: #selector(rightFilterButtonTapped), for: .touchUpInside)
    }

    //MARK: - Action
    
    @objc private func leftFilterButtonTapped() {
        leftFilterButton.isSelected.toggle()
        delegate?.leftFilterButtonDidTap()
    }

    @objc private func rightFilterButtonTapped() {
        rightFilterButton.isSelected.toggle()
        delegate?.rightFilterButtonDidTap()
    }
}

// MARK: - Extension

extension PotListHeaderCell {
    func configure(leftText: String, rightText: String) {
        leftFilterButton.setTitle(leftText, for: .normal)
        rightFilterButton.setTitle(rightText, for: .normal)
    }

    func setFilterButtonState(isLeft: Bool, isSelected: Bool) {
        if isLeft {
            leftFilterButton.isSelected = isSelected
        } else {
            rightFilterButton.isSelected = isSelected
        }
    }
}
