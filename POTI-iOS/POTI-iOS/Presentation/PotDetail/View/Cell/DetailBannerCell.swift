//
//  DetailBannerCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class DetailBannerCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let imageView = UIImageView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
    }
    
    private func setUI() {
        addSubview(imageView)
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with imageUrl: String?) {
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            imageView.image = nil 
            return
        }
        imageView.kf.setImage(with: url)
    }
}
