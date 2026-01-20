//
//  DivideView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/16/26.
//

import UIKit

import SnapKit
import Then

final class DivideView: BaseView {
    
    private let divideView = UIView()
    
    override func setStyle() {
        divideView.do {
            $0.backgroundColor = .gray300
        }
    }
    
    override func setUI() {
        self.addSubview(divideView)
    }
    
    override func setLayout() {
        divideView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
