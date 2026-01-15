//
//  GoodsListLayoutFactory.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import UIKit

struct GoodsListLayoutFactory {
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
                        let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(221)
            )
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: .dynamicH(88), trailing: 16)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(40) 
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            section.boundarySupplementaryItems = [header]
            return section
        }
    }
}
