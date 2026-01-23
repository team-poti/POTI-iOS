//
//  PotOptionsView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/23/26.
//


import UIKit

import Combine
import SnapKit
import Then

final class PotOptionsView: BaseView {
    
    // MARK: - UI Components
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let closeButton = UIButton()
    private let contentView = OptionContentView()
    
    // MARK: - Properties
    
    private let viewModel: PotOptionsViewModel
    private var cancellables = Set<AnyCancellable>()
    private var currentDropdown: AccordionDropdownView?
    private var deliveryInfoView: SelectedInfoView?
    
    var onContinue: ((Int, [OrderItem], (String, Int)?, [(String, Int)]) -> Void)?
    var onDismiss: (() -> Void)?
    
    // MARK: - Initializer
    
    init(viewModel: PotOptionsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        bind()
        viewModel.action(.viewDidLoad)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
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
            $0.height.equalTo(750)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(4)
            $0.size.equalTo(48)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
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
        
        viewModel.output.totalPrice
            .receive(on: RunLoop.main)
            .sink { [weak self] price in
                self?.contentView.totalPriceNumberLabel.text = price
            }
            .store(in: &cancellables)
        
        viewModel.output.isBottomButtonEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                guard let self = self else { return }
                
                self.contentView.bottomButton.isDisabled = !isEnabled
                self.contentView.bottomButton.color = isEnabled ? .secondaryMain : .deactiveMain
            }
            .store(in: &cancellables)
        
        setActions()
    }
    
    // MARK: - Method
    
    func show(in parentView: UIView) {
        parentView.addSubview(self)
        self.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.layoutIfNeeded()
        
        containerView.transform = CGAffineTransform(translationX: 0, y: 750)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.alpha = 1
            self.containerView.transform = .identity
        } completion: { _ in
            self.toggleMember()
        }
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 750)
            self.alpha = 0
        } completion: { _ in
            self.onDismiss?()
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Action
    
    private func setActions() {
        contentView.memberButton.addTarget(self, action: #selector(toggleMember), for: .touchUpInside)
        contentView.deliveryButton.addTarget(self, action: #selector(toggleDelivery), for: .touchUpInside)
        contentView.bottomButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func continueButtonTapped() {
        guard let shippingId = viewModel.selectedShippingId() else { return }
        
        let orderItems = viewModel.makeOrderItems()
        let selectedMemberInfos = viewModel.selectedMembers.map { (name: $0.key, price: $0.value) }
        let selectedShippingInfo = viewModel.selectedDelivery
        
        onContinue?(shippingId, orderItems, selectedShippingInfo, selectedMemberInfos)
        hide()
    }
    
    @objc private func toggleMember() {
        handleDropdown(anchor: contentView.memberButton, isMember: true)
    }
    
    @objc private func toggleDelivery() {
        handleDropdown(anchor: contentView.deliveryButton, isMember: false)
    }
}

// MARK: - Private Methods

private extension PotOptionsView {
    func insertViewRespectingOrder(_ infoView: SelectedInfoView) {
        let stackView = contentView.selectedStackView
        
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
        let stackView = contentView.selectedStackView
        stackView.arrangedSubviews.forEach { view in
            if let memberView = view as? SelectedInfoView, memberView.type == .Member {
                memberView.removeFromSuperview()
            }
        }
    }
    
    func updateDeliveryInfoView(name: String, priceText: String) {
        updateDeliveryButtonTitle(name)
        let stackView = contentView.selectedStackView
        
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
        
        var config = contentView.deliveryButton.configuration
        config?.attributedTitle = AttributedString(displayTitle, attributes: AttributeContainer([
            .font: PotiFontManager.body16m.font,
            .foregroundColor: titleColor
        ]))
        contentView.deliveryButton.configuration = config
    }
    
    func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            let scrollView = self.contentView.scrollContainerView
            
            let bottomOffset = CGPoint(
                x: 0,
                y: max(0, scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
            )
            
            if bottomOffset.y > 0 {
                scrollView.setContentOffset(bottomOffset, animated: true)
            }
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
        
        containerView.layoutIfNeeded()
        
        dropdown.open(below: anchor, in: containerView, bottomAnchorView: contentView.grayLineView)
        
        containerView.bringSubviewToFront(anchor)
        
        anchor.configuration?.image = .icnArrowUpLg.withRenderingMode(.alwaysTemplate)
        currentDropdown = dropdown
    }
}
