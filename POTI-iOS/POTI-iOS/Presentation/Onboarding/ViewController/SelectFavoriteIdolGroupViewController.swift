//
//  SelectFavoriteIdolGroupViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class SelectFavoriteIdolGroupViewController: BaseViewController<OnboardingViewModel>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        .backButton
    }
    
    private let rootView = SelectFavoriteIdolGroupView()
    
    private var groups: [IdolGroupModel] = []
    private var selectedGroupId: Int?
    
    override func loadView() {
        self.view = rootView
    }
    
    override func setDelegate() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 여기서 데이터 로드!
        groups = IdolGroupModel.dummyGroups()
        rootView.collectionView.reloadData()
    }
    
    override func addTarget() {
        rootView.skipButton.addTarget(self, action: #selector(skipButtonDidTap), for: .touchUpInside)
        rootView.startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    }
}

extension SelectFavoriteIdolGroupViewController {
    @objc private func skipButtonDidTap() {
        // TODO: - 루트뷰 탭바로 바꾸기
    }
    
    @objc private func startButtonDidTap() {
        // TODO: - 서버에 선택한 그룹 id 보내기 + 루트뷰 탭바로 바꾸기
        if let selectedId = selectedGroupId {
            print("선택된 그룹 ID: \(selectedId)")
        } else {
        }
    }
}

extension SelectFavoriteIdolGroupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGroup = groups[indexPath.item]
        selectedGroupId = selectedGroup.id
        
        print("🎯 선택된 그룹: \(selectedGroup.name), ID: \(selectedGroup.id)")
    }
}

extension SelectFavoriteIdolGroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: IdolGroupCell.identifier,
            for: indexPath
        ) as? IdolGroupCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: groups[indexPath.item])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: IdolGroupHeaderView.identifier,
                for: indexPath
              ) as? IdolGroupHeaderView else {
            return UICollectionReusableView()
        }
        
        return header
    }
}

extension SelectFavoriteIdolGroupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let horizontalSpacing: CGFloat = 16
        let horizontalInset: CGFloat = 24
        
        let availableWidth = collectionView.bounds.width - (horizontalInset * 2)
        let cellWidth = (availableWidth - (horizontalSpacing * 2)) / 3

        return CGSize(width: cellWidth, height: 114)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 28.5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 16
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 84)
    }
}
