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
        postalCodeField.setReadOnly(true)
        addressField.setReadOnly(true)
        phoneField.textField.keyboardType = .phonePad
    }

    override func setUI() {
        fieldStackView.addArrangedSubviews(nameField, postalCodeField, addressField, detailAddressField, phoneField)
        addSubviews(fieldStackView, saveButton)
    }

    override func setLayout() {
        fieldStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        saveButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
        }
    }

    func configure(_ address: AddressEntity) {
        nameField.textField.text = address.name
        postalCodeField.textField.text = address.postalCode
        addressField.textField.text = address.address
        detailAddressField.textField.text = address.detailAddress
        phoneField.textField.text = address.phoneNumber
        saveButton.setEnabled(true)
    }

    func applySearchResult(postalCode: String, address: String) {
        postalCodeField.textField.text = postalCode
        addressField.textField.text = address
        detailAddressField.textField.becomeFirstResponder()
        saveButton.setEnabled(true)
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
}
