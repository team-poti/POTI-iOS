//
//  ParticipantListTableViewController.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit
import Combine

import SnapKit
import Then

final class ParticipantListTableViewController: BaseViewController<ParticipantManageViewModel> {
    
    //MARK: - UI Component

    private let tableView = UITableView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        fetchParticipants()
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
            $0.register(ParticipantManageSummaryCell.self, forCellReuseIdentifier: ParticipantManageSummaryCell.identifier)
            $0.register(ParticipantManageInfoCell.self, forCellReuseIdentifier: ParticipantManageInfoCell.identifier)
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.allowsSelection = false
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 210
            $0.sectionHeaderTopPadding = 0
            $0.backgroundColor = .potiWhite
            $0.sectionFooterHeight = 0
            $0.sectionHeaderHeight = 0
            $0.tableFooterView = {
                // ✅ 스티키가 싫으면 section footer가 아니라 tableFooterView를 사용
                let hairline = 1.0 / UIScreen.main.scale
                let footerDivider = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: hairline))
                footerDivider.backgroundColor = UIColor.systemGray4
                return footerDivider
            }()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let footer = tableView.tableFooterView else { return }
        var frame = footer.frame
        let targetWidth = tableView.bounds.width
        if frame.width != targetWidth {
            frame.size.width = targetWidth
            footer.frame = frame
            tableView.tableFooterView = footer
        }
    }
    
    override func setDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func bindViewModel() {
        viewModel.output.toggleButtonTapped
            .receive(on: DispatchQueue.main)
            .sink { [weak self] section in
                self?.toggleParticipantSection(section)
            }
            .store(in: &cancellables)
    }
}

extension ParticipantListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.participants.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        // section당 row0(요약)은 항상 띄우기, row1(상세)은 펼침일 때만
        return viewModel.expandedSections.contains(section) ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if indexPath.row == 0 { return 64 }
        return UITableView.automaticDimension
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let participants = viewModel.participants
        guard participants.indices.contains(indexPath.section) else {
            return UITableViewCell()
        }
        let participant = participants[indexPath.section]
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ParticipantManageSummaryCell.identifier,
                for: indexPath
            ) as? ParticipantManageSummaryCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            let isExpanded = viewModel.expandedSections.contains(indexPath.section)
            cell.configure(model: participant, isExpanded: isExpanded)
            cell.onTapToggle = { [weak self] in
                self?.viewModel.action(.toggleButtonTap(section: indexPath.section))
            }
            if isExpanded {
                cell.separatorInset = UIEdgeInsets(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    right: .greatestFiniteMagnitude
                )
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ParticipantManageInfoCell.identifier,
                for: indexPath) as? ParticipantManageInfoCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.configure(model: participant)
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 0,
                right: .greatestFiniteMagnitude
            )
            return cell
        }
    }
    
    private func toggleParticipantSection(_ section: Int) {
        let isExpanded = viewModel.expandedSections.contains(section)
        
        tableView.performBatchUpdates({
            if isExpanded {
                // 방금 '펼쳐진' 상태라면 상세 row를 추가
                tableView.insertRows(at: [IndexPath(row: 1, section: section)], with: .automatic)
            } else {
                // 방금 '접힌' 상태라면 상세 row를 삭제
                tableView.deleteRows(at: [IndexPath(row: 1, section: section)], with: .automatic)
            }
        }, completion: { [weak self] _ in
            guard let self else { return }
            // 요약 셀(화살표/텍스트 등)이 펼침 상태에 따라 바뀌면 갱신
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .none)

            // footer divider(마지막 섹션)도 필요 시 갱신
            let lastSection = max(self.numberOfSections(in: self.tableView) - 1, 0)
            self.tableView.reloadSections(IndexSet(integer: lastSection), with: .none)
        })
    }
    
}

extension ParticipantListTableViewController {
    private func fetchParticipants() {
        let mockParticipants: [ParticipantManageModel] = [
            ParticipantManageModel(
                purchaseId: 103,
                profileImage: "",
                nickname: "안유진사랑해",
                memberTitle: ["리즈"],
                participantstatus: .waitPay,
                memberRows: [
                    .init(name: "리즈", price: 3500)
                ],
                shippingText: "준등기",
                shippingPrice: 1500,
                totalPrice: 7500,
                waitPayCheckInfo: nil,
                paidInfo: nil,
                shipInfo: nil,
                completedInfo: nil
            ),
            ParticipantManageModel(
                purchaseId: 101,
                profileImage: "",
                nickname: "참여자2",
                memberTitle: ["레이", "이서"],
                participantstatus: .waitPayCheck,
                memberRows: [
                    .init(name: "레이", price: 3500),
                    .init(name: "이서", price: 3500)
                ],
                shippingText: "준등기",
                shippingPrice: 1500,
                totalPrice: 9000,
                waitPayCheckInfo: .init(
                    depositorName: "이포티",
                    depositTimeText: "2025-12-30 02:50"
                ),
                paidInfo: ParticipantManageModel.PaidInfo(
                    depositorName: "짱나연",
                    depositTimeText: "2026-01-15 22:56:00"
                ),
                shipInfo: nil,
                completedInfo: nil
            )
        ]

        viewModel.setParticipants(mockParticipants)
        tableView.reloadData()
    }
}


#Preview {
    ParticipantListTableViewController(viewModel: ParticipantManageViewModel())
}
