//
//  NotificationView.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

import UIKit

import SnapKit
import Then

final class NotificationView: BaseView {

    // MARK: - Properties

    let notificationTableView = UITableView(frame: .zero, style: .plain)
    let readAllButton = UIButton()
    private let emptyLabel = UILabel()
    private let topGrayLineView = UIView()

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .potiWhite

        notificationTableView.do {
            $0.backgroundColor = .potiWhite
            $0.separatorStyle = .none
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 82
            $0.showsVerticalScrollIndicator = false
            $0.register(NotificationCell.self)
        }

        readAllButton.do {
            $0.setTitle("전체 읽음", for: .normal)
            $0.setTitleColor(.potiWhite, for: .normal)
            $0.titleLabel?.font = PotiFontManager.button16sb.font
            $0.backgroundColor = .potiBlack
            $0.layer.cornerRadius = 26
            $0.clipsToBounds = true
            $0.isHidden = true
        }

        emptyLabel.do {
            $0.numberOfLines = 0
            $0.setLabel("새로운 알림이 없어요\n알림이 도착하면 알려드릴게요", font: .body14m, alignment: .center, color: .gray700)
            $0.isHidden = true
        }

        topGrayLineView.do {
            $0.backgroundColor = .gray300
        }
    }

    override func setUI() {
        addSubviews(notificationTableView, topGrayLineView, emptyLabel, readAllButton)
    }

    override func setLayout() {
        notificationTableView.snp.makeConstraints {
            $0.top.equalTo(topGrayLineView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }

        topGrayLineView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }

        readAllButton.snp.makeConstraints {
            $0.width.equalTo(readAllButton.intrinsicContentSize.width + 43)
            $0.height.equalTo(52)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
            $0.centerX.equalToSuperview()
        }

        emptyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(64)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods

    func updateEmptyState(isEmpty: Bool) {
        notificationTableView.isHidden = isEmpty
        topGrayLineView.isHidden = isEmpty
        emptyLabel.isHidden = !isEmpty
    }

    func updateReadAllButton(isEnabled: Bool) {
        readAllButton.isHidden = !isEnabled
    }
}
