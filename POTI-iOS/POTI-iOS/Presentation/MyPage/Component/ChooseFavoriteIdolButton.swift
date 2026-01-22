//
//  ChooseFavoriteIdolButton.swift
//  POTI-iOS
//
//  Created by neon on 1/16/26.
//

import UIKit

import SnapKit

public final class ChooseFavoriteIdolButton: UIButton {
    
    private let favoriteIdolLabel = UILabel()
    private let arrowImageView = UIImageView()
    
    init(hasFavoriteArtist: Bool = false, favoriteArtistName: String? = nil) {
        super.init(frame: .zero)
        setStyle()
        setUI()
        setLayout()
        configure(hasFavoriteArtist: hasFavoriteArtist, favoriteArtistName: favoriteArtistName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .poti200
        layer.cornerRadius = 20
        
        favoriteIdolLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .poti600
        }
        
        arrowImageView.do {
            $0.image = .icnArrowRightSm
            $0.tintColor = .poti600
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setUI() {
        addSubviews(favoriteIdolLabel, arrowImageView)
    }
    
    private func setLayout() {
        favoriteIdolLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.leading.equalTo(favoriteIdolLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
                
        self.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
    
    func configure(
        hasFavoriteArtist: Bool,
        favoriteArtistName: String?
    ) {
        if hasFavoriteArtist,
           let name = favoriteArtistName,
           !name.isEmpty {
            favoriteIdolLabel.text = name
        } else {
            favoriteIdolLabel.text = "나의 최애 선택하기"
        }
    }
}
