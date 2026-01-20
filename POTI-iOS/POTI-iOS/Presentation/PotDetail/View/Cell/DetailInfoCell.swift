//
//  DetailInfoCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

import UIKit

final class DetailInfoCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let infoView = PotInfoView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(infoView)
        infoView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Method
    
    func configure(with model: PotDetailModel) {
        infoView.configure(with: model)
    }
}
