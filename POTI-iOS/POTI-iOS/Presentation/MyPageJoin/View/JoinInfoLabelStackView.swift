//
//  JoinInfoLabelStackView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

//TODO!!!!! HOT!!!!!!!!!! 비상!!!!

import UIKit

import SnapKit
import Then

final class JoinInfoLabelStackView: BaseView {
    
    private let infoStackView = UIStackView()
    
    // MARK: - Custom Method
    
    override func setStyle() {
        infoStackView.do {
            $0.axis = .vertical
            $0.spacing = 24
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }
    
    override func setUI() {
        self.addSubview(infoStackView)
    }
    
    override func setLayout() {
        infoStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension JoinInfoLabelStackView {
    func reset() {
        infoStackView.arrangedSubviews.forEach {
            infoStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    func configure(items: [(title: String, infos: [String])]) {
        reset()
        items.forEach { item in
            let view = ParticipantInfoLabelView()
            view.configure(title: item.title, infos: item.infos)
            infoStackView.addArrangedSubview(view)
        }
    }
}
