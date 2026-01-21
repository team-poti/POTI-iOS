//
//  OrderCompleteView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import UIKit

import Combine
import Lottie
import SnapKit
import Then

final class OrderCompleteView: BaseView {
    
    // MARK: - UI Components
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let submitSuccessView = LottieAnimationView(name: "join")
    private let bottomButton = PotiBottomButton()
    
    var completionHandler: (() -> Void)?
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        setAddTarget()
        
        backgroundView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.6)
        }
        
        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        submitSuccessView.do {
            $0.loopMode = .playOnce
            $0.backgroundBehavior = .pauseAndRestore
            $0.play { finished in
            }
        }
        
        titleLabel.do {
            $0.text = "참여가 완료되었어요"
            $0.font = PotiFontManager.title18sb.font
            $0.textColor = .potiBlack
            $0.textAlignment = .center
        }
        
        subTitleLabel.do {
            $0.text = "모집이 끝나면 입금이 시작돼요"
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
            $0.textAlignment = .center
        }
        
        bottomButton.do {
            $0.text = "확인"
        }
    }
    
    override func setUI() {
        addSubviews(backgroundView, containerView)
        containerView.addSubviews(titleLabel, subTitleLabel,submitSuccessView, bottomButton)
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(42)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(36)
            $0.horizontalEdges.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
        }
        
        submitSuccessView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(285)
            $0.height.equalTo(228)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(36)
        }
        
        bottomButton.snp.makeConstraints {
            $0.bottom.equalTo(containerView.snp.bottom).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(55)
        }
    }
    
    private func setAddTarget() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        backgroundView.addGestureRecognizer(tapGesture)
        bottomButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }
    
    // MARK: - Methods
    
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
        } completion: { _ in
            self.submitSuccessView.play()
        }
    }
    
    // MARK: - Action
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.containerView.alpha = 0
            self.backgroundView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            self.completionHandler?()
        }
    }
}
