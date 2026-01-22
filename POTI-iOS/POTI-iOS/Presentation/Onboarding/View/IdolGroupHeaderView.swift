//
//  IdolGroupHeaderView.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class IdolGroupHeaderView: UICollectionReusableView {
    
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        descriptionLabel.do {
            $0.textColor = .potiBlack
            $0.font = PotiFontManager.title18sb.font
        }
    }
    
    func configure(nickname: String) {
        descriptionLabel.text = "\(nickname)님의 최애 그룹 한 팀을 선택해주세요"
    }
    
    private func setUI() {
        addSubview(descriptionLabel)
    }
    
    private func setLayout() {
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().inset(35)
        }
    }
}
