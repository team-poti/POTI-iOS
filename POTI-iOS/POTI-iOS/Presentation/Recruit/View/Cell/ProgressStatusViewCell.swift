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
    
    private let mockProgressStatusModel: ProgressStatusModel = ProgressStatusModel(
        potId: 1110,
        role: .host,
        status: .recruiting
    )
    
    static let identifier = "ProgressViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .potiWhite
        
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
    private let divideView = UIView()

    func setStyle() {
        progressTitleLabel.do {
            $0.setLabel("진행 상황", font: .body16sb)
            $0.textColor = .potiBlack
        }
        
        progressStatusBar.do {
            $0.backgroundColor = .potiWhite
            $0.contentMode = .scaleAspectFit
        }
        
        divideView.do {
            $0.backgroundColor = .gray100
        }
    }
    
    func setUI() {
        contentView.addSubviews(
            progressTitleLabel,
            potStatusMessageView,
            progressStatusBar,
            divideView
        )
    }
    
    func setLayout() {
        progressTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(16)
        }
        potStatusMessageView.snp.makeConstraints {
            $0.top.equalTo(progressTitleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(CGFloat.dynamicH(45))
        }
        progressStatusBar.snp.makeConstraints {
            $0.top.equalTo(potStatusMessageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(CGFloat.dynamicH(53))
        }
        divideView.snp.makeConstraints {
            $0.top.equalTo(progressStatusBar.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(CGFloat.dynamicH(8))
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
    
    func configure(model: ProgressStatusModel) {
        
        let messageText = model.status.statusText(role: model.role)
        potStatusMessageView.configure(text: messageText)
        
        progressStatusBar.image = model.status.progressImage
    }
}
