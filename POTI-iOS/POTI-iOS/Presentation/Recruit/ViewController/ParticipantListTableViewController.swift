//
//  ParticipantListTableViewController.swift
//  POTI-iOS
//
//  Created by Neon on 1/13/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class ParticipantListTableViewController: BaseViewController<ParticipantManageViewModel>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        return .backDefault("참여자 관리")
    }
    
    // MARK: - UI
    
    private let tableView = UITableView()
    private let emptyLabel = UILabel().then {
        $0.text = "아직 참여자가 없어요"
        $0.font = PotiFontManager.body14m.font
        $0.textColor = .gray700
        $0.textAlignment = .center
        $0.isHidden = true
    }
    private var lastSectionCount: Int = 0
    
    private var trackingNumberSheet: DetailBottomSheet?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
        lastSectionCount = viewModel.participants.count
    }
    
    override func setUI() {
        view.addSubviews(tableView, emptyLabel)
        setStyle()
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        emptyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(52)
            $0.centerX.equalToSuperview()
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
                guard let self else { return }
                self.lastSectionCount = self.viewModel.participants.count
                self.emptyLabel.isHidden = !self.viewModel.participants.isEmpty
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.toggleButtonTapped
            .receive(on: DispatchQueue.main)
            .sink { [weak self] section in
                self?.toggleParticipantSection(section)
            }
            .store(in: &cancellables)
        
        viewModel.output.confirmDepositTriggered
            .receive(on: DispatchQueue.main)
            .sink { [weak self] orderId in
                self?.completeButtonTapped(orderId: orderId)
            }
            .store(in: &cancellables)
        
        viewModel.output.confirmShipTriggered
            .receive(on: DispatchQueue.main)
            .sink { [weak self] orderId in
                self?.presentTrackingNumberBottomSheet(orderId: orderId)
            }
            .store(in: &cancellables)
        
        viewModel.output.trackingNumberPatched
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.trackingNumberSheet?.dismiss()
                self.trackingNumberSheet = nil
            }
            .store(in: &cancellables)

        viewModel.output.showError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.trackingNumberSheet?.submissionDidFail()
                self?.presentErrorAlert(message: message)
            }
            .store(in: &cancellables)
    }
    
    private func completeButtonTapped(orderId: Int) {
        let alert = CustomAlertView(
            title: "잠깐! 정말 입금이 완료되었나요?",
            message: "확인 후에는 되돌릴 수 없어요",
            cancelTitle: "이전",
            confirmTitle: "입금 확인",
            onLeftButton: {},
            onRightButton: { [weak self] in
                self?.viewModel.action(.confirmDeposit(orderId: orderId))
            }
        )
        alert.show(on: navigationController?.view ?? view)
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
        let currentCount = viewModel.participants.count
        guard currentCount == lastSectionCount, section < currentCount else {
            lastSectionCount = currentCount
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.25)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .linear))
            tableView.reloadData()
            CATransaction.commit()
            return
        }
        
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
    
    private func presentTrackingNumberBottomSheet(orderId: Int) {
        let sheet = DetailBottomSheet(
            viewModel: BottomSheetViewModel(),
            firstTitle: "배송업체",
            firstPlaceholder: "배송업체를 선택해주세요",
            secondTitle: "송장번호",
            secondPlaceholder: "송장번호를 입력해주세요",
            confirmButtonText: "완료",
            dismissesOnSubmit: false
        )
        
        self.trackingNumberSheet = sheet

        sheet.onSubmit = { [weak self] carrier, trackingNumber in
            
            self?.viewModel.action(
                .patchTrackingNumber(orderId: orderId, carrier: carrier, trackingNumber: trackingNumber)
            )
        }
        
        sheet.show(in: self.navigationController?.view ?? view)
    }

    private func presentErrorAlert(message: String) {
        guard presentedViewController == nil else { return }
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
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
        
        // 입금 확인 버튼
        cell.onTapConfirmDeposit = { [weak self] orderId in
            self?.completeButtonTapped(orderId: orderId)
        }
        
        // 송장번호 입력
        cell.onTapConfirmShip = { [weak self] orderId in
            self?.viewModel.action(.confirmShip(orderId: orderId))
        }
        
        return cell
    }
}
