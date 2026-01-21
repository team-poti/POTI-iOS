//
//  ParticipantManageHeaderView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class ParticipantManageHeaderView: BaseView {
    
    //MARK: - UI component
    
    private let titleLabel = UILabel()
    private let participantHeaderButton = UIButton()
    
    var onTapHeaderButton: (() -> Void)?
    
    //MARK: - Custom Method
    
    override func setStyle() {
        backgroundColor = .potiWhite
        titleLabel.do {
            $0.textColor = .potiBlack
            $0.textAlignment = .center
            $0.font = PotiFontManager.body16sb.font
        }
        participantHeaderButton.do {
            $0.setImage(UIImage(resource: .icnArrowRightLg).withTintColor(.gray800), for: .normal)
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            participantHeaderButton
        )
        addTarget()
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(16)
        }
        participantHeaderButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
    }
    
    func configure(count: Int) {
        titleLabel.text = "참여자 관리 (" + "\(count))"
    }
    
    private func addTarget() {
        participantHeaderButton.addTarget(self, action: #selector(headerButtonTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: - action
    
    @objc func headerButtonTapped(_ sender: Any) {
        print("headerButtonTapped")
        onTapHeaderButton?()
        //TODO: - input .. action 추후 수정
        // input.send(.potButtonTapped)
    }
}
