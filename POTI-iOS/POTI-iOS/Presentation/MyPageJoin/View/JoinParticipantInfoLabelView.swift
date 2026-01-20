//
//  JoinParticipantInfoLabelView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class JoinParticipantInfoLabelView: BaseView {
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    
    // MARK: - Custom Method
    
    override func setStyle() {
        titleLabel.do {
            $0.textColor = .potiBlack
            $0.font = PotiFontManager.body14sb.font
        }
        
        infoLabel.do {
            $0.textColor = .potiBlack
            $0.font = PotiFontManager.body14m.font
            $0.numberOfLines = 0
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            infoLabel
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(titleLabel)
            $0.bottom.equalToSuperview()
        }
    }
    
    // TODO: - Participant~Case에서 configure(model: ParticipantManageModel) 로 받아서 아래처럼 처리

//    func configure(title: String, info: String) {
//        titleLabel.text = title
//        infoLabel.text = info
//    }
    
    func configure(title: String, infos: [String]) {
        titleLabel.setLabel(title, font: .body14sb)

        let text = infos
            .filter { !$0.isEmpty }
            .joined(separator: "\n")

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6   // 디쟌쌤들께 물어보기 TODO!!

        let attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: PotiFontManager.body14m.font,
                .foregroundColor: UIColor.potiBlack,
                .paragraphStyle: paragraphStyle
            ]
        )

        infoLabel.attributedText = attributedText
    }
}
