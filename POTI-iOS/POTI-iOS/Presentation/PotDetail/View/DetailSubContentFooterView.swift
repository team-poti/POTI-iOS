//
//  DetailSubContentFooterView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

import UIKit

final class DetailSubContentFooterView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let grayLineView = UIView()
    private let subContentLabel = UILabel()
    
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
        
        subContentLabel.do {
            $0.text = "구매자한테 안내해야 되는 내용...어쩌꾸 저쩌꾸 어ㅓ어아어ㅏㅓㅏㅏㅏㅇ우우우우우"
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
            $0.numberOfLines = 0
        }
    }
    
    private func setUI() {
        addSubviews(grayLineView, subContentLabel)
    }
    
    private func setLayout() {
        grayLineView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(-16)
            $0.height.equalTo(8)
        }
        
        subContentLabel.snp.makeConstraints {
            $0.top.equalTo(grayLineView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(56)
        }
    }
}
