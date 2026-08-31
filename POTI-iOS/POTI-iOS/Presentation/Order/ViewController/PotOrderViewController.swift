//
//  PotOrderViewController.swift
//  POTI-iOS
//
//  Created by soomin on 1/21/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class PotOrderViewController: BaseViewController<PotOrderViewModel>, NavigationConfigurable {
    
    // MARK: - Properties
    
    private let rootView = PotOrderView()
    private let factory: ViewControllerFactory
    var onSuccess: (() -> Void)?
    
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
        
        rootView.orderContentView.zipcodeField.onTap = { [weak self] in
            self?.showAddressSearch()
        }
        
        rootView.orderContentView.addressField.onTap = { [weak self] in
            self?.showAddressSearch()
        }

        rootView.orderContentView.detailAddressField.textPublisher
            .sink { [weak self] in self?.viewModel.action(.detailAddressDidChange($0)) }
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
                
                let navigationStyle = PotiNavigationStyle.backDefault("\(nickname)의 팟")
                PotiNavigationBar.configure(navigationItem: self.navigationItem, navigationController: self.navigationController,
                                            style: navigationStyle, target: self)
                
                self.title = "\(nickname)의 팟"
            }
            .store(in: &cancellables)
        
        viewModel.output.orderHeaderData
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                self?.rootView.headerView.configure(items: data.items, totalAmount: data.total)
            }
            .store(in: &cancellables)
        
        viewModel.output.nameError
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                if let msg = message {
                    self.rootView.orderContentView.nameField.setValidationState(.error(message: msg))
                } else {
                    self.rootView.orderContentView.nameField.setValidationState(.normal)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.zipcodeError
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                if let msg = message {
                    self.rootView.orderContentView.zipcodeField.setValidationState(.error(message: msg))
                } else {
                    self.rootView.orderContentView.zipcodeField.setValidationState(.normal)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.addressError
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                if let message = message {
                    self.rootView.orderContentView.addressField.setValidationState(.error(message: message))
                } else {
                    self.rootView.orderContentView.addressField.setValidationState(.normal)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.phoneError
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                if let message = message {
                    self.rootView.orderContentView.phoneField.setValidationState(.error(message: message))
                } else {
                    self.rootView.orderContentView.phoneField.setValidationState(.normal)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.orderCompleted
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.view.endEditing(true)
                self?.showParticipationNotice()
            }
            .store(in: &cancellables)

        viewModel.output.orderError
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                self?.presentErrorAlert(message: message)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods

    private func showParticipationNotice() {
        let noticeView = NoticeModalView(type: .participate)
        noticeView.onTapConfirm = { [weak self] in
            self?.showOrderCompleteView()
        }
        
        guard let targetView = navigationController?.view ?? view else { return }
        noticeView.show(in: targetView)
    }

    private func showAddressSearch() {
        view.endEditing(true)
        let addressSearchViewController = KakaoAddressSearchViewController()
        addressSearchViewController.onSelectAddress = { [weak self, weak addressSearchViewController] address in
            self?.applySelectedAddress(address)
            addressSearchViewController?.navigationController?.popViewController(animated: true)
        }
        navigationController?.pushViewController(addressSearchViewController, animated: true)
    }

    private func showOrderCompleteView() {
        let completeView = OrderCompleteView()
        completeView.onTapConfirm = { [weak self] in
            guard let self = self else { return }
            
            self.onSuccess?()
            
            if let navigation = self.navigationController {
                if let detailViewController = navigation.viewControllers.first(where: { $0 is PotDetailViewController }) {
                    navigation.popToViewController(detailViewController, animated: true)
                } else {
                    self.dismiss(animated: true)
                }
            } else {
                self.dismiss(animated: true)
            }
        }
        
        guard let targetView = navigationController?.view ?? view else { return }
        completeView.show(in: targetView)
    }
    
    private func applySelectedAddress(_ address: KakaoAddress) {
        rootView.orderContentView.zipcodeField.text = address.zipcode
        rootView.orderContentView.addressField.text = address.address
        rootView.orderContentView.detailAddressField.text = ""
        viewModel.action(.addressSelected(zipcode: address.zipcode, address: address.address))
        viewModel.action(.detailAddressDidChange(""))
    }

    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "참여할 수 없어요",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Public Method
    
    func navigationStyle() -> PotiNavigationStyle {
        return .backDefault("팟")
    }
    
    // MARK: - Action
    
    @objc private func joinButtonTapped() {
        viewModel.action(.joinButtonDidTap)
    }
}
