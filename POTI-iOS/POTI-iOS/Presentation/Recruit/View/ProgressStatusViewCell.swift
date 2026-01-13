//
//  ProgressStatusViewCell.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class ProgressStatusViewCell: UITableViewCell {
    
    private let mockProgressStatusModel: ProgressStatusModel = ProgressStatusModel(potId: 1110, role: .host, status: .depositCompleted)
    
    static let identifier = "ProgressViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setStyle()
        setLayout()
        configure(model: mockProgressStatusModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Component
    
    private let progressTitleLabel = UILabel()
    private let potStatusMessageView = StatusMessageView()
    private let progressStatusBar = UIImageView()

    /// UI 컴포넌트 속성 설정 (do 메서드)
    func setStyle() {
        
        progressTitleLabel.do {
            $0.setLabel("진행 상황", font: .body16sb)
            $0.textColor = .potiBlack
        }
        
        progressStatusBar.do {
            $0.backgroundColor = .potiWhite
        }
    }
    
    /// UI 위계 설정 (addSubview)
    func setUI() {
        contentView.addSubviews(
            progressTitleLabel,
            potStatusMessageView,
            progressStatusBar
        )
    }
    
    /// 오토레이아웃 설정
    func setLayout() {
        progressTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(16)
        }
        potStatusMessageView.snp.makeConstraints {
            $0.top.equalTo(progressTitleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        // TODO: - 여기도 나연언니 dynamicH 써야지
        progressStatusBar.snp.makeConstraints {
            $0.top.equalTo(potStatusMessageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(24) //$0.height.equalTo(48.dynamicH)
        }
    }
    
    // MARK: - Custom Method
    
    func configure(model: ProgressStatusModel) {
        
        let messageText = model.status.statusText(role: model.role)
        potStatusMessageView.configure(text: messageText)
        
        progressStatusBar.image = model.status.progressImage
    }
}
