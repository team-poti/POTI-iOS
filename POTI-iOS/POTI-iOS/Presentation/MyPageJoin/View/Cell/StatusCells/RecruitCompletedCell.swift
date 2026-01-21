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
    private let completeButton = PotiBottomButton()
    
    var onTapConfirmButton: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setStyle()
        setUI()
        setLayout()
        addTarget()
        self.backgroundColor = .potiWhite
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onTapConfirmButton = nil
    }
    
    private func setStyle() {
        backgroundColor = .potiWhite
        completeButton.do {
            $0.color = .primaryMain
            $0.isDisabled = false
            $0.text = "확인"
        }
    }
    
    private func setUI() {
        selectionStyle = .none
        contentView.addSubviews(
            depositInfoView,
            joinShipInfoView,
            completeButton
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
        }
        completeButton.snp.makeConstraints {
            $0.top.equalTo(joinShipInfoView.snp.bottom).offset(77)
            $0.horizontalEdges.equalTo(depositInfoView).inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func addTarget() {
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }

    @objc private func completeButtonTapped() {
        //viewModel.action(.tapDepositComplete)
    }
    
    func configure(model: MyPageJoinModel) {
        depositInfoView.configure(model: model)
        joinShipInfoView.configure(model: model)
        
        completeButton.color = .primaryMain
        completeButton.text = "입금 완료했어요"
        completeButton.isDisabled = false
    }
}
