//
//  MyPageFavoriteIdolGroupViewController.swift
//  POTI-iOS
//
//  Created by Neon on 8/7/26.
//

import UIKit

final class MyPageFavoriteIdolGroupViewController: BaseViewController<OnboardingViewModel>, NavigationConfigurable {
    
    // MARK: - Properties
    
    var onFavoriteUpdated: (() -> Void)?
    
    private let rootView = MyPageFavoriteIdolGroupView()
    private var groups: [IdolGroupModel] = []
    private var selectedGroupId: Int?
    private let nickname: String
    
    // MARK: - Initializer
    
    init(nickname: String, viewModel: OnboardingViewModel) {
        self.nickname = nickname
        super.init(viewModel: viewModel)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.nicknameConfirmed(nickname))
        viewModel.action(.loadArtists)
    }
    
    // MARK: - NavigationConfigurable
    
    func navigationStyle() -> PotiNavigationStyle {
        .backDefault("나의 최애 선택")
    }
    
    // MARK: - Override Methods
    
    override func setDelegate() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    override func addTarget() {
        rootView.doneButton.addTarget(
            self,
            action: #selector(doneButtonDidTap),
            for: .touchUpInside
        )
        rootView.inquiryButton.addTarget(
            self,
            action: #selector(inquiryButtonDidTap),
            for: .touchUpInside
        )
    }
    
    override func bindViewModel() {
        viewModel.output.artists
            .receive(on: DispatchQueue.main)
            .sink { [weak self] groups in
                self?.groups = groups
                self?.rootView.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.onboardingSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.onFavoriteUpdated?()
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.output.onboardingFailure
            .receive(on: DispatchQueue.main)
            .sink { error in
                PotiLogger.error(error)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @objc private func doneButtonDidTap() {
        guard selectedGroupId != nil else { return }
        viewModel.action(.submitWithArtist)
    }

    @objc private func inquiryButtonDidTap() {
        guard let url = URL(string: "https://poti-support.notion.site/850909fac41b83d2b15401dc19d5c1ef?pvs=105") else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - UICollectionViewDataSource

extension MyPageFavoriteIdolGroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        groups.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: IdolGroupCell.identifier,
            for: indexPath
        ) as? IdolGroupCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: groups[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MyPageFavoriteIdolGroupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGroup = groups[indexPath.item]
        selectedGroupId = selectedGroup.id
        viewModel.action(.artistSelected(selectedGroup.id))
        rootView.updateDoneButton(isEnabled: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyPageFavoriteIdolGroupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 90, height: 114)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        16
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        28.5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 24, bottom: 16, right: 24)
    }
}
