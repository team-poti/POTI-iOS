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

final class ParticipantListTableViewController: BaseViewController<ParticipantManageViewModel>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        return .backDefault("참여자 관리")
    }
    
    // MARK: - UI
    
    private let tableView = UITableView()
    private var lastSectionCount: Int = 0

    // 송장번호 입력 bottom sheet를 잡아두었다가 PATCH 성공 시 닫기
    private var trackingNumberSheet: DetailBottomSheet?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
        lastSectionCount = viewModel.participants.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? PotiTabBar {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? PotiTabBar {
            tabBarController.tabBar.isHidden = false
        }
    }
    
    override func setUI() {
        view.addSubview(tableView)
        setStyle()
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
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
                guard let self else { return }
                self.lastSectionCount = self.viewModel.participants.count
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
                print("✅ [VC] trackingNumber patched success, refreshing list")
                self.trackingNumberSheet?.dismiss()
                self.trackingNumberSheet = nil
                self.viewModel.action(.viewDidLoad)
            }
            .store(in: &cancellables)
    }
    
    private func completeButtonTapped(orderId: Int) {
        let alert = CustomAlertView(
            title: "잠깐! 정말 입금이 완료되었나요?",
            message: "확인 후에는 되돌릴 수 없어요",
            cancelTitle: "이전",
            confirmTitle: "입금 확인",
            onLeftButton: { [weak self] in
                self?.dismiss(animated: true)
            },
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
        print("✅ [VC] presentTrackingNumberBottomSheet, orderId:", orderId)
        let sheet = DetailBottomSheet(
            viewModel: BottomSheetViewModel(),
            firstTitle: "배송업체",
            firstPlaceholder: "배송업체를 선택해주세요",
            secondTitle: "송장번호",
            secondPlaceholder: "송장번호를 입력해주세요",
            confirmButtonText: "완료"
        )

        // sheet를 잡아두었다가 PATCH 성공 시 닫기
        self.trackingNumberSheet = sheet

        // 입력 완료 → PATCH 실행
        sheet.onSubmit = { [weak self] carrier, trackingNumber in
            print("✅ [Sheet] submit tapped",
                  "orderId:", orderId,
                  "carrier:", carrier,
                  "trackingNumber:", trackingNumber)

            self?.viewModel.action(
                .patchTrackingNumber(orderId: orderId, carrier: carrier, trackingNumber: trackingNumber)
            )
        }

        sheet.show(in: self.navigationController?.view ?? view)
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
            print("✅ [UI] confirmShip tapped, orderId:", orderId)
            self?.viewModel.action(.confirmShip(orderId: orderId))
        }
        
        return cell
    }
}
