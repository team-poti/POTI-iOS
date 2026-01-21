//
//  MyPageJoinDetailViewController.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import SnapKit
import Then

class MyPageJoinDetailViewController: BaseViewController<MyPageJoinViewModel>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        return .backDefault("진행 중인 분철")
    }
    
    private let tableView = UITableView()
    private let completeButton = PotiBottomButton()
    private var tableViewBottomConstraint: Constraint?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
        updateCompleteButton()
    }
    
    override func setUI() {
        view.addSubviews(tableView, completeButton)
        setTableView()
        setCompleteButton()
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            tableViewBottomConstraint = $0.bottom.equalToSuperview().constraint
        }
        completeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(38)
        }
    }
    
    private func setTableView() {
        tableView.do {
            $0.register(JoinPotInfoCell.self)
            $0.register(JoinProgressStatusViewCell.self)
            $0.register(MyJoinDepositInfoCell.self)
            $0.register(RecruitingCell.self)
            $0.register(RecruitCompletedCell.self)
            $0.register(DepositCompletedCell.self)
            $0.register(ShippingCell.self)
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
    }

    private func setCompleteButton() {
        completeButton.color = .secondaryMain
        completeButton.isDisabled = false
        completeButton.isHidden = true
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
    }

    private func updateCompleteButton() {
        guard let status = viewModel.participantStatus else {
            completeButton.isHidden = true
            tableViewBottomConstraint?.update(inset: 0)
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            return
        }

        switch status {
        case .recruitCompleted:
            completeButton.isHidden = false
            completeButton.text = "입금 완료했어요"
            tableViewBottomConstraint?.update(inset: 94)

        case .shipping:
            completeButton.isHidden = false
            completeButton.text = "배송을 받았어요"
            tableViewBottomConstraint?.update(inset: 94)

        default:
            completeButton.isHidden = true
            tableViewBottomConstraint?.update(inset: 0)
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func didTapCompleteButton() {
        presentDetailBottomSheet()
    }
    
    override func setDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func bindViewModel() {
        viewModel.output.naviPotInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                let factory = DefaultViewControllerFactory()
                let containerVC = factory.makePotDetailViewController(postId: 1)
                self?.navigationController?.pushViewController(containerVC, animated: true)
            }
            .store(in: &cancellables)
        viewModel.output.naviPotInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.updateCompleteButton()
            }
            .store(in: &cancellables)
    }
    
    private func presentDetailBottomSheet() {
        let sheet = DetailBottomSheet(
            viewModel: BottomSheetViewModel(), firstTitle: "입금자명",
            firstPlaceholder: "입금자명을 입력해주세요",
            secondTitle: "입금 시간",
            secondPlaceholder: "YY-MM-DD TT:MM",
            confirmButtonText: "완료"
        )
        sheet.show(in: self.view)
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
        guard let section = MyJoinSection(rawValue: section) else { return 0 }
        
        switch section {
        case .myJoinInfo:
            return 1
        case .progress:
            return 1
        case .myJoinDepositInfo:
            return 1
        case .statusInfo:
            return 1
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
        case .myJoinDepositInfo:
            return UITableView.automaticDimension
        case .statusInfo:
            switch viewModel.participantStatus {
            default:
                return UITableView.automaticDimension
            }
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
            if let model = viewModel.joinModel {
                cell.configure(model: model)
                cell.onTapPotButton = { [weak self] in
                    self?.viewModel.action(.tapPotInfo)
                }
            }
            return cell
            
        case .progress:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: JoinProgressStatusViewCell.identifier,
                for: indexPath
            ) as? JoinProgressStatusViewCell else { return UITableViewCell() }
            if let model = viewModel.progressStatusModel {
                cell.configure(model: model)
            }
            return cell
            
        case .myJoinDepositInfo:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MyJoinDepositInfoCell.identifier,
                for: indexPath
            ) as? MyJoinDepositInfoCell else { return UITableViewCell() }
            if let model = viewModel.joinModel {
                cell.configure(model: model)
            }
            return cell
            
        case .statusInfo:
            let status = viewModel.participantStatus ?? .recruiting
            updateCompleteButton()
            switch status {
            case .recruiting:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: RecruitingCell.identifier,
                    for: indexPath
                ) as? RecruitingCell else { return UITableViewCell() }
                if let model = viewModel.joinModel {
                    cell.configure(model: model)
                }
                return cell
            case .recruitCompleted:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: RecruitCompletedCell.identifier,
                    for: indexPath
                ) as? RecruitCompletedCell else { return UITableViewCell() }
                if let model = viewModel.joinModel {
                    cell.configure(model: model)
                }
                return cell
            case .depositCompleted:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: DepositCompletedCell.identifier,
                    for: indexPath
                ) as? DepositCompletedCell else { return UITableViewCell() }
                if let model = viewModel.joinModel {
                    cell.configure(model: model)
                }
                return cell
            case .shipping:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ShippingCell.identifier,
                    for: indexPath
                ) as? ShippingCell else { return UITableViewCell() }
                if let model = viewModel.joinModel {
                    cell.configure(model: model)
                }
                return cell
            case .completed:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: DepositCompletedCell.identifier,
                    for: indexPath
                ) as? DepositCompletedCell else { return UITableViewCell() }
                if let model = viewModel.joinModel {
                    cell.configure(model: model)
                }
                return cell
            }
        }
    }
}
