//
//  ProductRegisterView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class ProductRegisterView: BaseView {

    // MARK: - Properties

    var productTypeTextPublisher: AnyPublisher<String, Never> { productFormView.productTypeTextPublisher }
    var onTapAddImage: (() -> Void)?
    var onTapDeleteImage: ((Int) -> Void)?
    var onTapArtistField: (() -> Void)?
    var onTapDeadlineField: (() -> Void)?
    var onInputViewDidBeginEditing: ((UIView) -> Void)?
    var onPriceChanged: ((Int, Int?) -> Void)?
    var onTapSubmit: (() -> Void)?

    private var productFormView: ProductFormView { productInfoView.productFormView }
    private var imagePickerView: ImagePickerView { productInfoView.imagePickerView }

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
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
            $0.keyboardDismissMode = .none
            $0.delaysContentTouches = false
            $0.canCancelContentTouches = true
        }
        scrollView.panGestureRecognizer.cancelsTouchesInView = false

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

        imagePickerView.onTapAdd = { [weak self] in self?.onTapAddImage?() }
        imagePickerView.onTapDelete = { [weak self] in self?.onTapDeleteImage?($0) }
        productFormView.onTapArtistField = { [weak self] in self?.onTapArtistField?() }
        productFormView.onTapDeadlineField = { [weak self] in self?.onTapDeadlineField?() }
        productFormView.onInputViewDidBeginEditing = { [weak self] in self?.onInputViewDidBeginEditing?($0) }
        memberSettingView.onPriceChanged = { [weak self] index, price in self?.onPriceChanged?(index, price) }
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
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
            $0.bottom.equalToSuperview().inset(60)
        }

        submitButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }
    }

    // MARK: - Public Methods

    func configureShippingOptions(_ options: [(name: String, price: Int)]) {
        shippingSettingView.configure(options: options)
    }

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

    func renderMemberError(_ message: String?) {
        if let message {
            memberSettingView.showEditedEmptyError(message: message)
        } else {
            memberSettingView.hideEditedEmptyError()
        }
    }

    func showMembers(_ names: [String]) {
        if names.isEmpty {
            memberSettingView.showEmpty(message: "선택한 멤버가 없어요")
        } else {
            memberSettingView.showMembers(names: names)
        }
    }

    func makeDraft() -> ProductRegisterDraft {
        productFormView.makeDraft()
    }

    func collectSelectedShippings() -> [ShippingSettingSectionView.ShippingRequest] {
        shippingSettingView.collectSelectedShippings()
    }

    func setArtist(id: Int, name: String) {
        productFormView.setArtist(id: id, name: name)
    }

    func setDeadline(_ deadline: String) {
        productFormView.setDeadline(deadline)
    }

    func clearFieldFocus() {
        productFormView.clearFieldFocus()
    }

    func scrollToDeadlineField(coveredHeight: CGFloat) {
        scrollIfNeeded(for: productFormView.deadlineFieldFrame(in: self), coveredHeight: coveredHeight)
    }

    func scrollIfNeeded(for inputView: UIView, coveredHeight: CGFloat) {
        scrollIfNeeded(for: inputView.convert(inputView.bounds, to: self), coveredHeight: coveredHeight)
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

    // MARK: - Action

    @objc private func submitButtonTapped() {
        onTapSubmit?()
    }
}
