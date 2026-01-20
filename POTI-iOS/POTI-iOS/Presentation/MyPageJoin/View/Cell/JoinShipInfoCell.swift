//
//  JoinShipInfoCell.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

import UIKit
import SnapKit

final class JoinShipInfoCell: UITableViewCell {

    static let identifier = "JoinShipInfoCell"

    private let joinShipInfoView = JoinShipInfoView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        selectionStyle = .none
        contentView.addSubview(joinShipInfoView)
    }

    private func setLayout() {
        joinShipInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configure(model: MyPageJoinModel) {
        joinShipInfoView.configure(model: model)
    }
}
