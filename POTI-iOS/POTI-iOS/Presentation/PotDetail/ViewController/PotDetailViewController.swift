//
//  PotDetailViewController.swift
//  POTI-iOS
//

import UIKit

final class PotDetailViewController: BaseViewController<PotDetailViewModel>, NavigationConfigurable {
    func navigationStyle() -> PotiNavigationStyle {
        return .backDefault("포티타임의 팟")
    }
    
    private let rootView = PotDetailView()
    private let factory: ViewControllerFactory
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
        self.definesPresentationContext = true
    }
    
    init(viewModel: PotDetailViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setDelegate() {
        rootView.potDetailCollectionView.delegate = self
        rootView.potDetailCollectionView.dataSource = self
        rootView.joinButton.addTarget(self, action: #selector(joinButtonDidTap), for: .touchUpInside)
    }
    
    override func bindViewModel() {
        viewModel.output.reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                
                if let nickname = self.viewModel.potDetailModel?.uploader.nickname {
                    self.title = "\(nickname)의 팟"
                }
                self.rootView.potDetailCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.isJoinButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                guard let self = self else { return }
                self.rootView.joinButton.isDisabled = !isEnabled
                self.rootView.joinButton.color = isEnabled ? .primaryMain : .deactiveMain
                let buttonTitle = isEnabled ? "분철팟 참여하기" : "마감된 분철팟이에요"
                self.rootView.joinButton.setTitle(buttonTitle, for: .normal)
            }
            .store(in: &cancellables)
    }
    
    @objc private func joinButtonDidTap() {
        let optionsSheetVC = factory.makePotOptionsSheetViewController(postId: viewModel.postId)
        optionsSheetVC.modalPresentationStyle = .overFullScreen

        optionsSheetVC.onContinue = { [weak self] shippingId, orderItems in
            guard let self = self else { return }

            let orderVC = self.factory.makePotOrderViewController(
                postId: self.viewModel.postId,
                shippingId: shippingId,
                orderItems: orderItems
            )
            self.navigationController?.pushViewController(orderVC, animated: true)
        }
        self.present(optionsSheetVC, animated: false)
    }

}

// MARK: - UICollectionViewDataSource

extension PotDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return PotDetailSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = PotDetailSection(rawValue: section) else { return 0 }
        switch sectionType {
        case .imageBanner: return viewModel.potDetailModel?.images.count ?? 3
        case .potInfo, .uploader: return viewModel.potDetailModel == nil ? 0 : 1
        case .participants: return viewModel.displayParticipants.isEmpty ? 1 : viewModel.displayParticipants.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = PotDetailSection(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch sectionType {
        case .imageBanner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailBannerCell.identifier, for: indexPath) as! DetailBannerCell
            cell.configure(with: viewModel.potDetailModel?.images[indexPath.item])
            return cell
        case .potInfo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailInfoCell.identifier, for: indexPath) as! DetailInfoCell
            if let model = viewModel.potDetailModel { cell.configure(with: model) }
            return cell
        case .uploader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailUploaderCell.identifier, for: indexPath) as! DetailUploaderCell
            if let model = viewModel.potDetailModel?.uploader { cell.configure(with: model) }
            return cell
        case .participants:
            if viewModel.displayParticipants.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailEmptyCell.identifier, for: indexPath) as! DetailEmptyCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailParticipantsCell.identifier, for: indexPath) as! DetailParticipantsCell
                let displayData = viewModel.displayParticipants[indexPath.item]
                cell.configure(displayData)
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let sectionType = PotDetailSection(rawValue: indexPath.section),
                  sectionType == .participants else {
                return UICollectionReusableView()
            }
            
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DetailParticipantsHeaderView.identifier,
                for: indexPath
            ) as! DetailParticipantsHeaderView
            
            header.configure(currentCount: viewModel.potDetailModel?.currentCount ?? 0, totalCount: viewModel.potDetailModel?.totalCount ?? 0)
            return header
        }
        
        else if kind == UICollectionView.elementKindSectionFooter {
            guard let sectionType = PotDetailSection(rawValue: indexPath.section),
                  sectionType == .participants else {
                return UICollectionReusableView()
            }
            
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DetailSubContentFooterView.identifier,
                for: indexPath
            ) as! DetailSubContentFooterView
            return footer
        }
        
        return UICollectionReusableView()
    }
}

extension PotDetailViewController: UICollectionViewDelegate {
}

