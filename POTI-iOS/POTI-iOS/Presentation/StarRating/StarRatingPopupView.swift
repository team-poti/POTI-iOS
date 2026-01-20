//
//  StarRatingPopupView.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/21/26.
//

import UIKit

import Cosmos
import SnapKit
import Then

final class StarRatingPopupView: BaseView {

    // MARK: - Properties

    var onSelectCompletion: ((Int) -> Void)?

    // MARK: - UI Components

    private let backgroundView = UIView()
    private let containerView = UIView()

    private let closeButton = UIButton()

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let profileContainerView = UIView()
    private let profileStackView = UIStackView()
    private let textStackView = UIStackView()
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let avgRatingLabel = UILabel()
    private let avgRatingStarImageView = UIImageView()
    private let avgRatingStackView = UIStackView()

    private let starView = CosmosView()

    private let confirmButton = UIButton()
    private let skipButton = UIButton()

    private let contentStackView = UIStackView()

    private var currentRating: Double = 0.0

    // MARK: - Initializer

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {

        backgroundView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.6)
        }

        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }

        titleLabel.do {
            $0.text = "거래는 어땠나요?"
            $0.font = PotiFontManager.title18sb.font
            $0.textColor = .potiBlack
            $0.textAlignment = .center
        }

        subtitleLabel.do {
            $0.text = "별점으로 간단히 평가해주세요"
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }

        profileContainerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }

        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 18
            $0.backgroundColor = .gray700
        }

        nicknameLabel.do {
            $0.text = "닉네임"
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .potiBlack
        }

        avgRatingLabel.do {
            $0.text = "4.8"
            $0.font = .systemFont(ofSize: 12, weight: .regular)
            $0.textColor = .gray700
        }
        avgRatingStarImageView.do {
            $0.image = UIImage(resource: .icnStar)
                .withTintColor(.gray700, renderingMode: .alwaysOriginal)
            $0.contentMode = .scaleAspectFit
        }
        avgRatingStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 0
        }
        
        textStackView.do {
            $0.axis = .vertical
            $0.alignment = .trailing
            $0.distribution = .fill
            $0.spacing = 0
        }

        profileStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 8
        }

        starView.do {
            $0.settings.fillMode = .half
            $0.settings.totalStars = 5
            $0.settings.updateOnTouch = true
            $0.settings.starMargin = -6
            $0.settings.starSize = 48
            $0.rating = 0.0
            $0.settings.minTouchRating = 0.5
            $0.settings.filledImage = UIImage(resource: .icnStarFill)
            $0.settings.emptyImage = UIImage(resource: .icnStarEmpty)

            $0.didFinishTouchingCosmos = { [weak self] rating in
                self?.currentRating = rating
            }
        }
        
        confirmButton.do {
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.potiWhite, for: .normal)
            $0.backgroundColor = .poti600
            $0.layer.cornerRadius = 24
            $0.titleLabel?.font = PotiFontManager.button16sb.font
        }

        skipButton.do {
            $0.setTitle("건너뛰기", for: .normal)
            $0.setTitleColor(.poti600, for: .normal)
            $0.backgroundColor = .clear
            $0.titleLabel?.font = PotiFontManager.button14sb.font
        }

        contentStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 0
        }
    }

    override func setUI() {
        addSubviews(backgroundView, containerView)

        containerView.addSubviews(
            titleLabel,
            subtitleLabel,
            profileContainerView,
            starView,
            confirmButton,
            skipButton
        )
        
        profileContainerView.addSubview(profileStackView)

        avgRatingStackView.addArrangedSubviews(
            avgRatingStarImageView,
            avgRatingLabel
        )

        textStackView.addArrangedSubviews(
            nicknameLabel,
            avgRatingStackView
        )
        
        profileStackView.addArrangedSubviews(
            profileImageView,
            textStackView
        )

        setAddTarget()
    }

    override func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(42)
            $0.centerY.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview().offset(80)
            $0.bottom.lessThanOrEqualToSuperview().inset(80)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.centerX.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        profileContainerView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(26)
            $0.height.equalTo(62)
        }
        
        avgRatingStarImageView.snp.makeConstraints {
            $0.size.equalTo(21)
        }

        starView.snp.makeConstraints {
            $0.top.equalTo(profileContainerView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(37.5)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(48)
        }

        confirmButton.snp.makeConstraints {
            $0.top.equalTo(starView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }

        skipButton.snp.makeConstraints {
            $0.top.equalTo(confirmButton.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }

        profileContainerView.snp.makeConstraints {
            $0.height.equalTo(62)
        }

        profileStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(36)
        }

        textStackView.snp.makeConstraints {
            $0.trailing.lessThanOrEqualToSuperview()
        }

        starView.snp.makeConstraints {
            $0.height.equalTo(48)
        }

        confirmButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        skipButton.snp.makeConstraints {
            $0.top.equalTo(confirmButton.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
        }
    }

    private func bindViewModel() {
//        Publishers.CombineLatest(viewModel.output.options, viewModel.output.selectedIndex)
//            .receive(on: RunLoop.main)
//            .sink { [weak self] _ in
//                self?.tableView.reloadData()
//                self?.updateTableViewHeight()
//            }
//            .store(in: &cancellables)
//
//        viewModel.output.onSelect
//            .receive(on: RunLoop.main)
//            .sink { [weak self] index in
//                self?.onSelectCompletion?(index)
//                self?.dismiss()
//            }
//            .store(in: &cancellables)
    }

    private func setAddTarget() {

        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }

    // MARK: - Methods

    @objc private func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            self.backgroundView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    @objc private func didTapConfirmButton() {
            let latest = starView.rating
            currentRating = latest
            print("saved rating = \(String(format: "%.1f", currentRating))")
        }
}

#Preview {
    StarRatingPopupView()
}
