//
//  SelectFavoriteIdolGroupView.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class SelectFavoriteIdolGroupView: BaseView {
    
    private let progressBar = UIImageView()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(IdolGroupCell.self, forCellWithReuseIdentifier: IdolGroupCell.identifier)
        collectionView.register(
            IdolGroupHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: IdolGroupHeaderView.identifier
        )
        return collectionView
    }()
    
    let skipButton = PotiBottomButton()
    let startButton = PotiBottomButton()
    
    override func setStyle() {
        progressBar.do {
            $0.image = .imgOnboarding3
            $0.contentMode = .scaleAspectFit
        }
        
        // TODO: - 셀 불러오기
        
        skipButton.do {
            $0.size = .small
            $0.color = .primarySub
            $0.text = "건너뛰기"
        }
        
        startButton.do {
            $0.size = .medium
            $0.color = .primaryMain
            $0.text = "시작하기"
        }
    }
    
    override func setUI() {
        addSubviews(progressBar, collectionView, skipButton, startButton)
    }
    
    override func setLayout() {
        progressBar.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(progressBar.snp.bottom)
            $0.bottom.equalTo(skipButton.snp.top).offset(-2)
        }
        
        skipButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
        }
        
        startButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
        }
    }
}
