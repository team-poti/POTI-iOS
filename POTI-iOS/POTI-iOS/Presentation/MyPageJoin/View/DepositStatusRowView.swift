//
//  DepositStatusRowView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

/// 복사 아래 밑줄!!!!!!!!!!!!!!!!!
import UIKit

import SnapKit
import Then

final class DepositStatusRowView: BaseView {
    
    // MARK: - UI
    
    private let depositStatusLabel = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setStyle() {
        depositStatusLabel.do {
            $0.font = PotiFontManager.body16sb.font
        }
    }
    
    // MARK: - Layout
    
    override func setLayout() {
        
        depositStatusLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(model: DepositInfoViewData) {
        depositStatusLabel.text = model.statusText
        depositStatusLabel.textColor = model.statusColor
    }
}


#Preview {
    let view = DepositStatusRowView()
    
    let mock = DepositInfoViewData(
        accountText: "카카오뱅크 3333-19-1234123",
        deadlineText: "2026-01-01 23:59 까지",
        statusText: "입금 대기",
        statusColor: .sementicRed //0119 !!!!! TODO : - 모델 연결하기
    )
    
    view.configure(model: mock)
    return view
}
