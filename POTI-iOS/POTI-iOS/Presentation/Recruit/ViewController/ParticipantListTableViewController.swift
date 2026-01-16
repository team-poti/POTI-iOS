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

    // MARK: - UI
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
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
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

    // MARK: - TableView Setting
    private func setTableView() {
        tableView.do {
            $0.register(
                ParticipantManageListCell.self,
                forCellReuseIdentifier: ParticipantManageListCell.identifier
            )
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.allowsSelection = false
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 210
            $0.backgroundColor = .potiWhite
        }
    }

    // MARK: - Action
    
    private func toggleParticipantSection(_ section: Int) {
        let indexPath = IndexPath(row: 0, section: section)

        CATransaction.begin()
        CATransaction.setAnimationDuration(0.25)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))

        tableView.performBatchUpdates({
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }, completion: nil)

        CATransaction.commit()
    }
}

// MARK: - UITableViewDataSource / Delegate
extension ParticipantListTableViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.participants.count
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let participant = viewModel.participants[indexPath.section]

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ParticipantManageListCell.identifier,
            for: indexPath
        ) as? ParticipantManageListCell else {
            return UITableViewCell()
        }

        let isExpanded = viewModel.expandedSections.contains(indexPath.section)
        let isLast = indexPath.section == viewModel.participants.count - 1
        cell.configure(model: participant, isExpanded: isExpanded, isLast: isLast)
        
        cell.onTapToggle = { [weak self] in
            self?.viewModel.action(.toggleButtonTap(section: indexPath.section))
        }

        return cell
    }
}

// MARK: - Mock Data
extension ParticipantListTableViewController {

    private func fetchParticipants() {
        let mockParticipants: [ParticipantManageModel] = [
            ParticipantManageModel(
                purchaseId: 103,
                profileImage: "https://search.pstatic.net/sunny/?src=https%3A%2F%2Fi.namu.wiki%2Fi%2FAOYM4U-MUrY0Cd4aUFErnt5ksb7Cq1F-9bQrNaIkja7WrA49tHATd_xL6tMpa9C6pKq7IYmQ-taBQtU7WoF_Sg.webp&type=a340",
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
                shipInfo: nil
            ),
            ParticipantManageModel(
                purchaseId: 101,
                profileImage: "https://search.pstatic.net/sunny/?src=https%3A%2F%2Fi.namu.wiki%2Fi%2FAOYM4U-MUrY0Cd4aUFErnt5ksb7Cq1F-9bQrNaIkja7WrA49tHATd_xL6tMpa9C6pKq7IYmQ-taBQtU7WoF_Sg.webp&type=a340",
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
                shipInfo: nil
            ),
            ParticipantManageModel(
                purchaseId: 101,
                profileImage: "https://search.pstatic.net/sunny/?src=https%3A%2F%2Fi.namu.wiki%2Fi%2FAOYM4U-MUrY0Cd4aUFErnt5ksb7Cq1F-9bQrNaIkja7WrA49tHATd_xL6tMpa9C6pKq7IYmQ-taBQtU7WoF_Sg.webp&type=a340",
                nickname: "참여자2",
                memberTitle: ["레이", "이서"],
                participantstatus: .paid,
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
                shipInfo: nil
            )
        ]

        viewModel.setParticipants(mockParticipants)
        tableView.reloadData()
    }
}

#Preview {
    ParticipantListTableViewController(
        viewModel: ParticipantManageViewModel()
    )
}
