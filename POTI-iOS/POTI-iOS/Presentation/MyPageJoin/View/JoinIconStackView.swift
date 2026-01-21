//
//  JoinIconStackView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class JoinIconStackView: BaseView {
    
    private let iconName: String
    private let title: String
    
    init(iconName: String, title: String) {
        self.iconName = iconName
        self.title = title
        super.init(frame: .zero)
        configure(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private let iconStackView = UIStackView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override func setStyle() {
        iconStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 2
        }
        iconImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .gray800
        }
        titleLabel.do {
            $0.textColor = .gray800
            $0.font = PotiFontManager.body14m.font
        }
    }
    
    override func setUI() {
        addSubview(iconStackView)
        iconStackView.addArrangedSubviews(
            iconImageView,
            titleLabel
        )
    }
    
    override func setLayout() {
        
        iconStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(21)
        }
    }
}

extension JoinIconStackView {
    func configure(title: String) {
        titleLabel.text = title
    }
}
