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
    
    private let tableView = UITableView()
    private var participants: [MyPageJoinModel] = []
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            $0.showsVerticalScrollIndicator = false
            $0.sectionHeaderTopPadding = 0
        }
    }
    
    override func bindViewModel() {
        viewModel.output.joinItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                guard let self else { return }
                self.participants = items
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.naviPotInfo
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    let factory = DefaultViewControllerFactory()
                    let containerVC = factory.makeParticipantManageViewController()
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
            let count = participants.count
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
            return cell
            
        case .participantInfo:
            let count = participants.count
            
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
            let isLastRow = indexPath.row == participants.count - 1
            cell.separatorInset = isLastRow
            ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            : UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            let item = participants[indexPath.row]
            cell.configure(model: .mockStartShip)
            return cell
        }
    }
    
    //header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section) else { return nil }
        
        switch section {
        case .participantInfo:
            let headerView = ParticipantManageHeaderView()
            let count = participants.count
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
