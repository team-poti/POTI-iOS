//
//  DetailUploaderCell.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

import UIKit

final class DetailUploaderCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    let uploaderView = UploaderInfoView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(uploaderView)
        uploaderView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Method
    
    func configure(with model: UploaderModel, target: Any?, action: Selector) {
        uploaderView.configure(with: model)
        
        uploaderView.profileDetailButton.removeTarget(nil, action: nil, for: .allEvents)
        
        uploaderView.profileDetailButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

