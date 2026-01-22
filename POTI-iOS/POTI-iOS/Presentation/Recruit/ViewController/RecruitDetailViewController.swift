//
//  RecruitDetailViewController.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
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
    
    private let tableView = UITableView()
    private let backgroundView = UIView()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
    }
    
    override func setUI() {
        setTableView()
        view.addSubviews(tableView, backgroundView)
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
        }
        backgroundView.do {
            $0.backgroundColor = .potiWhite
        }
    }
    
    override func bindViewModel() {
        viewModel.output.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                self.viewState = state
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.naviPotInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                let factory = DefaultViewControllerFactory()
                let containerVC = factory.makePotDetailViewController(postId: 1) // 수정하기(마지막 0122)
                self?.navigationController?.pushViewController(containerVC, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.output.naviManageInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                let factory = DefaultViewControllerFactory()
                let containerVC = factory.makeParticipantManageViewController()
                self?.navigationController?.pushViewController(containerVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    override func setDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
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
            return 216
        case .participantInfo:
            return 165
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
    
    //header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section) else { return nil }
        
        switch section {
        case .participantInfo:
            let headerView = ParticipantManageHeaderView()
            let count = viewState?.participants.count ?? 0
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
            return 60
        default:
            return 0
        }
    }
}
