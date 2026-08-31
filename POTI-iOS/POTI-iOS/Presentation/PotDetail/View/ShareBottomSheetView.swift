//
//  ShareBottomSheetView.swift
//  POTI-iOS
//
//  Created by soomin on 8/28/26.
//

import UIKit

import SnapKit
import Then

final class ShareBottomSheetView: BaseView {

    // MARK: - Properties

    var onSelect: ((ShareOption) -> Void)?
    var onDismiss: (() -> Void)?

    // MARK: - UI Components

    private let backgroundView = UIView()
    private let containerView = UIView()
    private let closeButton = UIButton()
    private let optionStackView = UIStackView()
    private let linkButton = ShareOptionButton(title: "링크 복사", image: .btnLinkShare)
    private let kakaoTalkButton = ShareOptionButton(title: "카카오톡", image: .btnKakaoShare)
    private let xButton = ShareOptionButton(title: "X", image: .btnXShare)
    private let systemShareButton = ShareOptionButton(title: "공유하기", image: .btnShare)

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .clear
        
        backgroundView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.6)
        }
        
        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 20
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.clipsToBounds = true
        }

        closeButton.do {
            $0.setImage(.icnX, for: .normal)
        }

        optionStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 20
        }
    }

    override func setUI() {
        addSubviews(backgroundView, containerView)
        containerView.addSubviews(closeButton, optionStackView)
        optionStackView.addArrangedSubviews(linkButton, kakaoTalkButton, xButton, systemShareButton)
    }

    override func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        closeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(4)
            $0.top.equalToSuperview().inset(8)
            $0.size.equalTo(48)
        }

        optionStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(68)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(93)
            $0.bottom.equalTo(containerView.safeAreaLayoutGuide).inset(50)
        }

        [linkButton, kakaoTalkButton, xButton, systemShareButton].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(64)
            }
        }
    }

    override func addTarget() {
        closeButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        linkButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
        kakaoTalkButton.addTarget(self, action: #selector(kakaoTalkButtonTapped), for: .touchUpInside)
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        systemShareButton.addTarget(self, action: #selector(systemShareButtonTapped), for: .touchUpInside)
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissButtonTapped)))
    }

    func preparePresentation() {
        layoutIfNeeded()
        containerView.transform = CGAffineTransform(translationX: 0, y: containerView.bounds.height)
        backgroundView.alpha = 0
    }

    func animatePresentation() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.containerView.transform = .identity
            self.backgroundView.alpha = 1
        }
    }

    func animateDismissal(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.bounds.height)
            self.backgroundView.alpha = 0
        }) { _ in
            completion()
        }
    }

    // MARK: - Actions

    @objc private func dismissButtonTapped() {
        onDismiss?()
    }

    @objc private func linkButtonTapped() {
        onSelect?(.link)
    }

    @objc private func kakaoTalkButtonTapped() {
        onSelect?(.kakaoTalk)
    }

    @objc private func xButtonTapped() {
        onSelect?(.x)
    }

    @objc private func systemShareButtonTapped() {
        onSelect?(.system)
    }
}
