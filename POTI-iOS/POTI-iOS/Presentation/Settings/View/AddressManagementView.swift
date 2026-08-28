//
//  AddressManagementView.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

import SnapKit
import Then

final class AddressManagementView: BaseView {
    let scrollView = UIScrollView()
    let nameField = SettingsFieldView(title: "이름", placeholder: "이름을 입력하세요")
    let postalCodeField = SettingsFieldView(
        title: "우편번호",
        placeholder: "우편번호를 검색하세요",
        showsSearchButton: true
    )
    let addressField = SettingsFieldView(title: "주소", placeholder: "주소를 입력하세요")
    let detailAddressField = SettingsFieldView(title: "상세주소", placeholder: "상세주소를 입력하세요")
    let phoneField = SettingsFieldView(title: "연락처", placeholder: "연락처를 입력하세요")
    let saveButton = SettingsActionButton(title: "저장")
    private let fieldStackView = UIStackView()

    override func setStyle() {
        backgroundColor = .potiWhite
        fieldStackView.do {
            $0.axis = .vertical
            $0.spacing = 28
        }
        scrollView.do {
            $0.keyboardDismissMode = .interactive
            $0.showsVerticalScrollIndicator = false
        }
        postalCodeField.setReadOnly(true)
        addressField.setReadOnly(true)
        phoneField.textField.keyboardType = .phonePad
    }

    override func setUI() {
        fieldStackView.addArrangedSubviews(nameField, postalCodeField, addressField, detailAddressField, phoneField)
        scrollView.addSubview(fieldStackView)
        addSubviews(scrollView, saveButton)
    }

    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(saveButton.snp.top).offset(-8)
        }
        fieldStackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide)
            $0.horizontalEdges.equalTo(scrollView.contentLayoutGuide).inset(16)
            $0.bottom.equalTo(scrollView.contentLayoutGuide).inset(16)
            $0.width.equalTo(scrollView.frameLayoutGuide).offset(-32)
        }
        saveButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
        }
    }

    func updateKeyboardFrame(_ keyboardEndFrame: CGRect) {
        layoutIfNeeded()
        let keyboardFrame = convert(keyboardEndFrame, from: nil)
        let overlap = max(0, scrollView.frame.maxY - keyboardFrame.minY)
        let bottomInset = overlap > 0 ? overlap + 12 : 0

        scrollView.contentInset.bottom = bottomInset
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset

        guard overlap > 0,
              let focusedField = editableFields.first(where: { $0.textField.isFirstResponder }) else { return }
        scrollToVisible(focusedField)
    }

    func scrollToVisible(_ field: SettingsFieldView) {
        let rect = field.convert(field.bounds, to: scrollView).insetBy(dx: 0, dy: -12)
        scrollView.scrollRectToVisible(rect, animated: true)
    }

    func configure(_ address: AddressEntity) {
        nameField.textField.text = address.name
        postalCodeField.textField.text = address.postalCode
        addressField.textField.text = address.address
        detailAddressField.textField.text = address.detailAddress
        phoneField.textField.text = address.phoneNumber
        updateSaveButtonState()
    }

    func applySearchResult(postalCode: String, address: String) {
        postalCodeField.textField.text = postalCode
        addressField.textField.text = address
        detailAddressField.textField.becomeFirstResponder()
        updateSaveButtonState()
    }

    var address: AddressEntity {
        AddressEntity(
            name: nameField.textField.text ?? "",
            postalCode: postalCodeField.textField.text ?? "",
            address: addressField.textField.text ?? "",
            detailAddress: detailAddressField.textField.text ?? "",
            phoneNumber: phoneField.textField.text ?? ""
        )
    }

    var editableFields: [SettingsFieldView] {
        [nameField, detailAddressField, phoneField]
    }

    var canSave: Bool {
        [
            nameField,
            postalCodeField,
            addressField,
            detailAddressField,
            phoneField
        ].allSatisfy {
            !($0.textField.text ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
        }
    }

    func updateSaveButtonState() {
        saveButton.setEnabled(canSave)
    }
}
