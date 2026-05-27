//
//  HomeLayoutFactory.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import UIKit

import Combine

struct HomeLayoutFactory {
    static func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            guard let sectionType = HomeSection(rawValue: sectionNumber) else { return nil }
            
            switch sectionType {
            case .banner:
                return createBannerSection()
            case .myGroup:
                return createGoodsSection(bottomValue: .dynamicH(40))
            case .otherGroup:
                return createGoodsSection(bottomValue: .dynamicH(118))
            }
        }
        return layout
    }
}

private extension HomeLayoutFactory {
    static func createBannerSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(196)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0)
        
        return section
    }
    
    static func createGoodsSection(bottomValue: CGFloat) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                              heightDimension: .fractionalHeight(1.0))
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(210),
            heightDimension: .estimated(225)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: bottomValue, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(.dynamicH(24)))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}
