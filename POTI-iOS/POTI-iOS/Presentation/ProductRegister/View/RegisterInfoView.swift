//
//  RegisterInfoView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class RegisterInfoView: BaseView, UITextFieldDelegate {
    
    // MARK: - Property

    var onTapAddImage: (() -> Void)?
    var onTapDeleteImage: ((Int) -> Void)?
    var onTapArtistField: (() -> Void)?
    var onTapDeadlineField: (() -> Void)?
    var onInputViewDidBeginEditing: ((UIView) -> Void)?

    private var selectedArtistId: Int?

    // MARK: - UI Properties

    private(set) var imagePickerView = ImagePickerView()
    
    private let titleLabel = UILabel()
    private let artistTitleLabel = UILabel()
    private let productTypeTitleLabel = UILabel()
    private let deadlineTitleLabel = UILabel()
    private let descriptionTitleLabel = UILabel()
    private let accountTitleLabel = UILabel()
    private let bankTitleLabel = UILabel()
    private let bottomBoxView = UIView()

    private(set) var artistField = CustomTextField.searchNavigate(placeholder: "아티스트 찾기")
    private(set) var productTypeField = CustomSearchField()
    private(set) var deadlineField = CustomTextField.shortNavigate(placeholder: "날짜를 선택해주세요")
    private(set) var descriptionField = CustomLongTextField.long(placeholder: "분철팟 설명을 자세히 적어주세요\n예) 굿즈 구성 / 구매 여부 / 예상 배송일 등")
    private(set) var accountField = CustomTextField.short(placeholder: "계좌번호를 입력해주세요")
    private(set) var bankField = CustomTextField.short(placeholder: "은행 정보를 입력해주세요")

    // MARK: - UI Setting

    override func setStyle() {
        backgroundColor = .clear

        titleLabel.do {
            $0.text = "상품 정보"
            $0.font = PotiFontManager.title18sb.font
            $0.textColor = .potiBlack
        }

        imagePickerView.onTapAdd = { [weak self] in
            self?.onTapAddImage?()
        }

        imagePickerView.onTapDelete = { [weak self] index in
            self?.onTapDeleteImage?(index)
        }

        bottomBoxView.do {
            $0.backgroundColor = .gray100
        }

        let titleLabels = [
            artistTitleLabel,
            productTypeTitleLabel,
            deadlineTitleLabel,
            descriptionTitleLabel,
            accountTitleLabel,
            bankTitleLabel
        ]

        titleLabels.forEach {
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .potiBlack
        }

        artistTitleLabel.text = "아티스트"
        productTypeTitleLabel.text = "상품 종류"
        deadlineTitleLabel.text = "모집 기한"
        descriptionTitleLabel.text = "설명"
        accountTitleLabel.text = "계좌번호"
        bankTitleLabel.text = "은행"

        artistField.onTapField = { [weak self] in
            self?.endEditing(true)
            self?.onTapArtistField?()
        }
        deadlineField.onTapField = { [weak self] in
            self?.endEditing(true)
            self?.onTapDeadlineField?()
        }

        productTypeField.configure(
            placeholder: "상품 종류를 입력해주세요",
            maxVisibleRows: 3,
            showsRightAccessory: false
        )
        productTypeField.onBeginEditing = { [weak self] textField in
            self?.onInputViewDidBeginEditing?(textField)
        }
        descriptionField.onBeginEditing = { [weak self] textView in
            self?.onInputViewDidBeginEditing?(textView)
        }
        accountField.onBeginEditing = { [weak self] textField in
            self?.onInputViewDidBeginEditing?(textField)
        }
        bankField.onBeginEditing = { [weak self] textField in
            self?.onInputViewDidBeginEditing?(textField)
        }
    }

    override func setUI() {
        addSubviews(
            titleLabel,
            imagePickerView,
            artistTitleLabel,
            artistField,
            productTypeTitleLabel,
            productTypeField,
            deadlineTitleLabel,
            deadlineField,
            descriptionTitleLabel,
            descriptionField,
            accountTitleLabel,
            accountField,
            bankTitleLabel,
            bankField,
            bottomBoxView
        )
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(16)
        }

        imagePickerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.greaterThanOrEqualTo(90)
        }
        
        artistTitleLabel.snp.makeConstraints {
            $0.top.equalTo(imagePickerView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        artistField.snp.makeConstraints {
            $0.top.equalTo(artistTitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        productTypeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(artistField.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        productTypeField.snp.makeConstraints {
            $0.top.equalTo(productTypeTitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        deadlineTitleLabel.snp.makeConstraints {
            $0.top.equalTo(productTypeField.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        deadlineField.snp.makeConstraints {
            $0.top.equalTo(deadlineTitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        descriptionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(deadlineField.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        descriptionField.snp.makeConstraints {
            $0.top.equalTo(descriptionTitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        accountTitleLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionField.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        accountField.snp.makeConstraints {
            $0.top.equalTo(accountTitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        bankTitleLabel.snp.makeConstraints {
            $0.top.equalTo(accountField.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        bankField.snp.makeConstraints {
            $0.top.equalTo(bankTitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        bottomBoxView.snp.makeConstraints {
            $0.top.equalTo(bankField.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(9)
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - Functions
    
    public func clearAllFocus() {
        deadlineField.setFocused(false)
        artistField.setFocused(false)
    }
    
    struct Draft {
        let artistId: Int?
        let artist: String
        let productType: String
        let deadlineText: String
        let description: String
        let accountNumber: String
        let bank: String
    }

    func collectDraft() -> Draft {
        return Draft(
            artistId: selectedArtistId,
            artist: artistField.getText(),
            productType: productTypeField.getText(),
            deadlineText: deadlineField.getText(),
            description: descriptionField.getText(),
            accountNumber: accountField.getText(),
            bank: bankField.getText()
        )
    }

    func setArtist(id: Int, name: String) {
        selectedArtistId = id
        artistField.setText(name)
    }

    func clearArtist() {
        selectedArtistId = nil
        artistField.setText("")
    }

    func setImages(_ images: [UIImage]) {
        imagePickerView.setImages(images)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        onInputViewDidBeginEditing?(textField)
    }
}
