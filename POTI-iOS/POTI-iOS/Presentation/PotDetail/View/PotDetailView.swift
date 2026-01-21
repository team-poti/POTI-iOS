//
//  PotDetailView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

import UIKit

final class PotDetailView: BaseView {
    
    // MARK: - UI Components
    
    lazy var potDetailCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: PotDetailLayoutFactory.createLayout()
    )
    let joinButton = PotiBottomButton()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .potiWhite
        
        potDetailCollectionView.do {
            $0.backgroundColor = .clear
            $0.register(DetailBannerCell.self)
            $0.register(DetailInfoCell.self)
            $0.register(DetailUploaderCell.self)
            $0.register(DetailParticipantsCell.self)
            $0.register(DetailEmptyCell.self)
            $0.registerHeader(DetailParticipantsHeaderView.self)
            $0.registerFooter(DetailSubContentFooterView.self)
        }
        
        joinButton.do {
            $0.setTitle("분철팟 참여하기", for: .normal)
        }
    }
    
    override func setUI() {
        addSubviews(potDetailCollectionView, joinButton)
    }
    
    override func setLayout() {
        potDetailCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(joinButton.snp.top).offset(-4)
        }
        
        joinButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }
    }
}
