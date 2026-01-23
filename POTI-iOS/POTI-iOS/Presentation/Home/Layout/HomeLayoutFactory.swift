//
//  HomeLayoutFactory.swift
//  POTI-iOS
//
//  Created by mandoo on 1/14/26.
//

import UIKit

import Combine

//struct HomeLayoutFactory {
//    static func createLayout(currentPageNumber: PassthroughSubject<Int, Never>) -> UICollectionViewCompositionalLayout {
//        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
//            guard let sectionType = HomeSection(rawValue: sectionNumber) else { return nil }
//            
//            switch sectionType {
//            case .banner:
//                return createBannerSection(currentPageNumber: currentPageNumber)
//            case .myGroup:
//                return createGoodsSection(bottomValue: 40)
//            case .otherGroup:
//                return createGoodsSection(bottomValue: .dynamicH(114) + 40)
//            }
//        }
//    }
//}

struct HomeLayoutFactory {
    static func createLayout(currentPageNumber: PassthroughSubject<Int, Never>) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            guard let sectionType = HomeSection(rawValue: sectionNumber) else { return nil }
            
            switch sectionType {
            case .banner:
                let section = createBannerSection(currentPageNumber: currentPageNumber)
                let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BannerBackgroundView.identifier)
                section.decorationItems = [backgroundItem]
                return section
            case .myGroup:
                return createGoodsSection(bottomValue: 40)
            case .otherGroup:
                return createGoodsSection(bottomValue: .dynamicH(114) + 40)
            }
        }
        layout.register(BannerBackgroundView.self, forDecorationViewOfKind: BannerBackgroundView.identifier)
        return layout
    }
}

private extension HomeLayoutFactory {
    static func createBannerSection(currentPageNumber: PassthroughSubject<Int, Never>) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        )
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(.dynamicH(196)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 48, trailing: 0)
        
        section.visibleItemsInvalidationHandler = { (visibleItems, offset, env) in
            let currentPage = Int(max(0, round(offset.x / env.container.contentSize.width)))
            currentPageNumber.send(currentPage)
        }
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .estimated(30),
            heightDimension: .absolute(.dynamicH(6))
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom,
            absoluteOffset: CGPoint(x: 0, y: .dynamicH(-73))
        )
        
        section.boundarySupplementaryItems = [footer]
        return section
    }
    
    static func createGoodsSection(bottomValue: CGFloat) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
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
