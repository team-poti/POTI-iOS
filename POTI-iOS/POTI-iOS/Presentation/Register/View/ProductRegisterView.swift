//
//  ProductRegisterView.swift
//  POTI-iOS
//
//  Created by soomin on 8/9/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class ProductRegisterView: BaseView {

    // MARK: - Properties

    var productTypeTextPublisher: AnyPublisher<String, Never> { productFormView.productTypeTextPublisher }
    var onAction: ((ProductRegisterAction) -> Void)?

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private var productFormView: ProductFormView { productInfoView.productFormView }
    private var imagePickerView: ImagePickerView { productInfoView.imagePickerView }
    private let productInfoView = ProductInfoSectionView()
    private let memberSettingView = MemberSettingSectionView()
    private let shippingSettingView = ShippingSettingSectionView()
    private let noticeContainerView = UIView()
    private let noticeView = NoticeView(type: .register)
    private let submitButton = PotiBottomButton()

    // MARK: - Custom Methods

    override func setStyle() {
        scrollView.do {
            $0.alwaysBounceVertical = true
            $0.showsVerticalScrollIndicator = false
            $0.keyboardDismissMode = .onDrag
            $0.delaysContentTouches = false
            $0.canCancelContentTouches = true
            $0.panGestureRecognizer.cancelsTouchesInView = false
        }

        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
            $0.alignment = .fill
        }

        submitButton.do {
            $0.text = "등록하기"
            $0.color = .primaryMain
            $0.isDisabled = false
        }
    }

    override func setUI() {
        addSubviews(scrollView, submitButton)
        scrollView.addSubview(contentStackView)
        noticeContainerView.addSubview(noticeView)
        contentStackView.addArrangedSubviews(productInfoView, memberSettingView, shippingSettingView, noticeContainerView)
    }

    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(submitButton.snp.top).offset(-40)
        }

        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        noticeView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
        }

        submitButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }
    }

    override func addTarget() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)

        imagePickerView.onTapAdd = { [weak self] in self?.onAction?(.addImage) }
        imagePickerView.onTapDelete = { [weak self] in self?.onAction?(.deleteImage($0)) }
        productFormView.onAction = { [weak self] in self?.onAction?(.form($0)) }
        memberSettingView.onAction = { [weak self] in self?.onAction?(.memberSetting($0)) }
        shippingSettingView.onAction = { [weak self] in self?.onAction?(.shippingSetting($0)) }
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }

    // MARK: - Private Method

    private func scrollIfNeeded(for inputFrame: CGRect, coveredHeight: CGFloat) {
        let visibleHeight = bounds.height - coveredHeight
        let requiredOffset = inputFrame.maxY > visibleHeight ? inputFrame.maxY - visibleHeight + 30 : 0
        guard requiredOffset > 0 else { return }

        let maximumOffset = max(0, scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)

        let targetOffset = min(scrollView.contentOffset.y + requiredOffset, maximumOffset)
        scrollView.setContentOffset(CGPoint(x: 0, y: targetOffset), animated: true)
    }

    // MARK: - Public Methods

    func setImages(_ images: [UIImage]) {
        imagePickerView.setImages(images)
    }

    func setImageValidationError(_ message: String?) {
        if let message {
            imagePickerView.showValidationError(message)
        } else {
            imagePickerView.hideValidationError()
        }
    }

    func updateProductTypeSuggestions(_ suggestions: [String]) {
        productFormView.updateProductTypeSuggestions(suggestions)
    }

    func renderProductFormValidation(_ errors: ProductFormValidationErrors) {
        productFormView.renderValidation(errors)
    }

    func renderMemberSetting(_ state: MemberSettingViewState) {
        memberSettingView.render(state)
    }

    func renderShippingSetting(_ state: ShippingSettingViewState) {
        shippingSettingView.render(state)
    }

    func setArtist(name: String) {
        productFormView.setArtist(name: name)
    }

    func setDeadline(_ deadline: String) {
        productFormView.setDeadline(deadline)
    }

    func clearFieldFocus() {
        productFormView.clearFieldFocus()
    }

    func scrollIfNeeded(for inputView: UIView, coveredHeight: CGFloat) {
        scrollIfNeeded(for: inputView.convert(inputView.bounds, to: self), coveredHeight: coveredHeight)
    }

    // MARK: - Actions

    @objc private func submitButtonTapped() {
        onAction?(.submit)
    }

    @objc private func scrollViewTapped() {
        endEditing(true)
    }
}
