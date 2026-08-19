//
//  RegisterViewController.swift
//  POTI-iOS
//
//  Created by soomin on 1/14/26.
//

import UIKit

import Combine
import PhotosUI

final class RegisterViewController: BaseViewController<RegisterViewModel>, NavigationConfigurable {

    // MARK: - Properties

    private let rootView = ProductRegisterView()
    private let factory: ViewControllerFactory
    private weak var focusedInputView: UIView?
    private var keyboardHeight: CGFloat = 0
    private var memberPrices: [Int: Int] = [:]

    // MARK: - Initializer

    init(viewModel: RegisterViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycles

    override func loadView() {
        self.view = rootView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        rootView.clearFieldFocus()
    }

    // MARK: - Custom Methods

    override func setUI() {
        rootView.configureShippingOptions([(name: "일반택배", price: 4000), (name: "준등기", price: 1800)])
    }

    override func addTarget() {
        bindViewActions()
    }

    override func bindViewModel() {
        bindProductTypeQuery()
        bindImages()
        bindProductType()
        bindValidationErrors()
        bindArtistMembers()
        bindRegistrationResult()
        bindKeyboardNotifications()
    }

    // MARK: - Private Methods

    private func bindViewActions() {
        rootView.onPriceChanged = { [weak self] index, price in self?.updateMemberPrice(price, at: index) }
        rootView.onTapArtistField = { [weak self] in self?.showArtistSearch() }
        rootView.onTapDeadlineField = { [weak self] in self?.showDeadlinePicker() }
        rootView.onInputViewDidBeginEditing = { [weak self] in self?.handleInputFocus($0) }
        rootView.onTapAddImage = { [weak self] in self?.viewModel.action(.addImageButtonTapped) }
        rootView.onTapDeleteImage = { [weak self] in self?.viewModel.action(.deleteImageButtonTapped($0)) }
        rootView.onTapSubmit = { [weak self] in self?.requestProductRegistration() }
    }

    private func updateMemberPrice(_ price: Int?, at index: Int) {
        if let price {
            memberPrices[index] = price
        } else {
            memberPrices.removeValue(forKey: index)
        }
    }

    private func showDeadlinePicker() {
        rootView.scrollToDeadlineField(coveredHeight: 465)
        presentDeadlineBottomSheet()
    }

    private func handleInputFocus(_ inputView: UIView) {
        focusedInputView = inputView
        guard keyboardHeight > 0 else { return }
        rootView.scrollIfNeeded(for: inputView, coveredHeight: keyboardHeight)
    }

    private func requestProductRegistration() {
        view.endEditing(true)
        viewModel.action(
            .requestProductRegistration(
                info: rootView.makeDraft(), memberPrices: memberPrices,
                shippingRequests: rootView.collectSelectedShippings()
            )
        )
    }

    private func bindProductTypeQuery() {
        rootView.productTypeTextPublisher
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] in self?.handleProductTypeQuery($0) }
            .store(in: &cancellables)
    }

    private func bindImages() {
        viewModel.output.images
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.rootView.setImages($0) }
            .store(in: &cancellables)

        viewModel.output.imagePickerRequest
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.showImagePicker(selectionLimit: $0) }
            .store(in: &cancellables)
    }

    private func bindProductType() {
        viewModel.output.productTypes
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.rootView.updateProductTypeSuggestions($0) }
            .store(in: &cancellables)
    }

    private func bindValidationErrors() {
        viewModel.output.fieldErrors
            .receive(on: RunLoop.main)
            .sink { [weak self] errors in
                self?.rootView.setImageValidationError(errors.images)
                self?.rootView.renderProductFormValidation(errors.productForm)
                self?.rootView.renderMemberError(errors.members)
            }
            .store(in: &cancellables)
    }

    private func bindArtistMembers() {
        viewModel.output.artistMembers
            .receive(on: RunLoop.main)
            .sink { [weak self] memberNames in
                self?.memberPrices.removeAll()
                self?.rootView.showMembers(memberNames)
            }
            .store(in: &cancellables)
    }

    private func bindRegistrationResult() {
        viewModel.output.registrationCompleted
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.replaceWithProductDetail(postId: $0) }
            .store(in: &cancellables)

        viewModel.output.registrationFailed
            .receive(on: RunLoop.main)
            .sink { PotiLogger.error(PotiError.apiError(message: $0)) }
            .store(in: &cancellables)
    }

    private func handleProductTypeQuery(_ keyword: String) {
        guard !keyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            rootView.updateProductTypeSuggestions([])
            return
        }
        viewModel.action(.fetchProductTypes(keyword: keyword))
    }

    private func bindKeyboardNotifications() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height }
            .sink { [weak self] in self?.handleKeyboardWillShow(height: $0) }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in self?.keyboardHeight = 0 }
            .store(in: &cancellables)
    }

    private func handleKeyboardWillShow(height: CGFloat) {
        keyboardHeight = height
        guard let focusedInputView else { return }
        rootView.scrollIfNeeded(for: focusedInputView, coveredHeight: height)
    }

    private func showLeaveConfirmationAlert() {
        let alert = CustomAlertView(
            title: "지금 나가면 내용이 저장되지 않아요", message: "계속 작성할까요?", cancelTitle: "나가기",
            confirmTitle: "계속 작성하기", onLeftButton: { [weak self] in self?.exitProductRegistration() }, onRightButton: {}
        )
        alert.show(on: navigationController?.view ?? view)
    }

    private func exitProductRegistration() {
        if navigationController == nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    private func showImagePicker(selectionLimit: Int) {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        configuration.selectionLimit = max(0, selectionLimit)

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    private func presentDeadlineBottomSheet() {
        let sheetViewController = DeadlinePickerSheetViewController(
            initialDate: Date(),
            onConfirm: { [weak self] date in
                guard let self else { return }
                rootView.setDeadline(date.toYMDString())
                rootView.clearFieldFocus()
            },
            onCancel: { [weak self] in self?.rootView.clearFieldFocus() }
        )

        if let sheet = sheetViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16
        }
        present(sheetViewController, animated: true)
    }

    private func showArtistSearch() {
        let searchViewController = factory.makeArtistSearchViewController()
        searchViewController.onSelectArtist = { [weak self] in self?.handleSelectedArtist($0) }

        if let navigationController {
            searchViewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(searchViewController, animated: true)
        } else {
            present(UINavigationController(rootViewController: searchViewController), animated: true)
        }
    }

    private func handleSelectedArtist(_ artist: ArtistSearchResultEntity) {
        view.endEditing(true)
        rootView.clearFieldFocus()
        rootView.setArtist(id: artist.artistId, name: artist.name)
        viewModel.action(.setArtist(artist))
        viewModel.action(.fetchArtistMembers(artistId: artist.artistId))
    }

    private func replaceWithProductDetail(postId: Int) {
        let productDetailViewController = factory.makePotDetailViewController(postId: postId)
        if let navigationController {
            navigationController.setViewControllers([productDetailViewController], animated: true)
        } else {
            present(productDetailViewController, animated: true)
        }
    }

    // MARK: - Public Method

    func navigationStyle() -> PotiNavigationStyle {
        .xButton
    }

    // MARK: - Action

    override func navigationButtonTapped(_ sender: UIButton) {
        guard let action = PotiNavigationAction(rawValue: sender.tag) else { return }

        switch action {
        case .xButton, .back:
            showLeaveConfirmationAlert()
        default:
            super.navigationButtonTapped(sender)
        }
    }
}

// MARK: - PHPickerViewControllerDelegate

extension RegisterViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        viewModel.action(.didFinishPicking(results))
    }
}
