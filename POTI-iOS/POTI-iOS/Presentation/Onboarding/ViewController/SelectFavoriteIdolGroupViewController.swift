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
    private let factory: ViewControllerFactory

    private var groups: [IdolGroupModel] = []
    private var selectedGroupId: Int?
    
    init(viewModel: OnboardingViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        viewModel.action(.loadArtists)
    }
    
    override func bindViewModel() {
        viewModel.output.artists
            .receive(on: DispatchQueue.main)
            .sink { [weak self] models in
                self?.groups = models
                self?.rootView.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.onboardingSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigateToHome()
            }
            .store(in: &cancellables)
        
        viewModel.output.onboardingFailure
            .receive(on: DispatchQueue.main)
            .sink { error in
                PotiLogger.debug(error)
            }
            .store(in: &cancellables)
    }
    
    override func addTarget() {
        rootView.skipButton.addTarget(self, action: #selector(skipButtonDidTap), for: .touchUpInside)
        rootView.startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    }
}

extension SelectFavoriteIdolGroupViewController {
    @objc private func skipButtonDidTap() {
        viewModel.action(.submitWithoutArtist)
    }
    
    @objc private func startButtonDidTap() {
        if let selectedId = selectedGroupId {
            viewModel.action(.submitWithArtist)
        } else {
        }
    }
    
    private func navigateToHome() {
        let tabBar = factory.makePotiTabBar()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return
        }
        
        sceneDelegate.window?.rootViewController = tabBar
        sceneDelegate.window?.makeKeyAndVisible()
    }
}

extension SelectFavoriteIdolGroupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGroup = groups[indexPath.item]
        selectedGroupId = selectedGroup.id
        viewModel.action(.artistSelected(selectedGroup.id))
        PotiLogger.debug("선택된 그룹: \(selectedGroup.name), ID: \(selectedGroup.id)")
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
