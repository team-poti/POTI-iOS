//
//  NoticeModalView.swift
//  POTI-iOS
//
//  Created by soomin on 7/30/26.
//

import UIKit

import SnapKit
import Then

final class NoticeModalView: BaseView {
    
    // MARK: - Properties
    
    private let modalType: ModalType
    
    private let participateNoticeTexts = [
        "참여 신청 후에는 취소할 수 없습니다. 참여 전 상품 정보를 꼭 확인해 주세요.",
        "모집 완료 후 24시간 이내 입금을 완료해 주세요. 미입금 시 참여가 취소되며, 서비스 이용이 제한될 수 있습니다.",
        "입금 요청 및 배송 등 주요 안내는 알림으로 전달됩니다.",
        "마감일까지 최소 모집 인원이 모이지 않으면 분철은 자동 종료됩니다.",
        "문의나 거래 중 문제가 발생하면 문의하기를 이용해 주세요."
    ]
    
    private let registerNoticeTexts = [
        "모집 시작 후에는 모집 정보를 수정할 수 없습니다.",
        "참여자가 있으면 모집글을 삭제할 수 없습니다.",
        "최소 모집 인원이 충족되면 분철이 진행되며, 남은 수량은 모집자가 부담합니다. 충족되지 않으면 분철은 자동 종료됩니다.",
        "분철 진행 상황에 맞게 상태를 최신으로 유지해 주세요.",
        "분철 진행 및 배송에 대한 책임은 모집자에게 있습니다.",
        "참여자의 개인정보는 배송 목적 외 사용할 수 없으며, 거래 완료 후 즉시 삭제해 주세요."
    ]
    
    // MARK: - UI Components
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let bottomButton = PotiBottomButton()
    private let listStackView = UIStackView()
    
    private let topPointLabel = UILabel()
    private let topPointBackgroundView = UIView()
    private let bottomPointLabel = UILabel()
    private let bottomPointBackgroundView = UIView()
    
    var confirmAction: (() -> Void)?
    var closeAction: (() -> Void)?
    
    // MARK: - Initializer
    
    init(type: ModalType = .participate) {
        self.modalType = type
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        setAddTarget()
        
        backgroundView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.4)
        }
        
        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.text = modalType.title
            $0.font = PotiFontManager.title18sb.font
            $0.textColor = .potiBlack
        }
        
        closeButton.do {
            $0.setImage(.icnX.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .potiBlack
        }
        
        topPointLabel.do {
            $0.setLabel(modalType.pointText, font: .body14m, color: .poti800)
        }
        
        topPointBackgroundView.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 8
        }
        
        listStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        bottomPointLabel.do {
            $0.setLabel("위 내용을 확인하였으며,\n안내 사항을 준수하겠습니다.", font: .body14m, alignment: .center, color: .gray900)
            $0.numberOfLines = 2
        }
        
        bottomPointBackgroundView.do {
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 8
        }
        
        bottomButton.do {
            $0.text = "확인"
            $0.color = .secondaryMain
            $0.buttonSize = 48
        }
    }
    
    override func setUI() {
        addSubviews(backgroundView, containerView)
        containerView.addSubviews(titleLabel, closeButton, topPointBackgroundView,
                                  listStackView, bottomPointBackgroundView, bottomButton)
        topPointBackgroundView.addSubview(topPointLabel)
        bottomPointBackgroundView.addSubview(bottomPointLabel)
        
        noticeTexts.forEach {
            listStackView.addArrangedSubview(makeNoticeLabel(text: $0))
        }
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalTo(containerView).inset(16)
        }
        
        closeButton.snp.makeConstraints {
            $0.size.equalTo(48)
            $0.top.trailing.equalTo(containerView).inset(4)
        }
        
        topPointBackgroundView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(36)
        }
        
        topPointLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        listStackView.snp.makeConstraints {
            $0.top.equalTo(topPointBackgroundView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        bottomPointBackgroundView.snp.makeConstraints {
            $0.top.equalTo(listStackView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(58)
        }
        
        bottomPointLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        bottomButton.snp.makeConstraints {
            $0.top.equalTo(bottomPointBackgroundView.snp.bottom).offset(12)
            $0.bottom.equalTo(containerView.snp.bottom).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Private Methods
    
    private var noticeTexts: [String] {
        switch modalType {
        case .participate:
            participateNoticeTexts
        case .register:
            registerNoticeTexts
        }
    }
    
    private func setAddTarget() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        bottomButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    private func makeNoticeLabel(text: String) -> UILabel {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = PotiFontManager.body14m.fontProperty.lineHeight
        paragraphStyle.maximumLineHeight = PotiFontManager.body14m.fontProperty.lineHeight
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 20
        
        label.attributedText = NSAttributedString(string: "•  \(text)",
                                                  attributes: [.font: PotiFontManager.body14m.font,
                                                               .foregroundColor: UIColor.gray900,
                                                               .paragraphStyle: paragraphStyle])
        label.numberOfLines = 0
        return label
    }
    
    private func dismiss(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.containerView.alpha = 0
            self.backgroundView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
    
    // MARK: - Public Method
    
    func show(in view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        containerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        containerView.alpha = 0
        backgroundView.alpha = 0
        
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.containerView.transform = .identity
            self.containerView.alpha = 1
            self.backgroundView.alpha = 1
        }
    }
    
    // MARK: - Actions
    
    @objc private func closeButtonTapped() {
        dismiss(completion: closeAction)
    }
    
    @objc private func confirmButtonTapped() {
        dismiss(completion: confirmAction)
    }
}
