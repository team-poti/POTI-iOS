//
//  PotDetailViewController.swift
//  POTI-iOS
//

import UIKit

final class PotDetailViewController: BaseViewController<PotDetailViewModel>, NavigationConfigurable {

    // MARK: - Properties

    private let rootView = PotDetailView()
    private let factory: ViewControllerFactory

    // MARK: - Life Cycle

    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
        self.definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? PotiTabBar {
            tabBarController.tabBar.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? PotiTabBar {
            tabBarController.tabBar.isHidden = true
        }
    }

    // MARK: - Initializer

    init(viewModel: PotDetailViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

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
                    let navigationStyle = PotiNavigationStyle.backDefault("\(nickname)의 팟")
                    PotiNavigationBar.configure(
                        navigationItem: self.navigationItem,
                        navigationController: self.navigationController,
                        style: navigationStyle,
                        target: self
                    )
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

    // MARK: - Method

    func navigationStyle() -> PotiNavigationStyle {
        return .backDefault("")
    }

    // MARK: - Action

    @objc private func joinButtonDidTap() {
        let optionsViewController = factory.makePotOptionsViewController(postId: viewModel.postId)
        optionsViewController.modalPresentationStyle = .overFullScreen

        optionsViewController.onContinue = { [weak self] result in
            guard let self = self else { return }

            let nickname = self.viewModel.potDetailModel?.uploader.nickname ?? ""

            let orderViewController = self.factory.makePotOrderViewController(
                postId: self.viewModel.postId, shippingId: result.shippingId, orderItems: result.orderItems,
                shippingInfo: result.shippingInfo, memberInfos: result.memberInfos, uploaderNickname: nickname)

            orderViewController.onSuccess = { [weak self] in
                self?.viewModel.action(.viewDidLoad)
            }

            self.navigationController?.pushViewController(orderViewController, animated: true)
        }

        present(optionsViewController, animated: false)
    }

    @objc private func yourProfileButtondidTap() {
        let yourProfileViewController = factory.makeYourPageViewController(userId: viewModel.potDetailModel?.uploader.userId ?? -1)
        self.navigationController?.pushViewController(yourProfileViewController, animated: true)
    }

    private func showShareBottomSheet() {
        guard viewModel.isShareContentReady,
              let model = viewModel.potDetailModel,
              let host = try? AppConfig.deepLinkHost(),
              let shareURL = makeShareURL(host: host) else { return }

        let content = ShareBottomSheetContent(image: model.images.first ?? "", artist: model.artist, title: model.title,
                                              description: model.content, participantCount: model.currentCount, totalCount: model.totalCount,
                                              availableMembers: viewModel.availableMembers, unavailableMembers: orderedUniqueMembers(from: model),
                                              host: "https://\(host)", potID: viewModel.postId, deepLink: shareURL)
        let viewController = ShareBottomSheetViewController(content: content)
        present(viewController, animated: false)
    }

    private func makeShareURL(host: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/pot/\(viewModel.postId)"
        return components.url
    }

    private func orderedUniqueMembers(from model: PotDetailModel) -> [String] {
        var seenMembers = Set<String>()
        return model.participants
            .flatMap(\.selectedMembers)
            .filter { seenMembers.insert($0).inserted }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension PotDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return PotDetailSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = PotDetailSection(rawValue: section) else { return 0 }
        switch sectionType {
        case .imageBanner: return viewModel.potDetailModel?.images.count ?? 3
        case .potInfo, .uploader: return viewModel.potDetailModel == nil ? 0 : 1
        case .participants: return viewModel.participants.isEmpty ? 1 : viewModel.participants.count
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

            if let model = viewModel.potDetailModel?.uploader {
                cell.configure(with: model, target: self, action: #selector(yourProfileButtondidTap))
            }
            return cell
        case .participants:
            if viewModel.participants.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailEmptyCell.identifier, for: indexPath) as! DetailEmptyCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailParticipantsCell.identifier, for: indexPath) as! DetailParticipantsCell

                let participantData = viewModel.participants[indexPath.item]
                cell.configure(model: participantData)
                return cell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let sectionType = PotDetailSection(rawValue: indexPath.section), sectionType == .participants else {
            return UICollectionReusableView()
        }

        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DetailParticipantsHeaderView.identifier, for: indexPath) as? DetailParticipantsHeaderView else {
                return UICollectionReusableView()
            }
            let currentCount = viewModel.potDetailModel?.currentCount ?? 0
            let totalCount = viewModel.potDetailModel?.totalCount ?? 0
            header.configure(currentCount: currentCount, totalCount: totalCount)
            return header
        }

        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DetailSubContentFooterView.identifier, for: indexPath) as! DetailSubContentFooterView
            footer.onShare = { [weak self] in
                self?.showShareBottomSheet()
            }
            return footer
        }

        return UICollectionReusableView()
    }
}
