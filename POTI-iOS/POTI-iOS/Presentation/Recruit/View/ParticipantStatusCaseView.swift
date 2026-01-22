//
//  ParticipantStatusCaseView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class ParticipantStatusCaseView: BaseView {
    
    private let containerStackView = UIStackView()
    private let infoLabelStackView = InfoLabelStackView()
    private let actionButton = UIButton()
    
    private var onTapAction : (() -> Void)?
    
    // MARK: - Custom Method
    
    override func setStyle() {
        
        containerStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        actionButton.do {
            $0.setTitleColor(.potiWhite, for: .normal)
            $0.backgroundColor = .potiBlack
            $0.layer.cornerRadius = 12
            $0.titleLabel?.font = PotiFontManager.body16sb.font
            $0.isHidden = true
        }
    }
    
    override func setUI() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubviews(infoLabelStackView, actionButton)
        containerStackView.setCustomSpacing(32, after: infoLabelStackView)
        addTarget()
    }
    
    override func setLayout() {
        containerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
    
    private func addTarget() {
        actionButton.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
    }
    
    //MARK: - Action
    
    //TODO: - Input output
    @objc
    private func actionButtonDidTap() {
        onTapAction?()
    }
}

extension ParticipantStatusCaseView {
    
    func reset() {
        infoLabelStackView.reset()
        actionButton.isHidden = true
        actionButton.setTitle("", for: .normal)
        onTapAction = nil
    }
    
    func configure(
        status: ParticipantStatus,
        model: ParticipantManageModel,
        onTapAction: (() -> Void)? = nil
    ) {
        reset()
        
        var items: [(title: String, infos: [String])] = []
        
        var buttonTitle: String = ""
        
        switch status {
        case .waitPay, .waitPayCheck:
            self.isHidden = true
            return
            
        case .paid:
            self.isHidden = false
            items = [
                (title: "입금 정보",
                 infos: [
                    model.paidInfo?.depositorName ?? "",
                    model.paidInfo?.depositTimeText ?? ""
                 ])
            ]
            buttonTitle = "입금 확인"
            
        case .ready:
            self.isHidden = false
            items = [
                (title: "이름", infos: [model.paidInfo?.depositorName ?? ""]),
                (title: "배송 정보", infos: [model.shipInfo?.addressText ?? ""]),
                (title: "연락처", infos: [model.shipInfo?.phoneText ?? ""])
            ]
            buttonTitle = "송장 번호 입력"
            
        case .shipped:
            self.isHidden = false
            items = [
                (title: "이름", infos: [model.shipInfo?.receiverName ?? ""]),
                (title: "배송 정보", infos: [model.shipInfo?.addressText ?? ""]),
                (title: "연락처", infos: [model.shipInfo?.phoneText ?? ""]),
                (title: "송장 번호", infos: [model.shipInfo?.trackingNumber ?? ""])
            ]
            
        case .delivered:
            self.isHidden = false
            items = [
                (title: "송장 번호", infos: [model.shipInfo?.trackingNumber ?? ""])
            ]
        }
        
        infoLabelStackView.configure(items: items)
        
        if !buttonTitle.isEmpty {
            actionButton.isHidden = false
            actionButton.setTitle(buttonTitle, for: .normal)
            self.onTapAction = onTapAction
        } else {
            actionButton.isHidden = true
        }
    }
}
