//
//  MyPageHistoryCell.swift
//  POTI-iOS
//
//  Created by neon on 1/20/26.
//

import UIKit

import SnapKit
import Then

final class MyPageHistoryCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private var artistLabel = UILabel()
    private var productLabel = UILabel()
    private var statusLabel = UILabel()
    private let arrowButton = UIButton()
    private var thumbnailImageView = UIImageView()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        artistLabel.do {
            $0.font = PotiFontManager.caption12m.font
            $0.textColor = .gray800
        }
        
        productLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .potiBlack
        }
        
        statusLabel.do {
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .poti600
        }
        
        arrowButton.do {
            $0.setImage(.icnArrowRightLg, for: .normal)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .gray700
        }
        
        thumbnailImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = .imgLottie
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }
    
    private func setUI() {
        contentView.addSubviews(artistLabel, productLabel, statusLabel, arrowButton, thumbnailImageView)
    }
    
    private func setLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(8)
            $0.size.equalTo(81)
        }
        
        artistLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.top).offset(2)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
        }
        
        productLabel.snp.makeConstraints {
            $0.top.equalTo(artistLabel.snp.bottom).offset(2)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
        }
        
        statusLabel.snp.makeConstraints {
            $0.bottom.equalTo(thumbnailImageView.snp.bottom).offset(-3.5)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
        }
        
        arrowButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(artist: String, product: String, status: String, thumbnailURL: String?) {
        artistLabel.text = artist
        productLabel.text = product
        statusLabel.text = status
        
        // TODO: Load image with Kingfisher
        // if let url = URL(string: thumbnailURL ?? "") {
        //     thumbnailImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        // }
    }
}
