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
        viewModel.action(.viewDidLoad)
    }
    
    override func setUI() {
        view.addSubview(tableView)
        setStyle()
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    override func setDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func bindViewModel() {
        viewModel.output.fetchData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.toggleButtonTapped
            .receive(on: DispatchQueue.main)
            .sink { [weak self] section in
                self?.toggleParticipantSection(section)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - TableView Setting
    
    private func setStyle() {
        tableView.do {
            $0.register(
                ParticipantManageListCell.self,
                forCellReuseIdentifier: ParticipantManageListCell.identifier
            )
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.allowsSelection = false
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 240
            $0.backgroundColor = .potiWhite
        }
    }
    
    // MARK: - Action
    
    private func toggleParticipantSection(_ section: Int) {
        let indexPath = IndexPath(row: 0, section: section)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.25)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .linear))
        
        tableView.performBatchUpdates({
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }, completion: nil)
        
        CATransaction.commit()
    }
    
    // MARK: - BottomSheet
    
    private func presentDetailBottomSheet() {
        let sheet = DetailBottomSheet(
            firstTitle: "배송업체",
            firstPlaceholder: "배송업체를 선택해주세요",
            secondTitle: "송장번호",
            secondPlaceholder: "송장번호를 입력해주세요",
            confirmButtonText: "완료"
        )
        sheet.show(in: self.view)
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
