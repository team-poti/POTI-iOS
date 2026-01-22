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
    
    struct Model {
        let postStatus: PostStatus
        let role: UserRole
        let participantStatus: ParticipantOrderStatus
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .potiWhite
        
        setUI()
        setStyle()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Component
    
    private let progressTitleLabel = UILabel()
    private let potStatusMessageView = StatusMessageView()
    private let progressStatusBar = UIImageView()
    private let divideView = UIView()

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
    
    // MARK: - Custom Method
    
    func configure(model: Model) {
        let messageText: String

        if model.postStatus == .closed {
            switch (model.role, model.participantStatus) {
            case (.host, .waitPay):
                messageText = "입금을 기다리는 중이에요"

            case (.host, .waitPayCheck):
                messageText = "입금 확인을 기다리는 참여자가 있어요"

            case (.participant, .waitPay):
                messageText = "지금 입금해주세요!"

            case (.participant, .waitPayCheck):
                messageText = "모집자가 입금 내역을 확인하고 있어요"

            default:
                // closed 상태지만 위 케이스에 해당 안 할 때
                if model.role == .host {
                    messageText = model.postStatus.statusText(role: model.role)
                } else {
                    messageText = model.participantStatus.statusText(role: model.role)
                }
            }
        } else {
            // closed가 아닐 때
            if model.role == .host {
                messageText = model.postStatus.statusText(role: model.role)
            } else {
                messageText = model.participantStatus.statusText(role: model.role)
            }
        }

        potStatusMessageView.configure(text: messageText)
        progressStatusBar.image = model.postStatus.progressImage
    }
}
