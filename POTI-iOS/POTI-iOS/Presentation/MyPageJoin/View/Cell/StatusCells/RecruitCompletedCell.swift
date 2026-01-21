//
//  RecruitCompletedCell.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

import UIKit

import SnapKit

final class RecruitCompletedCell: UITableViewCell {
    
    private let depositInfoView = DepositInfoView()
    private let joinShipInfoView = JoinShipInfoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setStyle()
        setUI()
        setLayout()
        self.backgroundColor = .potiWhite
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setStyle() {
        backgroundColor = .potiWhite
    }
    
    private func setUI() {
        selectionStyle = .none
        contentView.addSubviews(
            depositInfoView,
            joinShipInfoView
        )
    }
    
    private func setLayout() {
        depositInfoView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        joinShipInfoView.snp.makeConstraints {
            $0.top.equalTo(depositInfoView.snp.bottom)
            $0.horizontalEdges.equalTo(depositInfoView)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(model: MyPageJoinModel) {
        depositInfoView.configure(model: model)
        joinShipInfoView.configure(model: model)
    }
}
