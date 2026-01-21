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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
    }
    
    override func setUI() {
        view.addSubview(tableView)
        setTableView()
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
            $0.register(MyJoinDepositInfoCell.self)
            $0.register(RecruitingCell.self)
            $0.register(RecruitCompletedCell.self)
            $0.register(DepositCompletedCell.self)
            $0.register(ShippingCell.self)
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    override func setDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func presentDetailBottomSheet() {
        let sheet = DetailBottomSheet(
            firstTitle: "입금자명",
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
                cell.onTapConfirmButton = { [weak self] in
                    self?.presentDetailBottomSheet()
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
