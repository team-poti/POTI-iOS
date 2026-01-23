//
//  RegisterMemberView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class RegisterMemberView: BaseView {
    
    // MARK: - Properties
    
    var onMembersChanged: (([String]) -> Void)?
    var onTapEditButton: (() -> Void)?
    
    private var currentMembers: [String] = []
    
    private var rowViews: [MemberPriceRowView] = []
    
    private var isEmptyState: Bool = true
    private var isHintVisible: Bool = true
    
    private var hasEverHadMembers: Bool = false
    
    private var rowsTopOffsetConstraint: Constraint?
    private var editTopOffsetConstraint: Constraint?
    private var editTopToEmptyLabelConstraint: Constraint?
    private var editButtonHeightConstraint: Constraint?
    private var bottomBoxHeightConstraint: Constraint?
    private var bottomTopToEditConstraint: Constraint?
    private var bottomTopToEmptyLabelConstraint: Constraint?
    private var hintHeightConstraint: Constraint?
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let rowsStackView = UIStackView()
    private let editButton = UIButton(type: .system)
    private let bottomBoxView = UIView()
    private let emptyStateLabel = UILabel()
    
//    private let hintView = UIView()
//    private let hintBackgroundImageView = UIImageView()
//    private let hintLabel = UILabel()
    
    private let errorLabel = UILabel()
    private let errorStackView = UIStackView()
    private let errorIconView = UIImageView()
    
    // MARK: - Custom Method
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let view = super.hitTest(point, with: event)
//        print("🧪 RegisterMemberView hitTest:", view)
//
//        if let view {
//            print("🧪  - isDescendant(of: rowsStackView)=\(view.isDescendant(of: rowsStackView))")
//            if let tf = view as? UITextField {
//                print("🧪  - UITextField enabled=\(tf.isEnabled) userInteraction=\(tf.isUserInteractionEnabled) firstResponder=\(tf.isFirstResponder)")
//            }
//        }
//        return view
//    }
    
    override func setStyle() {
        backgroundColor = .clear
        
        titleLabel.do {
            $0.text = "멤버 설정"
            $0.font = PotiFontManager.title18sb.font
            $0.textColor = .potiBlack
        }
        
        rowsStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 20
            $0.isHidden = true
        }
        
        editButton.do {
            var config = UIButton.Configuration.filled()
            
            config.title = "멤버 편집"
            config.attributedTitle = AttributedString(
                "멤버 편집",
                attributes: AttributeContainer([
                    .font: PotiFontManager.button14sb.font
                ])
            )
            
            config.baseForegroundColor = .gray300
            config.background.backgroundColor = .potiBlack
            config.background.cornerRadius = 8
            
            if let image = UIImage(named: "icn-edit")
            {
                config.image = image
                config.imagePlacement = .leading
                config.imagePadding = 4
            }
            
            config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
            
            $0.configuration = config
            $0.configurationUpdateHandler = { button in
                guard var updated = button.configuration else { return }
                updated.baseForegroundColor = .gray300
                updated.background.backgroundColor = .potiBlack
                button.configuration = updated
            }
            $0.isHidden = true
        }
        
        bottomBoxView.do {
            $0.backgroundColor = .gray100
            $0.isUserInteractionEnabled = false
        }
        
        emptyStateLabel.do {
            $0.text = "아티스트를 먼저 선택해주세요"
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .gray700
            $0.textAlignment = .center
            $0.numberOfLines = 1
            $0.isHidden = true
        }
        
//        hintView.do {
//            $0.isHidden = true
//            $0.backgroundColor = .clear
//            $0.isUserInteractionEnabled = false
//        }
        
//        hintBackgroundImageView.do {
//            $0.image = UIImage.imgHint
//            $0.isUserInteractionEnabled = false
//        }
        
//        hintLabel.do {
//            $0.text = "모집자 본인이 보유할 멤버는 꼭 제외해주세요!"
//            $0.font = PotiFontManager.body14sb.font
//            $0.textColor = .poti600
//            $0.textAlignment = .center
//            $0.numberOfLines = 1
//            $0.isUserInteractionEnabled = false
//        }
        
        errorStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
            $0.distribution = .fill
            $0.isHidden = true
            $0.isUserInteractionEnabled = false
        }
        
        errorIconView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = UIImage.icnNotice
            $0.tintColor = .sementicRed
            $0.isUserInteractionEnabled = false
        }
        
        errorLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .sementicRed
            $0.numberOfLines = 0
            $0.isUserInteractionEnabled = false
        }
    }
    
    override func setUI() {
        addSubviews(bottomBoxView, titleLabel, errorStackView, rowsStackView, editButton, emptyStateLabel)
//        hintView.addSubviews(hintBackgroundImageView, hintLabel)
        errorStackView.addArrangedSubviews(errorIconView, errorLabel)
        
        bottomBoxView.isUserInteractionEnabled = false
        
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        errorStackView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        errorIconView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        rowsStackView.snp.makeConstraints {
            rowsTopOffsetConstraint = $0.top.equalTo(titleLabel.snp.bottom).offset(24).constraint
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
//        hintView.snp.makeConstraints {
//            $0.bottom.equalTo(editButton.snp.top).offset(-9)
//            $0.horizontalEdges.equalToSuperview().inset(28)
//            hintHeightConstraint = $0.height.equalTo(58).constraint
//        }
//
//        hintBackgroundImageView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//
//        hintLabel.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalTo(hintBackgroundImageView.snp.top).offset(13)
//        }
        
        editButton.snp.makeConstraints {
            editTopOffsetConstraint = $0.top.equalTo(rowsStackView.snp.bottom).offset(24).constraint
            
            editTopToEmptyLabelConstraint = $0.top.equalTo(emptyStateLabel.snp.bottom).offset(76).constraint
            editTopToEmptyLabelConstraint?.deactivate()
            
            $0.horizontalEdges.equalToSuperview().inset(16)
            editButtonHeightConstraint = $0.height.equalTo(56).constraint
        }
        
        bottomBoxView.snp.makeConstraints {
            bottomTopToEditConstraint = $0.top.equalTo(editButton.snp.bottom).offset(24).constraint
            bottomTopToEmptyLabelConstraint = $0.top.equalTo(emptyStateLabel.snp.bottom).offset(76).constraint
            $0.horizontalEdges.equalToSuperview()
            bottomBoxHeightConstraint = $0.height.equalTo(9).constraint
            $0.bottom.equalToSuperview()
        }
        
        emptyStateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(76)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        applyEmptyStateLayout()
    }
    
    private func applyEmptyStateLayout() {
        isEmptyState = true
        emptyStateLabel.isHidden = false
        emptyStateLabel.text = "아티스트를 먼저 선택해주세요"
        errorStackView.isHidden = true
        rowsStackView.isHidden = true
        editButton.isHidden = true
        bottomBoxView.isHidden = false
//        hintView.isHidden = true
        
        rowsTopOffsetConstraint?.update(offset: 0)
        editTopOffsetConstraint?.update(offset: 0)
        hintHeightConstraint?.update(offset: 0)
        
        bottomTopToEditConstraint?.deactivate()
        bottomTopToEmptyLabelConstraint?.activate()
        
        editTopToEmptyLabelConstraint?.deactivate()
        editTopOffsetConstraint?.activate()
        
        editButtonHeightConstraint?.update(offset: 0)
        bottomBoxHeightConstraint?.update(offset: 9)
        
        setNeedsLayout()
    }
    
    private func applyEditedEmptyStateLayout() {
        isEmptyState = true
        
        emptyStateLabel.isHidden = false
        emptyStateLabel.text = "선택한 멤버가 없어요"
        
        rowsStackView.isHidden = true
        editButton.isHidden = false
        bottomBoxView.isHidden = false
//        hintView.isHidden = true
        
        errorStackView.isHidden = true
        errorLabel.text = ""
        
        rowsTopOffsetConstraint?.update(offset: 0)
        
        editTopOffsetConstraint?.deactivate()
        editTopToEmptyLabelConstraint?.activate()
        
        bottomTopToEditConstraint?.update(offset: 24)
        
        editTopOffsetConstraint?.update(offset: 0)
        
        bottomTopToEmptyLabelConstraint?.deactivate()
        bottomTopToEditConstraint?.activate()
        
        editButtonHeightConstraint?.update(offset: 56)
        bottomBoxHeightConstraint?.update(offset: 9)
        
        setNeedsLayout()
    }
    
    private func applyFilledStateLayout() {
        isEmptyState = false
        
        emptyStateLabel.isHidden = true
        rowsStackView.isHidden = false
        editButton.isHidden = false
        bottomBoxView.isHidden = false
//        hintView.isHidden = !isHintVisible
        errorStackView.isHidden = true
        
        rowsTopOffsetConstraint?.update(offset: 24)
        
        editTopToEmptyLabelConstraint?.deactivate()
        editTopOffsetConstraint?.activate()
        
        hintHeightConstraint?.update(offset: isHintVisible ? 56 : 0)
        editButtonHeightConstraint?.update(offset: 56)
        editTopOffsetConstraint?.update(offset: 24)
        
        bottomTopToEmptyLabelConstraint?.deactivate()
        bottomTopToEditConstraint?.activate()
        bottomTopToEditConstraint?.update(offset: 24)
        
        setNeedsLayout()
    }
    
    private func showHintIfNeeded() {
        guard !isEmptyState else { return }
        guard isHintVisible else { return }
        
//        hintView.isHidden = false
        hintHeightConstraint?.update(offset: 56)
        
        setNeedsLayout()
    }
    
    private func hideHint() {
        isHintVisible = false
//        hintView.isHidden = true
        hintHeightConstraint?.update(offset: 0)
        
        setNeedsLayout()
    }
    
    @objc private func didTapEditButton() {
        hideHint()
        onTapEditButton?()
    }
    
    func configure(members: [String]) {
        currentMembers = members
        onMembersChanged?(members)
        
        rowViews.forEach { $0.removeFromSuperview() }
        rowViews.removeAll()
        rowsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (idx, name) in members.enumerated() {
            let row = MemberPriceRowView(index: idx)
            row.configure(name: name, price: nil)

            row.onBeginEditing = { [weak self] in
                self?.hideHint()
            }
            
            rowsStackView.addArrangedSubview(row)
            rowViews.append(row)
        }
        
        if members.isEmpty {
            if hasEverHadMembers {
                applyEditedEmptyStateLayout()
                hideEditedEmptyError()
            } else {
                applyEmptyStateLayout()
            }
        } else {
            hasEverHadMembers = true
            
            if rowViews.isEmpty {
                isHintVisible = true
            }
            
            applyFilledStateLayout()
        }
        DispatchQueue.main.async { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    func setPrice(_ text: String, at index: Int) {
        guard rowViews.indices.contains(index) else { return }
        
        let name = currentMembers.indices.contains(index) ? currentMembers[index] : ""
        let digits = text.replacingOccurrences(of: ",", with: "")
        let price = Int(digits)
        rowViews[index].configure(name: name, price: price)
    }
    
    func setEditButtonTarget(_ target: Any?, action: Selector) {
        editButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func showEditedEmptyError(message: String = "멤버를 1명 이상 추가해주세요") {
        errorLabel.text = message
        errorStackView.isHidden = false
        setNeedsLayout()
    }
    
    func hideEditedEmptyError() {
        errorStackView.isHidden = true
        setNeedsLayout()
    }
    
    func getMembers() -> [String] {
        return currentMembers
    }
    
    func collectPrices(endEditing: Bool = false) -> [Int: Int] {
        if endEditing {
            self.endEditing(true)
        }
        
        var result: [Int: Int] = [:]
        
        for row in rowViews {
            let index = row.index
            if let price = row.currentPrice {
                result[index] = price
            }
        }
        return result
    }
}
