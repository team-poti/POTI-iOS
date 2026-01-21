//
//  RatingView.swift
//  POTI-iOS
//
//  Created by neon on 1/16/26.
//

import UIKit

import SnapKit
import Then

final class RatingView: BaseView {
    
    private let starImageView = UIImageView()
    private let ratingLabel = UILabel()
    private let stackView = UIStackView()
    
    private var rating: Double
    
    init(rating: Double) {
        self.rating = rating
        super.init(frame: .zero)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .potiBlack
        layer.cornerRadius = 20
        
        starImageView.do {
            $0.image = .icnStar
            $0.tintColor = .poti200
            $0.contentMode = .scaleAspectFit
        }
        
        ratingLabel.do {
            $0.textColor = .poti200
            $0.font = PotiFontManager.body14sb.font
            $0.text = String(format: "%.1f", rating)
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
        }
    }
    
    override func setUI() {
        stackView.addArrangedSubviews(starImageView, ratingLabel)
        addSubviews(stackView)
    }
    
    override func setLayout() {
        starImageView.snp.makeConstraints {
            $0.size.equalTo(21)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(71)
        }
    }
}
