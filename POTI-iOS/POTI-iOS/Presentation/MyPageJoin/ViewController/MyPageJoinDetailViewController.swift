//
//  MyPageJoinDetailViewController.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//


// 참여

import UIKit

import SnapKit
import Then

class MyPageJoinDetailViewController: BaseViewController<MyPageJoinViewModel>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        let status = viewModel.participantOrderStatus ?? .recruiting
        print("네비 바 작동 확인 \(status)")
        
        switch status {
        case .completed:
            return .backDefault("종료된 분철")
        default:
            return .backDefault("진행 중인 분철")
        }
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let completeButton = PotiBottomButton()
    private var tableViewBottomConstraint: Constraint?
    private var viewState: JoinDetailViewState?
    private var didSubmitDeposit: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
        updateCompleteButton()
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
            $0.allowsSelection = false
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .potiWhite
        }
    }
    
    private func setCompleteButton() {
        completeButton.color = .secondaryMain
        completeButton.isDisabled = false
        completeButton.isHidden = true
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
    }
    
    private func updateCompleteButton() {
        guard let model = viewModel.joinModel else { return }
        let status = model.postStatus
        let depositStatus = model.paymentInfo.depositStatus
        
        
        switch status {
        case .recruitCompleted:
                // 로컬 변수인 didSubmitDeposit은 무시하고, 서버 상태가 waiting일 때만 버튼 노출
                if depositStatus == .waiting {
                    completeButton.isHidden = false
                    completeButton.text = "입금 완료했어요"
                    tableViewBottomConstraint?.update(inset: 94)
                } else {
                    // '입금 확인중'이나 '입금 완료' 상태면 버튼을 완전히 제거
                    completeButton.isHidden = true
                    tableViewBottomConstraint?.update(inset: 0)
                }
            
        case .shipping:
            didSubmitDeposit = false
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
        switch viewModel.participantOrderStatus {
        case .recruitCompleted:
            presentDetailBottomSheet()
        case .shipping:
            completeButtonTapped()
        default:
            break
        }
    }
    
    private func presentDetailBottomSheet() {
        let sheet = DetailBottomSheet(
            viewModel: BottomSheetViewModel(),
            firstTitle: "입금자명",
            firstPlaceholder: "입금자명을 입력해주세요",
            secondTitle: "입금 시간",
            secondPlaceholder: "YY-MM-DD TT:MM",
            confirmButtonText: "완료"
        )
        
        sheet.onSubmit = { [weak self] depositorName, depositedAt in
            guard let self else { return }
            
            guard let currentId = self.viewModel.joinModel?.participationId else { return }
            
            self.didSubmitDeposit = true // 버튼 UI 제어용
            
            self.viewModel.action(
                .submitDeposit(
                    participationId: currentId,
                    depositorName: depositorName,
                    depositedAt: depositedAt
                )
            )
        }
        
        sheet.show(in: self.navigationController?.view ?? view)
    }
    
    private func completeButtonTapped() {
        let orderId = 1100
        let alert = CustomAlertView(
            title: "잠깐! 정말 상품을 수령했나요?",
            message: "거래가 종료되면 되돌릴 수 없어요",
            cancelTitle: "이전",
            confirmTitle: "배송 완료",
            onLeftButton: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            onRightButton: { [weak self] in
                guard let self else { return }
                
                guard let yourPageModel = self.viewModel.yourPageModel else { return }
                let nickname = yourPageModel.nickname
                let avgRating = yourPageModel.ratingAverage
                let starRating = StarRatingPopupView(
                    onCompleteButton: { [weak self] rating in
                        guard let self else { return }
                        self.viewModel.action(.completeReview(transactionId: orderId, rating: Int(rating)))
                    },
                    onSkipButton: { [weak self] in
                        guard let self else { return }
                        self.viewModel.action(.completeDelivery(participantId: orderId))
                    }
                )
                starRating.show(on: self.navigationController?.view ?? self.view)
            }
        )
        alert.show(on: navigationController?.view ?? view)
    }
    
    override func setDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func bindViewModel() {
        viewModel.output.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.viewState = state
                self?.updateCompleteButton()
                
                self?.navigationController?.setNavigationBarHidden(true, animated: false)
                self?.navigationController?.setNavigationBarHidden(false, animated: false)
                
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.updateCompleteButton()
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.naviPotInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] id in
                let factory = DefaultViewControllerFactory()
                let containerVC = factory.makePotDetailViewController(postId: id)
                self?.navigationController?.pushViewController(containerVC, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.output.submitDepositResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.updateCompleteButton()
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.completeDeliveryResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.updateCompleteButton()
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.completeReviewResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.updateCompleteButton()
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
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
            switch viewModel.participantOrderStatus {
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
            if let potInfo = viewState?.potInfo {
                cell.configure(model: potInfo)
            }
            cell.onTapPotButton = { [weak self] in
                self?.viewModel.action(.tapPotInfo)
            }
            return cell
            
        case .progress:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: JoinProgressStatusViewCell.identifier,
                for: indexPath
            ) as? JoinProgressStatusViewCell else { return UITableViewCell() }
            if let model = viewState?.progress {
                cell.configure(model: model)
            }
            
            return cell
            
        case .myJoinDepositInfo:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MyJoinDepositInfoCell.identifier,
                for: indexPath
            ) as? MyJoinDepositInfoCell else { return UITableViewCell() }
            if let state = viewState?.myJoinDepositInfo {
                cell.configure(state: state)
            }
            return cell
            
        case .statusInfo:
            let status = viewModel.participantOrderStatus ?? .recruiting
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
