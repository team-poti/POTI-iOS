//
//  PotListView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class PotListView: BaseView {

    // MARK: - UI Components

    lazy var potsListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: PotListLayoutFactory.createLayout()
    )
    private let floatingButton = FloatingButton()

    // MARK: - Custom Methods

    override func setStyle() {

        // TODO: - 네비바 컴포넌트 추가하기

        potsListCollectionView.do {
            $0.backgroundColor = .potiWhite
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false

            $0.register(PotListCell.self)
            $0.registerHeader(PotListHeaderCell.self)
        }
    }

    override func setUI() {
        addSubviews(potsListCollectionView, floatingButton)
    }

    override func setLayout() {
        potsListCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        floatingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
