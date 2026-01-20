//
//  ProductRegisterView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class ProductRegisterView: BaseView {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let productInfoView = RegisterInfoView()
    private let memberView = RegisterMemberView()
    private let shippingView = RegisterShippingView()
    private let noticeView = RegisterNoticeView()
    private let submitButton = PotiBottomButton()

    var imagePickerView: ImagePickerView { productInfoView.imagePickerView }
    var registerInfoView: RegisterInfoView { productInfoView }
    var registerMemberView: RegisterMemberView { memberView }
    var registerShippingView: RegisterShippingView { shippingView }
    var registerNoticeView: RegisterNoticeView { noticeView }
    var registerSubmitButton: PotiBottomButton { submitButton }

    override func setUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubviews(
            productInfoView,
            memberView,
            shippingView,
            noticeView,
            submitButton
        )
    }

    override func setStyle() {
        super.setStyle()

        scrollView.do {
            $0.alwaysBounceVertical = true
            $0.showsVerticalScrollIndicator = true
            $0.keyboardDismissMode = .onDrag
        }

        submitButton.do {
            $0.text = "등록하기"
            $0.color = .primaryMain
            $0.isDisabled = false
        }
    }

    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        productInfoView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }

        memberView.snp.makeConstraints {
            $0.top.equalTo(productInfoView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }

        shippingView.snp.makeConstraints {
            $0.top.equalTo(memberView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }

        noticeView.snp.makeConstraints {
            $0.top.equalTo(shippingView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }

        submitButton.snp.makeConstraints {
            $0.top.equalTo(noticeView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(4)
        }
    }
}
