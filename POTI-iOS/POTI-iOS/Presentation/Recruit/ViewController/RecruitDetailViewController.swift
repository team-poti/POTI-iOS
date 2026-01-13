//
//  RecruitDetailViewController.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import SnapKit
import Then

enum Section: Int, CaseIterable {
    case recruitInfo
    case progress
    case members
}

class RecruitDetailViewController: BaseViewController<RecruitDetailViewModel> {


    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    override func setUI() {
            view.addSubview(tableView)
        }
    
    override func setLayout() {
            tableView.snp.makeConstraints {
                $0.edges.equalTo(view.safeAreaLayoutGuide)
            }
        }
    
    private func setTableView() {
            tableView.do {
                $0.register(PotInfoCell.self, forCellReuseIdentifier: PotInfoCell.identifier)
                $0.register(ProgressStatusViewCell.self, forCellReuseIdentifier: ProgressStatusViewCell.identifier)
                // TODO: 다른 셀 완성하면 여기서 register 해주기
                // $0.register(ProgressCell.self, forCellReuseIdentifier: ProgressCell.id)
                // $0.register(RecruitMemberHeaderCell.self, forCellReuseIdentifier: RecruitMemberHeaderCell.id)
                // $0.register(RecruitMemberCell.self, forCellReuseIdentifier: RecruitMemberCell.id)
                $0.dataSource = self
                $0.delegate = self
                $0.separatorStyle = .none
                $0.showsVerticalScrollIndicator = false
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
        case .members:
            // 예시: 멤버 헤더 1개 + 멤버 3명
            // TODO: - 서버 -> 멤버 인원 수 받으면 1 + n 넣기
            return 1 + 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 153
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
            return cell

        case .progress:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ProgressStatusViewCell.identifier,
                for: indexPath
            ) as? ProgressStatusViewCell else { return UITableViewCell() }
            return cell
        case .members:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "ProgressFallbackCell")
            cell.selectionStyle = .none
            cell.textLabel?.text = "Progress 영역 (임시 셀)"
            return cell
        }
    }
}
