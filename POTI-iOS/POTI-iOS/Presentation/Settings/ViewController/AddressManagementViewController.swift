//
//  AddressManagementViewController.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit

import Combine

final class AddressManagementViewController: BaseViewController<SettingsViewModel>, NavigationConfigurable {
    private let rootView = AddressManagementView()
    private let factory: ViewControllerFactory

    init(viewModel: SettingsViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func navigationStyle() -> PotiNavigationStyle { .backDefault("내 주소 관리") }

    override func loadView() { view = rootView }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindKeyboard()
        viewModel.action(.fetchAddress)
    }

    override func bindViewModel() {
        viewModel.output.address
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.rootView.configure($0) }
            .store(in: &cancellables)

        viewModel.output.completed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.navigationController?.popViewController(animated: true) }
            .store(in: &cancellables)

        viewModel.output.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rootView.updateSaveButtonState()
            }
            .store(in: &cancellables)
    }

    override func addTarget() {
        rootView.saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        rootView.postalCodeField.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(searchPostalCodeTapped))
        )
        rootView.addressField.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(searchPostalCodeTapped))
        )
        rootView.editableFields.forEach { field in
            field.textField.addTarget(self, action: #selector(fieldDidChange), for: .editingChanged)
            field.onBeginEditing = { [weak self] field in
                self?.rootView.scrollToVisible(field)
            }
        }
    }

    @objc private func fieldDidChange() {
        rootView.updateSaveButtonState()
    }

    @objc private func saveTapped() {
        guard rootView.canSave else { return }
        rootView.saveButton.setEnabled(false)
        viewModel.action(.updateAddress(rootView.address))
    }

    @objc private func searchPostalCodeTapped() {
        let viewController = factory.makePostcodeSearchViewController { [weak self] postalCode, address in
            self?.rootView.applySearchResult(postalCode: postalCode, address: address)
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func bindKeyboard() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] keyboardEndFrame in
                self?.rootView.updateKeyboardFrame(keyboardEndFrame)
            }
            .store(in: &cancellables)
    }
}
