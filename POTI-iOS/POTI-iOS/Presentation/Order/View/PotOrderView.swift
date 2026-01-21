//
//  PotOrderView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import UIKit

import SnapKit
import Then

final class PotOrderView: BaseView {
    
    // MARK: - UI Components
    
    let headerView = OrderHeaderView()
    let orderContentView = PotOrderContentView()
    let bottomButton = PotiBottomButton()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dividerUpperView = UIView()
    private let dividerBottomView = UIView()
    private let noticeView = joinNoticeView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .potiWhite
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        bottomButton.do {
            $0.color = .primaryMain
            $0.isDisabled = true
            $0.text = "참여하기"
        }
        
        dividerUpperView.do {
            $0.backgroundColor = .gray100
        }
        
        dividerBottomView.do {
            $0.backgroundColor = .gray100
        }
    }
    
    override func setUI() {
        addSubviews(scrollView, bottomButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(headerView, dividerUpperView, orderContentView, dividerBottomView, noticeView)
    }
    
    override func setLayout() {
        bottomButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(55)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomButton.snp.top).offset(-4)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        dividerUpperView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        orderContentView.snp.makeConstraints {
            $0.top.equalTo(dividerUpperView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        dividerBottomView.snp.makeConstraints {
            $0.top.equalTo(orderContentView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        noticeView.snp.makeConstraints {
            $0.top.equalTo(dividerBottomView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(60)
        }
    }
}
