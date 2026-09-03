//
//  PotOptionsView.swift
//  POTI-iOS
//
//  Created by soomin on 1/23/26.
//

import UIKit

import SnapKit
import Then

final class PotOptionsView: BaseView {
    
    // MARK: - UI Components
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let closeButton = UIButton()
    private let contentView = OptionContentView()
    
    // MARK: - Properties
    
    private var currentDropdown: AccordionDropdownView?
    private var memberDropdownItems: [DropdownItem] = []
    private var deliveryDropdownItems: [DropdownItem] = []
    
    var onMemberSelected: ((Int) -> Void)?
    var onDeliverySelected: ((Int) -> Void)?
    var onMemberDelete: ((Int) -> Void)?
    var onContinue: (() -> Void)?
    var onClose: (() -> Void)?
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        setActions()
        self.alpha = 0
        
        backgroundView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.6)
        }
        
        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 20
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        closeButton.do {
            $0.setImage(.icnX, for: .normal)
        }
    }
    
    override func setUI() {
        addSubviews(backgroundView, containerView)
        containerView.addSubviews(closeButton, contentView)
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(116)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(4)
            $0.size.equalTo(48)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Private Methods
    
    private func setActions() {
        contentView.memberButton.addTarget(self, action: #selector(memberButtonTapped), for: .touchUpInside)
        contentView.deliveryButton.addTarget(self, action: #selector(deliveryButtonTapped), for: .touchUpInside)
        contentView.bottomButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    private func renderSelectedOptions(_ state: PotOptionsViewState) {
        let stackView = contentView.selectedStackView
        
        stackView.arrangedSubviews
            .compactMap { $0 as? SelectedInfoView }
            .forEach {
                stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
        
        state.selectedMembers.forEach { member in
            let infoView = SelectedInfoView(title: member.name, price: member.priceText, type: .Member)

            infoView.onDelete = { [weak self] in
                self?.onMemberDelete?(member.id)
            }

            stackView.addArrangedSubview(infoView)
        }
        
        if let delivery = state.selectedDelivery {
            let infoView = SelectedInfoView(title: delivery.name, price: delivery.priceText, type: .Delievery)
            stackView.addArrangedSubview(infoView)
        }
        
    }
    
    private func updateDeliveryButtonTitle(_ title: String?) {
        let isSelected = title != nil
        let displayTitle = title ?? "배송 방법을 선택하세요"
        let titleColor: UIColor = isSelected ? .potiBlack : .gray700
        
        var configuration = contentView.deliveryButton.configuration
        configuration?.attributedTitle = AttributedString(displayTitle, attributes: AttributeContainer([
            .font: PotiFontManager.body16m.font, .foregroundColor: titleColor]))
        contentView.deliveryButton.configuration = configuration
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            let scrollView = self.contentView.scrollContainerView
            
            let bottomOffset = CGPoint(x: 0, y: max(0, scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom))
            
            if bottomOffset.y > 0 {
                scrollView.setContentOffset(bottomOffset, animated: true)
            }
        }
    }
    
    private func handleDropdown(anchor: UIButton, isMember: Bool) {
        if let current = currentDropdown {
            let isSame = current.anchorView == anchor
            currentDropdown = nil
            current.close()
            if isSame { return }
        }
        
        let dropdown = AccordionDropdownView(
            items: isMember ? memberDropdownItems : deliveryDropdownItems
        )
        
        dropdown.anchorView = anchor
        dropdown.passthroughViews = [closeButton, contentView.memberButton, contentView.deliveryButton]
        
        dropdown.onSelect = { [weak self] id in
            if isMember {
                self?.onMemberSelected?(id)
            } else {
                self?.onDeliverySelected?(id)
            }
        }
        
        dropdown.onClose = { [weak self, weak anchor] in
            anchor?.configuration?.image = .icnArrowDownLg.withRenderingMode(.alwaysTemplate)
            self?.currentDropdown = nil
        }
        
        containerView.layoutIfNeeded()
        
        dropdown.open(below: anchor, in: containerView, bottomAnchorView: contentView.grayLineView)

        anchor.configuration?.image = .icnArrowUpLg.withRenderingMode(.alwaysTemplate)
        currentDropdown = dropdown
    }
    
    // MARK: - Public Methods
    
    func show() {
        self.layoutIfNeeded()
        
        containerView.transform = CGAffineTransform(translationX: 0, y: bounds.height)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.alpha = 1
            self.containerView.transform = .identity
        } completion: { _ in
            self.memberButtonTapped()
        }
    }
    
    func hide(completion: (() -> Void)? = nil) {
        currentDropdown?.close()
        currentDropdown = nil

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.bounds.height)
            self.alpha = 0
        } completion: { _ in
            completion?()
        }
    }
    
    func render(_ state: PotOptionsViewState) {
        memberDropdownItems = state.memberDropdownItems
        deliveryDropdownItems = state.deliveryDropdownItems
        
        renderSelectedOptions(state)
        updateDeliveryButtonTitle(state.selectedDelivery?.name)
        contentView.totalPriceNumberLabel.setLabel(state.totalPriceText, font: .display20b, color: .potiBlack)
        contentView.bottomButton.isDisabled = !state.isContinueEnabled
        contentView.bottomButton.color = state.isContinueEnabled ? .secondaryMain : .deactiveMain

        scrollToBottom()
    }

    // MARK: - Actions

    @objc private func closeButtonTapped() {
        onClose?()
    }
    
    @objc private func continueButtonTapped() {
        onContinue?()
    }
    
    @objc private func memberButtonTapped() {
        handleDropdown(anchor: contentView.memberButton, isMember: true)
    }
    
    @objc private func deliveryButtonTapped() {
        handleDropdown(anchor: contentView.deliveryButton, isMember: false)
    }
}
