//
//  PotOrderViewController.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class PotOrderViewController: BaseViewController<PotOrderViewModel>, NavigationConfigurable {
    
    // MARK: - Properties
    
    private let rootView = PotOrderView()
    private let factory: ViewControllerFactory
    
    // MARK: - Initializer
    
    init(viewModel: PotOrderViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
    }
    
    // MARK: - Custom Methods
    
    override func addTarget() {
        rootView.orderContentView.nameField.textPublisher
            .sink { [weak self] in self?.viewModel.action(.nameDidChange($0)) }
            .store(in: &cancellables)
        
        rootView.orderContentView.zipcodeField.textPublisher
            .sink { [weak self] in self?.viewModel.action(.zipcodeDidChange($0)) }
            .store(in: &cancellables)
        
        rootView.orderContentView.addressField.textPublisher
            .sink { [weak self] in self?.viewModel.action(.addressDidChange($0)) }
            .store(in: &cancellables)
        
        rootView.orderContentView.phoneField.textPublisher
            .sink { [weak self] in self?.viewModel.action(.phoneDidChange($0)) }
            .store(in: &cancellables)
        
        rootView.bottomButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
    }
    
    override func bindViewModel() {
        viewModel.output.nickname
            .receive(on: RunLoop.main)
            .sink { [weak self] nickname in
                guard let self = self else { return }
                self.title = "\(nickname)의 팟"
            }
            .store(in: &cancellables)
        
        viewModel.output.orderHeaderData
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                self?.rootView.headerView.configure(items: data.items, totalAmount: data.total)
            }
            .store(in: &cancellables)
        
        viewModel.output.isButtonEnabled
            .receive(on: RunLoop.main)
            .map { !$0 }
            .assign(to: \.isDisabled, on: rootView.bottomButton)
            .store(in: &cancellables)
        
        viewModel.output.nameError
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                if let msg = message {
                    self.rootView.orderContentView.nameField.apply(state: .error(msg))
                } else {
                    self.rootView.orderContentView.nameField.apply(state: .normal)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.zipcodeError
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                if let msg = message {
                    self.rootView.orderContentView.zipcodeField.apply(state: .error(msg))
                } else {
                    self.rootView.orderContentView.zipcodeField.apply(state: .normal)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.addressError
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                if let msg = message {
                    self.rootView.orderContentView.addressField.apply(state: .error(msg))
                } else {
                    self.rootView.orderContentView.addressField.apply(state: .normal)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.phoneError
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                if let msg = message {
                    self.rootView.orderContentView.phoneField.apply(state: .error(msg))
                } else {
                    self.rootView.orderContentView.phoneField.apply(state: .normal)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.orderResult
            .receive(on: RunLoop.main)
            .sink { [weak self] isSuccess in
                guard let self = self else { return }
                
                if isSuccess {
                    let completeView = OrderCompleteView()
                    completeView.completionHandler = { [weak self] in
                        guard let self = self else { return }
                        
                        if let nav = self.navigationController {
                            if let detailVC = nav.viewControllers.first(where: { $0 is PotDetailViewController }) {
                                nav.popToViewController(detailVC, animated: true)
                            } else {
                                self.dismiss(animated: true)
                            }
                        } else {
                            self.dismiss(animated: true)
                        }
                    }
                    completeView.show(in: self.view)
                    self.view.endEditing(true)
                } else {
                    print("참여 실패")
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Method
    
    func navigationStyle() -> PotiNavigationStyle {
        return .backDefault("팟")
    }
    
    // MARK: - Action
    
    @objc private func joinButtonTapped() {
        viewModel.action(.joinButtonDidTap)
    }
}
