//
//  PotOptionsSheetViewController.swift
//  POTI-iOS
//
//  Created by mandoo on 1/23/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class PotOptionsSheetViewController: BaseViewController<PotOptionsViewModel> {
    
    // MARK: - Properties
    
    private let rootView = OptionView()
    private var currentDropdown: AccordionDropdownView?
    private var deliveryInfoView: SelectedInfoView?
    var onContinue: ((_ shippingId: Int,_ orderItems: [OrderItem]) -> Void)?
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setActions()
        
        viewModel.action(.viewDidLoad)
        showSheet()
    }
    
    // MARK: - Bind
    
    private func bind() {
        viewModel.output.memberAdded
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                self?.addMemberInfoView(name: data.name, priceText: data.priceText)
            }
            .store(in: &cancellables)
        
        viewModel.output.memberRemoved
            .receive(on: RunLoop.main)
            .sink { [weak self] name in
                self?.removeMemberInfoView(name: name)
            }
            .store(in: &cancellables)
        
        viewModel.output.deliveryUpdated
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                self?.updateDeliveryInfoView(name: data.name, priceText: data.priceText)
            }
            .store(in: &cancellables)
        
        viewModel.output.deliveryDeleted
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.updateDeliveryButtonTitle(nil)
            }
            .store(in: &cancellables)
        
        viewModel.output.totalPrice
            .receive(on: RunLoop.main)
            .sink { [weak self] price in
                self?.rootView.contentView.totalPriceNumberLabel.text = price
            }
            .store(in: &cancellables)
        
        viewModel.output.isBottomButtonEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                self?.rootView.contentView.bottomButton.isDisabled = !isEnabled
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup Actions
    
    private func setActions() {
        let content = rootView.contentView
        
        content.memberButton.addTarget(self, action: #selector(toggleMember), for: .touchUpInside)
        content.deliveryButton.addTarget(self, action: #selector(toggleDelivery), for: .touchUpInside)
        content.bottomButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        rootView.closeButton.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
        rootView.backgroundView.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Private Methods

private extension PotOptionsSheetViewController {
    func insertViewRespectingOrder(_ infoView: SelectedInfoView) {
        let stackView = rootView.contentView.selectedStackView
        
        if infoView.type == .Delievery {
            stackView.addArrangedSubview(infoView)
        } else {
            if let deliveryView = deliveryInfoView,
               let deliveryIndex = stackView.arrangedSubviews.firstIndex(of: deliveryView) {
                stackView.insertArrangedSubview(infoView, at: deliveryIndex)
            } else {
                stackView.addArrangedSubview(infoView)
            }
        }
    }
    
    func addMemberInfoView(name: String, priceText: String) {
        let infoView = SelectedInfoView(title: name, price: priceText, type: .Member)
        
        infoView.onDelete = { [weak self, weak infoView] in
            infoView?.removeFromSuperview()
            self?.viewModel.action(.memberDeleteButtonTap(name: name))
        }
        
        insertViewRespectingOrder(infoView)
        scrollToBottom()
    }
    
    func removeMemberInfoView(name: String) {
        let stackView = rootView.contentView.selectedStackView
        stackView.arrangedSubviews.forEach { view in
            if let memberView = view as? SelectedInfoView, memberView.type == .Member {
                memberView.removeFromSuperview()
            }
        }
    }
    
    func updateDeliveryInfoView(name: String, priceText: String) {
        updateDeliveryButtonTitle(name)
        let stackView = rootView.contentView.selectedStackView
        
        if let existingView = deliveryInfoView {
            existingView.updateData(title: name, price: priceText)
        } else {
            let infoView = SelectedInfoView(title: name, price: priceText, type: .Delievery)
            deliveryInfoView = infoView
            stackView.addArrangedSubview(infoView)
        }
        
        scrollToBottom()
    }
    
    func updateDeliveryButtonTitle(_ title: String?) {
        let isSelected = title != nil
        let displayTitle = title ?? "배송 방법을 선택하세요"
        let titleColor: UIColor = isSelected ? .potiBlack : .gray700
        
        var config = rootView.contentView.deliveryButton.configuration
        config?.attributedTitle = AttributedString(displayTitle, attributes: AttributeContainer([
            .font: PotiFontManager.body16m.font,
            .foregroundColor: titleColor
        ]))
        rootView.contentView.deliveryButton.configuration = config
    }
    
    func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            let scrollView = self.rootView.contentView.scrollContainerView
            
            let bottomOffset = CGPoint(
                x: 0,
                y: max(0, scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
            )
            
            if bottomOffset.y > 0 {
                scrollView.setContentOffset(bottomOffset, animated: true)
            }
        }
    }
    
    @objc private func continueButtonTapped() {
        guard
            let shippingId = viewModel.selectedShippingId()
        else { return }
        
        let orderItems = viewModel.makeOrderItems()
        
        dismiss(animated: false) { [weak self] in
            self?.onContinue?(shippingId, orderItems)
        }
    }
}

// MARK: - Sheet & Dropdown

private extension PotOptionsSheetViewController {
    func showSheet() {
        rootView.containerView.transform = CGAffineTransform(translationX: 0, y: 800)
        rootView.backgroundView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.rootView.containerView.transform = .identity
            self.rootView.backgroundView.alpha = 1
        }
    }
    
    func handleDropdown(anchor: UIButton, isMember: Bool) {
        if let current = currentDropdown {
            let isSame = current.anchorView == anchor
            currentDropdown = nil
            current.close()
            if isSame { return }
        }
        
        let dropdown = AccordionDropdownView(
            items: isMember ? viewModel.getMemberDropdownItems() : viewModel.getDeliveryDropdownItems(),
            disabledIndices: isMember ? viewModel.getDisabledMemberIndices() : []
        )
        dropdown.anchorView = anchor
        
        dropdown.onSelectIndex = { [weak self] index in
            self?.viewModel.action(isMember ? .memberSelected(index: index) : .deliverySelected(index: index))
        }
        
        dropdown.onClose = { [weak self, weak anchor] in
            anchor?.configuration?.image = .icnArrowDownLg.withRenderingMode(.alwaysTemplate)
            self?.currentDropdown = nil
        }
        
        rootView.containerView.layoutIfNeeded()
        
        dropdown.open(below: anchor, in: rootView.containerView, bottomAnchorView: rootView.contentView.grayLineView)
        
        rootView.containerView.bringSubviewToFront(anchor)
        
        anchor.configuration?.image = .icnArrowUpLg.withRenderingMode(.alwaysTemplate)
        currentDropdown = dropdown
    }
    
    @objc func dismissSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.rootView.containerView.transform = CGAffineTransform(translationX: 0, y: 800)
            self.rootView.backgroundView.alpha = 0
        }) { _ in
            self.dismiss(animated: false)
        }
    }
    
    @objc func toggleMember() {
        handleDropdown(anchor: rootView.contentView.memberButton, isMember: true)
    }
    
    @objc func toggleDelivery() {
        handleDropdown(anchor: rootView.contentView.deliveryButton, isMember: false)
    }
}

