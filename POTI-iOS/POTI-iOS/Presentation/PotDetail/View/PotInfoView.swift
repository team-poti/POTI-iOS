//
//  PotInfoView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/18/26.
//

import UIKit

import SnapKit
import Then

final class PotInfoView: BaseView {
    
    // MARK: - UI Components
    
    private let titleStackView = UIStackView()
    private let artistNameLabel = UILabel()
    private let productNameLabel = UILabel()
    private let heartButton = UIButton()
    private let titleHeaderStackView = UIStackView()
    
    private let priceLabel = UILabel()
    private let timeLabel = UILabel()
    private let dividerView = UIView()
    
    private let contentLabel = UILabel()
    private let deadlineView = RowView()
    private let delieveryView = RowView()
    private let footerStackView = UIStackView()
    private let grayLineView = UIView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        artistNameLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }
        
        productNameLabel.do {
            $0.font = PotiFontManager.title18sb.font
            $0.textColor = .potiBlack
        }
        
        heartButton.do {
            $0.setImage(.icnHeart, for: .normal)
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
        
        titleHeaderStackView.do {
            $0.axis = .horizontal
        }
        
        footerStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
        }
        
        grayLineView.do {
            $0.backgroundColor = .gray100
        }
    }
    
    override func setUI() {
        titleStackView.addArrangedSubviews(artistNameLabel, productNameLabel)
        titleHeaderStackView.addArrangedSubviews(titleStackView, heartButton)
        
        addSubviews(
            titleHeaderStackView,
            priceLabel,
            timeLabel,
            dividerView,
            contentLabel,
            footerStackView,
            grayLineView
        )
        
        footerStackView.addArrangedSubviews(deadlineView, delieveryView)
    }
    
    override func setLayout() {
        titleHeaderStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(artistNameLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
        }
        
        heartButton.snp.makeConstraints {
            $0.size.equalTo(48)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleStackView)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(heartButton.snp.bottom).offset(35)
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
    
    // MARK: - Methods
    
    func configure(with model: PotDetailModel) {
        artistNameLabel.text = model.artist
        productNameLabel.text = model.title
        
        let datePart = String(model.uploadTime.prefix(10))
        timeLabel.text = "\(datePart) 등록"
        
        contentLabel.text = model.content
        setPriceLabel(price: model.price)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let shippingStrings: [String] = model.shippingOptions.map { option in
            let formattedPrice = formatter.string(from: NSNumber(value: option.price)) ?? "\(option.price)"
            return "\(option.name) \(formattedPrice)원"
        }
        
        let formattedDeadline = "\(model.deadline) 까지"
        deadlineView.configure(title: "모집 기한", value: formattedDeadline)
        
        delieveryView.configureWithDivider(title: "배송비", values: shippingStrings)
    }
    
    private func setPriceLabel(price: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedPrice = formatter.string(from: NSNumber(value: price)) ?? "\(price)"
        
        let priceString = "\(formattedPrice)원~"
        let perPersonString = " / 인"
        let fullString = priceString + perPersonString
        
        let attributedString = NSMutableAttributedString(string: fullString)
        
        let range = (fullString as NSString).range(of: perPersonString)
        
        if range.location != NSNotFound {
            attributedString.addAttributes([
                .foregroundColor: UIColor.gray800,
                .font: PotiFontManager.body16m.font
            ], range: range)
        }
        
        priceLabel.attributedText = attributedString
    }
}

final class RowView: BaseView {
    
    // MARK: - UI Components
    
    let titleLabel = UILabel()
    let valueStackView = UIStackView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        titleLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }
        
        valueStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }
    }
    
    override func setUI() {
        addSubviews(titleLabel, valueStackView)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(77)
        }
        
        valueStackView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.centerY.equalTo(titleLabel)
        }
    }
    
    // MARK: - Methods
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let label = createValueLabel(with: value)
        valueStackView.addArrangedSubview(label)
    }
    
    func configureWithDivider(title: String, values: [String]) {
        titleLabel.text = title
        valueStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, value) in values.enumerated() {
            let label = createValueLabel(with: value)
            valueStackView.addArrangedSubview(label)
            
            if index < values.count - 1 {
                let divider = createVerticalDivider()
                valueStackView.addArrangedSubview(divider)
            }
        }
    }
    
    private func createValueLabel(with text: String) -> UILabel {
        return UILabel().then {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .potiBlack
            $0.text = text
        }
    }
    
    private func createVerticalDivider() -> UIView {
        return UIView().then {
            $0.backgroundColor = .gray800
            $0.snp.makeConstraints { make in
                make.width.equalTo(1)
                make.height.equalTo(21)
            }
        }
    }
}
