//
//  JoinProgressStatusViewCell.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class JoinProgressStatusViewCell: UITableViewCell {
    static let identifier = "JoinProgressStatusViewCell"
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .potiWhite
        selectionStyle = .none
        
        setUI()
        setStyle()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        potStatusMessageView.configure(text: "")
        progressStatusBar.image = nil
    }

    // MARK: - UI Component
    
    private let progressTitleLabel = UILabel()
    private let potStatusMessageView = StatusMessageView()
    private let progressStatusBar = UIImageView()
    private let divideView = UIView()

    // MARK: - Custom Method
    
    private func setStyle() {
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
    
    private func setUI() {
        contentView.addSubviews(
            progressTitleLabel,
            potStatusMessageView,
            progressStatusBar,
            divideView
        )
    }
    
    private func setLayout() {
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
    
    func configure(model: ProgressStatusModel) {
        
        let messageText = model.status.statusText(role: model.role)
        potStatusMessageView.configure(text: messageText)
        
        progressStatusBar.image = model.status.progressImage
    }
}
