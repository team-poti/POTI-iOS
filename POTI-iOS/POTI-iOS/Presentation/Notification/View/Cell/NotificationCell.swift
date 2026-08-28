//
//  NotificationCell.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

import UIKit

import SnapKit
import Then

final class NotificationCell: UITableViewCell {

    // MARK: - UI Components

    private let shippingStatusLabel = UILabel()
    private let contentLabel = UILabel()
    private let timeLabel = UILabel()
    private let grayLineView = UIView()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        shippingStatusLabel.text = nil
        contentLabel.text = nil
        timeLabel.text = nil
        contentView.backgroundColor = .potiWhite
    }

    // MARK: - Private Methods

    private func setStyle() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .potiWhite

        shippingStatusLabel.do {
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
        }

        contentLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }

        timeLabel.do {
            $0.font = PotiFontManager.caption12m.font
            $0.textColor = .gray700
        }

        grayLineView.do {
            $0.backgroundColor = .gray300
        }
    }

    private func setUI() {
        contentView.addSubviews(shippingStatusLabel, contentLabel, timeLabel, grayLineView)
    }

    private func setLayout() {
        shippingStatusLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualTo(timeLabel.snp.leading).offset(-8)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(shippingStatusLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        timeLabel.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(16)
        }

        grayLineView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    // MARK: - Public Method

    func configure(title: String, content: String, time: String, isRead: Bool) {
        shippingStatusLabel.text = title
        contentLabel.setText(content, lineSpacing: 4, alignment: .left)
        timeLabel.text = time
        contentView.backgroundColor = isRead ? .potiWhite : .gray100
    }
}
