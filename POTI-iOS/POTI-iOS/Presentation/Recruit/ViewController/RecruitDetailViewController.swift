//
//  RecruitDetailViewController.swift
//  POTI-iOS
//
//  Created by Neon on 1/13/26.
//


import UIKit

import Combine
import SnapKit
import Then

class RecruitDetailViewController: BaseViewController<RecruitDetailViewModel>, NavigationConfigurable {
    func navigationStyle() -> PotiNavigationStyle {
        return .backDefault("진행 중인 분철")
    }
    
    private enum Section: Int, CaseIterable {
        case recruitInfo
        case progress
        case participantInfo
    }
    
    private var viewState: RecruitDetailViewState?
    private let factory: ViewControllerFactory
    private let tableView = UITableView()

    init(
        viewModel: RecruitDetailViewModel,
        factory: ViewControllerFactory
    ) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        viewModel.action(.viewDidLoad)
    }
    
    override func setUI() {
        setTableView()
        view.addSubview(tableView)
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setTableView() {
        tableView.do {
            $0.register(PotInfoCell.self)
            $0.register(ProgressStatusViewCell.self)
            $0.register(ParticipantManageViewCell.self)
            $0.register(EmptyManageViewCell.self)
            $0.separatorStyle = .singleLine
            $0.allowsSelection = false
            $0.showsVerticalScrollIndicator = false
            $0.sectionHeaderTopPadding = 0
            $0.backgroundColor = .potiWhite
            $0.sectionFooterHeight = .leastNormalMagnitude
            $0.estimatedSectionHeaderHeight = 0
            $0.estimatedSectionFooterHeight = 0
            $0.contentInset.top = 12
            $0.verticalScrollIndicatorInsets.top = 12
        }
    }
    
    override func bindViewModel() {
        viewModel.output.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                self.viewState = state
                PotiNavigationBar.configure(
                    navigationItem: self.navigationItem,
                    navigationController: self.navigationController,
                    style: .backDefault(state.navigationTitle),
                    target: self
                )
                self.updateDeleteButton(isVisible: state.canDelete)
                self.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.output.postDeleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.output.naviPotInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] id in
                guard let self else { return }
                let containerVC = self.factory.makePotDetailViewController(postId: id)
                containerVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(containerVC, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.output.naviManageInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] id in
                guard let self else { return }
                let containerVC = self.factory.makeParticipantManageViewController(postId: id)
                containerVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(containerVC, animated: true)
            }
            .store(in: &cancellables)

        viewModel.output.showError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.presentErrorAlert(message: message)
            }
            .store(in: &cancellables)
    }
    
    override func setDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func presentErrorAlert(message: String) {
        guard presentedViewController == nil else { return }
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

    private func updateDeleteButton(isVisible: Bool) {
        guard isVisible else {
            navigationItem.rightBarButtonItem = nil
            return
        }

        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.setTitleColor(.gray800, for: .normal)
        deleteButton.titleLabel?.font = PotiFontManager.body14m.font
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.frame = CGRect(x: 0, y: 0, width: 48, height: 44)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteButton)
    }

    @objc private func deleteButtonTapped() {
        let alert = CustomAlertView(
            title: "모집글을 삭제할까요?",
            message: "삭제한 모집글은 복구할 수 없어요.",
            cancelTitle: "취소",
            confirmTitle: "삭제",
            onLeftButton: {},
            onRightButton: { [weak self] in
                self?.viewModel.action(.tapDelete)
            }
        )
        alert.show(on: navigationController?.view ?? view)
    }
}

extension RecruitDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .recruitInfo:
            return 1
        case .progress:
            return 1
        case .participantInfo:
            let count = viewState?.participants.count ?? 0
            return count == 0 ? 1 : count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableView.automaticDimension
        }
        
        switch section {
        case .recruitInfo:
            return 153
        case .progress:
            return 210
        case .participantInfo:
            return viewState?.participants.isEmpty == false ? 164 : 125
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .recruitInfo:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PotInfoCell.identifier,
                for: indexPath
            ) as? PotInfoCell else { return UITableViewCell() }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            if let potInfo = viewState?.potInfo {
                cell.configure(model: potInfo)
            }
            cell.onTapPotButton = { [weak self] in
                self?.viewModel.action(.tapPotInfo)
            }
            return cell
            
        case .progress:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ProgressStatusViewCell.identifier,
                for: indexPath
            ) as? ProgressStatusViewCell else { return UITableViewCell() }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            if let progressModel = viewState?.progress {
                cell.configure(model: progressModel)
            }
            return cell
            
        case .participantInfo:
            let count = viewState?.participants.count ?? 0
            
            if count == 0 {
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: EmptyManageViewCell.identifier,
                    for: indexPath
                ) as? EmptyManageViewCell else { return UITableViewCell() }
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                return cell
            }
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ParticipantManageViewCell.identifier,
                for: indexPath
            ) as? ParticipantManageViewCell else { return UITableViewCell() }
            
            guard let participant = viewState?.participants[indexPath.row] else {
                return cell
            }
            
            let isLastRow = indexPath.row == count - 1
            cell.separatorInset = isLastRow
            ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            : UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
            cell.configure(model: participant)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section) else { return nil }
        
        switch section {
        case .participantInfo:
            let headerView = ParticipantManageHeaderView()
            let count = viewState?.participantCount ?? 0
            headerView.configure(count: count)
            headerView.onTapHeaderButton = { [weak self] in
                self?.viewModel.action(.tapManageInfo)
            }
            return headerView
            
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .participantInfo:
            return 64
        default:
            return .leastNormalMagnitude
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
}
