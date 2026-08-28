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

    // MARK: - UI Components

    let notificationTableView = UITableView(frame: .zero, style: .plain)
    let readAllButton = PotiBottomButton()
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
            $0.text = "전체 읽음"
            $0.color = .secondaryMain
            $0.cornerRadius = 8
        }

        emptyLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray700
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.setText("새로운 알림이 없어요\n알림이 도착하면 알려드릴게요", lineSpacing: 4, alignment: .center)
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
            $0.bottom.equalTo(readAllButton.snp.top).offset(-16)
        }

        topGrayLineView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }

        readAllButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
        }

        emptyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(64)
            $0.centerX.equalToSuperview()
        }
    }

    // MARK: - Public Methods

    func updateReadAllButton(isEnabled: Bool) {
        readAllButton.isDisabled = !isEnabled
        readAllButton.color = isEnabled ? .secondaryMain : .deactivedSub
    }

    func updateEmptyState(isEmpty: Bool) {
        notificationTableView.isHidden = isEmpty
        topGrayLineView.isHidden = isEmpty
        emptyLabel.isHidden = !isEmpty
    }
}
