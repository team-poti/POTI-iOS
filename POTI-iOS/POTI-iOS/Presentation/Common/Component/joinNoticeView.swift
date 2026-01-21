//
//  joinNoticeView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import UIKit

import SnapKit
import Then

final class joinNoticeView: BaseView {
    
    // MARK: - UI Components
    
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let firstNoticeLabel = UILabel()
    private let secondNoticeLabel = UILabel()
    private let thirdNoticeLabel = UILabel()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        [titleLabel, firstNoticeLabel, secondNoticeLabel, thirdNoticeLabel].forEach {
            $0.do {
                $0.font = PotiFontManager.caption12m.font
                $0.textColor = .gray700
                $0.numberOfLines = 0
            }
        }
        
        titleLabel.text = "참여자 안내 사항"
        
        setLineHeight(label: firstNoticeLabel,
                      text: "모집 완료 후 24시간 이내 입금이 확인되지 않을 경우, 참여는 자동으로 취소되며 이후 서비스 이용에 불이익이 있을 수 있습니다.")
        
        setLineHeight(label: secondNoticeLabel,
                      text: "입금 후, 모집자가 굿즈를 주문하고 수령하는 과정이 필요하여 배송 시작 상태로 전환되기까지 다소 시간이 소요될 수 있습니다.")
        
        setLineHeight(label: thirdNoticeLabel,
                      text: "마감 기한까지 모집 인원이 과반수 이상 충족되지 않을 경우, 해당 분철팟은 자동으로 종료되며 분철은 진행되지 않습니다.")
    }
    
    override func setUI() {
        addSubview(stackView)
        stackView.addArrangedSubviews(
            titleLabel,
            firstNoticeLabel,
            secondNoticeLabel,
            thirdNoticeLabel
        )
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Private Methods
    
    private func setLineHeight(label: UILabel, text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle
            ]
        )
        
        label.attributedText = attributedString
    }
    
}

