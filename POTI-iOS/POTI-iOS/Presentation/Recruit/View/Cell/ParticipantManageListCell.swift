//
//  ParticipantManageListCell.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/14/26.
//

import UIKit

import SnapKit
import Then

final class ParticipantManageListCell: UITableViewCell {
    
    var onTapStatusAction: ((ParticipantManageModel) -> Void)?
    var onTapToggle: (() -> Void)?
    
    private let totalStackView = IconStackView(
        iconName: "icn-priceAngle",
        title: "총 입금 금액",
        price: 12800,
        fontSizeCase: .large
    )
    private let participantCaseView = ParticipantStatusCaseView()
    
    private let rootStackView = UIStackView()
    private let headerContainerView = UIView()
    private let divideView = DivideView()
    private let bottomDivideView = DivideView()
    
    // MARK: - UI Component
    private let participantMemberLabel = UILabel()
    private let statusLabel = UILabel()
    private let toggleButton = UIButton()
    
    private let grayBackgroundView = UIView()
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let depositLabel = UILabel()
    private let memberRowStackView = MemberRowStackView()
    private let shippingStackView = IconStackView(iconName: "icn-delivery", title: "", price: 0, fontSizeCase: .small)
    private let divideTopView = DivideView()
    private let divideBottomView = DivideView()
    private let emptyView = UIView()
    
    private var participantCaseZeroHeightConstraint: Constraint?
    private var paddingZeroHeightConstraint: Constraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .potiWhite
        setStyle()
        setUI()
        setLayout()
        addTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onTapToggle = nil
        onTapStatusAction = nil
        memberRowStackView.reset()
        participantCaseZeroHeightConstraint?.deactivate()
        grayBackgroundView.isHidden = true
        toggleButton.setImage(.icnArrowDownLg, for: .normal)
    }
    
    //MARK: - Custom Method
    
    private func setStyle() {
        emptyView.backgroundColor = .potiWhite
        participantMemberLabel.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
            $0.numberOfLines = 1
        }
        statusLabel.do {
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .potiBlack
        }
        toggleButton.do {
            $0.setImage(UIImage(resource: .icnArrowDownLg), for: .normal)
        }
        rootStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 0
        }
        grayBackgroundView.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 12
        }
        profileImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 12
            $0.layer.masksToBounds = true
        }
        nicknameLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .potiBlack
        }
        depositLabel.do {
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .potiBlack
            $0.text = "입금 금액"
        }
    }
    
    private func setUI() {
        contentView.addSubview(rootStackView)
        
        rootStackView.addArrangedSubviews(
            divideView,
            headerContainerView,
            grayBackgroundView,
            emptyView,
            bottomDivideView
        )
        
        headerContainerView.addSubviews(
            participantMemberLabel,
            statusLabel,
            toggleButton
        )
        
        grayBackgroundView.addSubviews(
            profileImageView,
            nicknameLabel,
            divideTopView,
            depositLabel,
            memberRowStackView,
            shippingStackView,
            divideBottomView,
            totalStackView,
            participantCaseView
        )
        
        // 기본은 접힘
        grayBackgroundView.isHidden = true
        bottomDivideView.isHidden = true
    }
    
    private func setLayout() {
        rootStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        divideView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        bottomDivideView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        headerContainerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        participantMemberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.width.equalTo(235)
        }
        
        toggleButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(participantMemberLabel)
        }
        
        statusLabel.snp.makeConstraints {
            $0.trailing.equalTo(toggleButton.snp.leading).offset(-8)
            $0.centerY.equalTo(participantMemberLabel)
        }
        
        grayBackgroundView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        emptyView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(grayBackgroundView.snp.bottom).offset(20)
            $0.height.equalTo(0.1)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.leading.equalTo(grayBackgroundView).inset(16)
            $0.size.equalTo(24)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.centerY.equalTo(profileImageView)
        }
        
        divideTopView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(grayBackgroundView).inset(16)
        }
        
        depositLabel.snp.makeConstraints {
            $0.top.equalTo(divideTopView.snp.bottom).offset(16)
            $0.leading.equalTo(grayBackgroundView).inset(16)
        }
        
        memberRowStackView.snp.makeConstraints {
            $0.top.equalTo(depositLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalTo(grayBackgroundView).inset(16)
        }
        
        shippingStackView.snp.makeConstraints {
            $0.top.equalTo(memberRowStackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(grayBackgroundView).inset(16)
        }
        
        divideBottomView.snp.makeConstraints {
            $0.top.equalTo(shippingStackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(grayBackgroundView).inset(16)
        }
        
        totalStackView.snp.makeConstraints {
            $0.top.equalTo(divideBottomView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(grayBackgroundView).inset(16)
        }
        
        participantCaseView.snp.makeConstraints {
            $0.top.equalTo(totalStackView.snp.bottom)
            $0.horizontalEdges.equalTo(grayBackgroundView).inset(16)
            $0.bottom.equalTo(grayBackgroundView).inset(16)
            participantCaseZeroHeightConstraint = $0.height.equalTo(0).constraint
        }
    }
    
    private func addTarget() {
        toggleButton.addTarget(self, action: #selector(didTapToggle), for: .touchUpInside)
    }
}

extension ParticipantManageListCell {
    func configure(model: ParticipantManageModel, isExpanded: Bool, isLast: Bool) {
        /// header
        participantMemberLabel.text = model.memberTitle.joined(separator: ", ")
        statusLabel.text = model.participantstatus.badgeText
        statusLabel.textColor = model.participantstatus.badgeColor
        updateToggleButton(isExpanded: isExpanded)
        
        /// gray content
        nicknameLabel.text = model.nickname
        if let url = URL(string: model.profileImage) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
        
        memberRowStackView.configure(model: model)
        shippingStackView.configure(title: model.shippingText, price: model.shippingPrice)
        totalStackView.configure(title: "총 입금 금액", price: model.totalPrice)
        
        participantCaseView.configure(
            status: model.participantstatus,
            model: model,
            onTapAction: { [weak self] in
                guard let self else { return }
                self.onTapStatusAction?(model)
            }
        )
        
        switch model.participantstatus {
        case .waitPay, .waitRecruit:
            participantCaseZeroHeightConstraint?.activate()
        default:
            participantCaseZeroHeightConstraint?.deactivate()
        }
        
        grayBackgroundView.isHidden = !isExpanded
        bottomDivideView.isHidden = !isLast
        rootStackView.setCustomSpacing(0, after: headerContainerView)
        rootStackView.setCustomSpacing(160, after: grayBackgroundView)
    }
    
    private func updateToggleButton(isExpanded: Bool) {
        let image = UIImage(
            resource: isExpanded ? .icnArrowUpLg : .icnArrowDownLg
        ).withRenderingMode(.alwaysTemplate)
        
        toggleButton.setImage(image, for: .normal)
        toggleButton.tintColor = .gray800
    }
    
    @objc private func didTapToggle() {
        onTapToggle?()
    }
}
