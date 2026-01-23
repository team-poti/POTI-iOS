//
//  BannerBackgroundView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/23/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class BannerBackgroundView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let shadowImageView = UIImageView()
    private let shadowLayerView = UIView()

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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shadowImageView.image = nil
    }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        shadowImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            let angle = CGFloat(-4.26 * Double.pi / 180)
            $0.transform = CGAffineTransform(rotationAngle: angle)
        }
        
        shadowLayerView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.2)
        }
    }

    private func setUI() {
        addSubview(shadowImageView)
        shadowImageView.addSubview(shadowLayerView)
    }

    private func setLayout() {
        shadowImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.height.equalTo(196)
        }
        
        shadowLayerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateImage(url: String) {
        shadowImageView.kf.setImage(with: URL(string: url))
    }
}
