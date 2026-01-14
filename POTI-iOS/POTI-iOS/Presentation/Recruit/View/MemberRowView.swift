
////
////  MemberRowView.swift
////  POTI-iOS
////
////  Created by 이서현 on 1/13/26.
////
//
//import UIKit

//import SnapKit
//import Then
//
//final class MemberRowView: BaseView {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - UI Components
//
//    private let shippingStackView = UIStackView()
//    private let deliveryIconView = UIImageView()
//    private let shippingLabel = UILabel()
//    private let shipPriceLabel = UILabel()
//    private let priceStackView = UIStackView()
//    private let priceIconView = UIImageView()
//    private let totalPriceLabel = UILabel()
//    private let iconStackView = IconStackView(iconName: "icn-member", title: "멤버 명", price: 5000, fontSizeCase: .small)
//
//    override func setStyle() {
//        shippingLabel.do {
//            $0.textColor = .poti600
//            $0.font = PotiFontManager.body14sb.font
//            $0.textAlignment = .center
//        }
//    }
//
//    override func setUI() {
//        self.addSubviews(
//            iconStackView
//        )
//    }
//
//    override func setLayout() {
//        iconStackView.snp.makeConstraints {
//            $0.edges.equalToSuperview().inset(16)
//        }
//    }
//}
//
//#Preview {
//    MemberRowView()
//}
