//
//  RecruitDetailViewController.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import SnapKit
import Then

class RecruitDetailViewController: BaseViewController<RecruitDetailViewModel> {
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray100
        setTableView()
    }
    
    override func setUI() {
        view.addSubview(tableView)
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setTableView() {
        tableView.do {
            $0.register(
                PotInfoCell.self,
                forCellReuseIdentifier: PotInfoCell.identifier
            )
            $0.register(
                ProgressStatusViewCell.self,
                forCellReuseIdentifier: ProgressStatusViewCell.identifier
            )
            $0.register(
                ParticipantManageViewCell.self,
                forCellReuseIdentifier: ParticipantManageViewCell.identifier
            )
            $0.dataSource = self
            $0.delegate = self
            $0.separatorStyle = .singleLine
            $0.showsVerticalScrollIndicator = false
            $0.sectionHeaderTopPadding = 0
        }
    }
}

extension RecruitDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .recruitInfo:
            return 1
        case .progress:
            return 1
        case .participantInfo:
            // TODO: - 서버 -> 멤버 인원 수 - 추후 수정 예정..
            return 3
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
            return cell

        case .progress:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ProgressStatusViewCell.identifier,
                for: indexPath
            ) as? ProgressStatusViewCell else { return UITableViewCell() }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell

        case .participantInfo:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ParticipantManageViewCell.identifier,
                for: indexPath
            ) as? ParticipantManageViewCell else { return UITableViewCell() }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            return cell
        }
    }
    
    //header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section) else { return nil }
        
        switch section {
        case .participantInfo:
            let headerView = ParticipantManageHeaderView()
            headerView.configure(count: 3) // TODO: - 수정 예정 participantCount
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
