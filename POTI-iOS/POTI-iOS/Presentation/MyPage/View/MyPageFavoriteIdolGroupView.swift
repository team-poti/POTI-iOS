//
//  MyPageFavoriteIdolGroupView.swift
//  POTI-iOS
//
//  Created by Neon on 8/7/26.
//

import UIKit

import SnapKit
import Then

final class MyPageFavoriteIdolGroupView: BaseView {
    
    // MARK: - UI Components
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(
            IdolGroupCell.self,
            forCellWithReuseIdentifier: IdolGroupCell.identifier
        )
        return collectionView
    }()
    
    let inquiryButton = UIButton(type: .system)
    let doneButton = PotiBottomButton()
    
    private let inquiryLabel = UILabel()
    private let inquiryStackView = UIStackView()
    private let bottomContainerView = UIView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        backgroundColor = .potiWhite
        
        inquiryLabel.do {
            $0.text = "원하는 그룹이 없다면"
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }
        
        inquiryButton.do {
            $0.setTitle("문의하기", for: .normal)
            $0.setTitleColor(.poti800, for: .normal)
            $0.titleLabel?.font = PotiFontManager.body14sb.font
        }
        
        inquiryStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 8
        }
        
        doneButton.do {
            $0.size = .large
            $0.color = .deactiveMain
            $0.text = "완료"
            $0.isDisabled = true
        }
        
        bottomContainerView.backgroundColor = .potiWhite
    }
    
    override func setUI() {
        addSubviews(collectionView, inquiryStackView, bottomContainerView)
        inquiryStackView.addArrangedSubviews(inquiryLabel, inquiryButton)
        bottomContainerView.addSubview(doneButton)
    }
    
    override func setLayout() {
        bottomContainerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(4)
        }
        
        inquiryStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(bottomContainerView.snp.top).offset(-20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(inquiryStackView.snp.top).offset(-16)
        }
    }
    
    func updateDoneButton(isEnabled: Bool) {
        doneButton.color = isEnabled ? .primaryMain : .deactiveMain
        doneButton.isDisabled = !isEnabled
    }
}
