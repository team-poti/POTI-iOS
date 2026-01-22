//
//  DetailSubContentFooterView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class DetailSubContentFooterView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let grayLineView = UIView()
    private let noticeView = joinNoticeView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        grayLineView.do {
            $0.backgroundColor = .gray100
        }
    }
    
    private func setUI() {
        addSubviews(grayLineView, noticeView)
    }
    
    private func setLayout() {
        grayLineView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(-16)
            $0.height.equalTo(8)
        }
        
        noticeView.snp.makeConstraints {
            $0.top.equalTo(grayLineView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(60)
        }
    }
}
