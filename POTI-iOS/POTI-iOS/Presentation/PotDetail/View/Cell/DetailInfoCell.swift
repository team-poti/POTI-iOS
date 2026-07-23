//
//  DetailInfoCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class DetailInfoCell: UICollectionViewCell {

    // MARK: - UI Components

    private let titleStackView = UIStackView()
    private let artistNameLabel = UILabel()
    private let productNameLabel = UILabel()

    private let priceLabel = UILabel()
    private let timeLabel = UILabel()
    private let dividerView = UIView()

    private let contentLabel = UILabel()
    private let deadlineView = RowView()
    private let delieveryView = RowView()
    private let footerStackView = UIStackView()
    private let grayLineView = UIView()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    private func setStyle() {
        artistNameLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }

        productNameLabel.do {
            $0.font = PotiFontManager.title18sb.font
            $0.textColor = .potiBlack
        }

        priceLabel.do {
            $0.textColor = .potiBlack
            $0.font = PotiFontManager.display20b.font
        }

        timeLabel.do {
            $0.textColor = .gray800
            $0.font = PotiFontManager.body14m.font
        }

        dividerView.do {
            $0.backgroundColor = .gray300
        }

        contentLabel.do {
            $0.textColor = .potiBlack
            $0.font = PotiFontManager.body16m.font
            $0.numberOfLines = 0
        }

        titleStackView.do {
            $0.axis = .vertical
        }

        footerStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
        }

        grayLineView.do {
            $0.backgroundColor = .gray100
        }
    }

    private func setUI() {
        titleStackView.addArrangedSubviews(artistNameLabel, productNameLabel)

        contentView.addSubviews(titleStackView, priceLabel, timeLabel,
                                dividerView, contentLabel, footerStackView, grayLineView)

        footerStackView.addArrangedSubviews(deadlineView, delieveryView)
    }

    private func setLayout() {
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }

        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(artistNameLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview()
        }

        timeLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }

        dividerView.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(20)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
        }

        footerStackView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(60)
            $0.horizontalEdges.equalToSuperview()
        }

        grayLineView.snp.makeConstraints {
            $0.height.equalTo(8)
            $0.horizontalEdges.equalToSuperview().inset(-20)
            $0.top.equalTo(footerStackView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - Private Method
    
    private func setPriceLabel(price: Int) {
        let formatter = NumberFormatter().then { $0.numberStyle = .decimal }
        let formattedPrice = formatter.string(from: NSNumber(value: price)) ?? "\(price)"

        let priceString = "\(formattedPrice)원~"
        let perPersonString = " / 인"
        let fullString = priceString + perPersonString

        let attributedString = NSMutableAttributedString(string: fullString)
        let range = (fullString as NSString).range(of: perPersonString)

        if range.location != NSNotFound {
            attributedString.addAttributes([.foregroundColor: UIColor.gray800, .font: PotiFontManager.body16m.font], range: range)
        }

        priceLabel.attributedText = attributedString
    }
    
    // MARK: - Public Method

    func configure(with model: PotDetailModel) {
        artistNameLabel.text = model.artist
        productNameLabel.text = model.title

        let datePart = String(model.uploadTime.prefix(10))
        timeLabel.text = "\(datePart) 등록"

        contentLabel.text = model.content
        setPriceLabel(price: model.price)

        let formatter = NumberFormatter().then { $0.numberStyle = .decimal }
        let shippingStrings: [String] = model.shippingOptions.map { option in
            let formattedPrice = formatter.string(from: NSNumber(value: option.price)) ?? "\(option.price)"
            return "\(option.name) \(formattedPrice)원"
        }

        let formattedDeadline = "\(model.deadline) 까지"
        deadlineView.configure(title: "모집 기한", value: formattedDeadline)
        delieveryView.configureWithDivider(title: "배송비", values: shippingStrings)
    }
}
