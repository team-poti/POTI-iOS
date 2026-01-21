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
    private let submitButton = UIButton() //수정

    override func setUI() {
        addSubviews(scrollView, submitButton)
        scrollView.addSubview(contentView)

        contentView.addSubviews(
            productInfoView,
            memberView,
            shippingView,
            noticeView,
            submitButton
        )
    }

    override func setLayout() {
        // TODO: - 레이아웃 짜기
        /*
        scrollView.snp.makeConstraints {

        }

        contentView.snp.makeConstraints {
         
        }
         
        submitButton.snp.makeConstraints {

        }
        */
    }
}
