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
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let productInfoView = ProductInfoView()
    private let memberView = MemberView()
    private let shippingView = ShippingView()
    private let noticeView = NoticeView()
    private let submitButton = UIButton() //수정

    override func setStyle() {
        backgroundColor = .systemBackground
    }

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
        // TODO: 레이아웃 짜기
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
