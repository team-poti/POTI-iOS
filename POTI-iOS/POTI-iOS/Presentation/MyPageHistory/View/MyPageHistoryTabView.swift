//
//  MyPageHistoryTabView.swift
//  POTI-iOS
//
//  Created by neon on 1/20/26.
//

import UIKit

import SnapKit
import Then

final class MyPageHistoryTabView: BaseView {
    
    // MARK: - UI Components
    
    let ongoingTabButton = UIButton()
    let completedTabButton = UIButton()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        
        configureButton(
            ongoingTabButton,
            title: "진행중 0",
            tag: 0,
            selected: true
        )
        
        configureButton(
            completedTabButton,
            title: "종료 0",
            tag: 1,
            selected: false
        )
    }
    
    override func setUI() {
        backgroundColor = .potiWhite
        addSubviews(ongoingTabButton, completedTabButton)
    }
    
    override func setLayout() {
        
        ongoingTabButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(CGFloat.dynamicH(36))
        }
        
        completedTabButton.snp.makeConstraints {
            $0.leading.equalTo(ongoingTabButton.snp.trailing).offset(8)
            $0.height.equalTo(CGFloat.dynamicH(36))
        }
    }
}

extension MyPageHistoryTabView {
    private func configureButton(
        _ button: UIButton,
        title: String,
        tag: Int,
        selected: Bool
    ) {
        button.tag = tag
        button.layer.cornerRadius = CGFloat.dynamicH(18)
        button.clipsToBounds = true
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)

        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 7.5,
            leading: 12,
            bottom: 7.5,
            trailing: 12
        )
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = PotiFontManager.body14sb.font
            return attributes
        }
        button.configuration = configuration
        
        update(button, selected: selected)
    }
    
    private func update(_ button: UIButton, selected: Bool) {
        var configuration = button.configuration

        if selected {
            configuration?.baseForegroundColor = .potiWhite
            configuration?.background.backgroundColor = .gray900
        } else {
            configuration?.baseForegroundColor = .gray900
            configuration?.background.backgroundColor = .gray100
        }

        button.configuration = configuration
    }

    // MARK: - Public Methods

    func updateTabSelection(tab: MyPageHistoryViewController.HistoryTab) {
        update(ongoingTabButton, selected: tab == .ongoing)
        update(completedTabButton, selected: tab == .completed)
    }

    func updateCount(for tab: MyPageHistoryViewController.HistoryTab, count: Int) {
        let button = tab == .ongoing ? ongoingTabButton : completedTabButton
        let title = tab == .ongoing ? "진행중" : "종료"
        button.configuration?.title = "\(title) \(count)"
    }
}
