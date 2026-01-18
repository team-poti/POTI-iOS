//
//  MyPageJoinDetailViewController.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import SnapKit
import Then

class MyPageJoinDetailViewController: BaseViewController<MyPageJoinViewModel> {
    
    private let tableView = UITableView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            $0.register(JoinPotInfoCell.self)
            $0.register(JoinProgressStatusViewCell.self)
            $0.register(ParticipantManageViewCell.self)
            $0.separatorStyle = .singleLine
            $0.showsVerticalScrollIndicator = false
            $0.sectionHeaderTopPadding = 0
        }
    }
    
    override func setDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension MyPageJoinDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MyJoinSection.allCases.count
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
            // TODO: - 서버 -> 멤버 인원 수 - 추후 수정 예정..
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = MyJoinSection(rawValue: indexPath.section) else {
            return UITableView.automaticDimension
        }
        
        switch section {
        case .myJoinInfo:
            return 153
        case .progress:
            return 216
        case .myJoinStatusInfo:
            return 165
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let section = MyJoinSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .myJoinInfo:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: JoinPotInfoCell.identifier,
                for: indexPath
            ) as? JoinPotInfoCell else { return UITableViewCell() }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
            
        case .progress:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: JoinProgressStatusViewCell.identifier,
                for: indexPath
            ) as? JoinProgressStatusViewCell else { return UITableViewCell() }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
            
        case .myJoinStatusInfo:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ParticipantManageViewCell.identifier,
                for: indexPath
            ) as? ParticipantManageViewCell else { return UITableViewCell() }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            return cell
        }
    }
}
