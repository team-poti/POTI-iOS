//
//  ProductFormView.swift
//  POTI-iOS
//
//  Created by soomin on 8/4/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class ProductFormView: BaseView {

    // MARK: - Properties

    var productTypeTextPublisher: AnyPublisher<String, Never> { productTypeField.textPublisher }
    var onTapArtistField: (() -> Void)?
    var onTapDeadlineField: (() -> Void)?
    var onInputViewDidBeginEditing: ((UIView) -> Void)?

    private var selectedArtistId: Int?

    // MARK: - UI Components

    private let stackView = UIStackView()
    private let artistField = PotiTextField.readOnly(placeholder: "아티스트 찾기", accessory: .search)
    private let productTypeField = PotiSearchField<String>(placeholder: "상품 종류를 입력해주세요", maxVisibleRows: 3, showsSearchIcon: false, titleProvider: { $0 })
    private let deadlineField = PotiTextField.readOnly(placeholder: "날짜를 선택해주세요")
    private let descriptionField = PotiTextView(placeholder: "분철팟 설명을 자세히 적어주세요\n예) 굿즈 구성 / 구매 여부 / 예상 배송일 등")
    private let accountField = PotiTextField.editable(placeholder: "계좌번호를 입력해주세요")
    private let bankField = PotiTextField.editable(placeholder: "은행 정보를 입력해주세요")

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        bindActions()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 28
            $0.alignment = .fill
        }
    }

    override func setUI() {
        addSubview(stackView)
        stackView.addArrangedSubviews(
            FormFieldView(title: "아티스트", fieldView: artistField), FormFieldView(title: "상품 종류", fieldView: productTypeField), FormFieldView(title: "모집 기한", fieldView: deadlineField),
            FormFieldView(title: "설명", fieldView: descriptionField), FormFieldView(title: "계좌번호", fieldView: accountField), FormFieldView(title: "은행", fieldView: bankField)
        )
    }

    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    // MARK: - Private Methods
    
    private func bindActions() {
        artistField.onTap = { [weak self] in
            self?.endEditing(true)
            self?.onTapArtistField?()
        }
        deadlineField.onTap = { [weak self] in
            guard let self else { return }
            endEditing(true)
            deadlineField.setFocused(true)
            onTapDeadlineField?()
        }
        productTypeField.onSelectItem = { [weak self] productType in
            self?.productTypeField.text = productType
            self?.productTypeField.updateSuggestions([])
        }
        productTypeField.onBeginEditing = { [weak self] in self?.onInputViewDidBeginEditing?($0) }
        descriptionField.onBeginEditing = { [weak self] in self?.onInputViewDidBeginEditing?($0) }
        accountField.onBeginEditing = { [weak self] in self?.onInputViewDidBeginEditing?($0) }
        bankField.onBeginEditing = { [weak self] in self?.onInputViewDidBeginEditing?($0) }
    }

    private func validationState(message: String?) -> TextFieldValidationState {
        guard let message else { return .normal }
        return .error(message: message)
    }

    // MARK: - Public Methods

    func makeDraft() -> ProductRegisterDraft {
        ProductRegisterDraft(
            artistId: selectedArtistId, artist: artistField.text, productType: productTypeField.text,
            deadlineText: deadlineField.text, description: descriptionField.text, accountNumber: accountField.text, bank: bankField.text
        )
    }

    func setArtist(id: Int, name: String) {
        selectedArtistId = id
        artistField.text = name
    }
    
    func setDeadline(_ deadline: String) {
        deadlineField.text = deadline
    }

    func updateProductTypeSuggestions(_ suggestions: [String]) {
        productTypeField.updateSuggestions(suggestions)
    }

    func clearFieldFocus() {
        artistField.setFocused(false)
        deadlineField.setFocused(false)
    }

    func renderValidation(_ errors: ProductFormValidationErrors) {
        artistField.setValidationState(validationState(message: errors.artist))
        productTypeField.setValidationState(validationState(message: errors.productType))
        deadlineField.setValidationState(validationState(message: errors.deadline))
        descriptionField.setValidationState(validationState(message: errors.description))
        accountField.setValidationState(validationState(message: errors.accountNumber))
        bankField.setValidationState(validationState(message: errors.bank))
    }

    func deadlineFieldFrame(in view: UIView) -> CGRect {
        deadlineField.convert(deadlineField.bounds, to: view)
    }
}
