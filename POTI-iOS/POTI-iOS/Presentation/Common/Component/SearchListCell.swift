//
//  SearchListCell.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class SearchListCell: UITableViewCell {

    // MARK: - Property

    static let identifier = "SearchListCell"

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .potiBlack
            $0.numberOfLines = 1
        }
        return label
    }()

    // MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setStyle()
        setUI()
        setLayout()
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Method

    func configure(text: String) {
        titleLabel.text = text
    }

    // MARK: - delegate Method

    private func setStyle() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear
    }

    private func setUI() {
        contentView.addSubview(titleLabel)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
