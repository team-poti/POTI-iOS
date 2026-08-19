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

    override func addTarget() {
        bindViewActions()
    }

    override func bindViewModel() {
        bindProductTypeQuery()
        bindImages()
        bindProductType()
        bindValidationErrors()
        bindArtistMembers()
        bindShippingSetting()
        bindDeadlinePicker()
        bindRegistrationResult()
        bindKeyboardNotifications()
    }

    // MARK: - Private Methods

    private func bindViewActions() {
        rootView.onAction = { [weak self] in self?.handleProductRegisterAction($0) }
    }

    private func handleProductRegisterAction(_ action: ProductRegisterAction) {
        switch action {
        case .addImage:
            viewModel.action(.addImageButtonTapped)
        case let .deleteImage(index):
            viewModel.action(.deleteImageButtonTapped(index))
        case let .form(action):
            handleProductFormAction(action)
        case let .inputFocused(inputView):
            handleInputFocus(inputView)
        case let .memberSetting(action):
            handleMemberSettingAction(action)
        case let .shippingSetting(action):
            handleShippingSettingAction(action)
        case .submit:
            requestProductRegistration()
        }
    }

    private func handleProductFormAction(_ action: ProductFormAction) {
        switch action {
        case .artistFieldTapped:
            showArtistSearch()
        case .deadlineFieldTapped:
            showDeadlinePicker()
        case let .inputFocused(inputView):
            handleInputFocus(inputView)
        case let .productTypeChanged(productType):
            viewModel.action(.updateProductType(productType))
        case let .descriptionChanged(description):
            viewModel.action(.updateDescription(description))
        case let .accountNumberChanged(accountNumber):
            viewModel.action(.updateAccountNumber(accountNumber))
        case let .bankChanged(bank):
            viewModel.action(.updateBank(bank))
        }
    }

    private func handleMemberSettingAction(_ action: MemberSettingAction) {
        switch action {
        case let .priceChanged(memberID, price):
            viewModel.action(.updateMemberPrice(memberID: memberID, price: price))
        case .editButtonTapped:
            viewModel.action(.editMembersButtonTapped)
        case let .inputFocused(inputView):
            handleInputFocus(inputView)
        }
    }

    private func handleShippingSettingAction(_ action: ShippingSettingAction) {
        switch action {
        case let .selectionToggled(deliveryMethodID):
            viewModel.action(.toggleShippingSelection(deliveryMethodID: deliveryMethodID))
        case let .priceChanged(deliveryMethodID, price):
            viewModel.action(.updateShippingPrice(deliveryMethodID: deliveryMethodID, price: price))
        case let .inputFocused(inputView):
            handleInputFocus(inputView)
        }
    }

    private func showDeadlinePicker() {
        viewModel.action(.requestDeadlinePicker)
    }

    private func handleInputFocus(_ inputView: UIView) {
        focusedInputView = inputView
        guard keyboardHeight > 0 else { return }
        rootView.scrollIfNeeded(for: inputView, coveredHeight: keyboardHeight)
    }

    private func requestProductRegistration() {
        view.endEditing(true)
        viewModel.action(.requestProductRegistration)
    }

    private func bindProductTypeQuery() {
        rootView.productTypeTextPublisher
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] in self?.handleProductTypeQuery($0) }
            .store(in: &cancellables)
    }

    private func bindImages() {
        viewModel.output.imageData
            .receive(on: RunLoop.main)
            .sink { [weak self] imageData in
                self?.rootView.setImages(imageData.compactMap { UIImage(data: $0) })
            }
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
            }
            .store(in: &cancellables)
    }

    private func bindArtistMembers() {
        viewModel.output.memberSetting
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.rootView.renderMemberSetting($0) }
            .store(in: &cancellables)

        viewModel.output.memberSelectionRequest
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.showMemberEditor($0) }
            .store(in: &cancellables)
    }

    private func bindShippingSetting() {
        viewModel.output.shippingSetting
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.rootView.renderShippingSetting($0) }
            .store(in: &cancellables)
    }

    private func bindDeadlinePicker() {
        viewModel.output.deadlinePickerRequest
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.presentDeadlineBottomSheet(initialDate: $0) }
            .store(in: &cancellables)

        viewModel.output.deadline
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.rootView.setDeadline($0.toYMDString()) }
            .store(in: &cancellables)
    }

    private func showMemberEditor(_ request: RegisterMemberSelectionRequest) {
        let members = request.members.map { ArtistMemberEntity(memberId: $0.id, name: $0.name) }
        let selectedMemberIDs = Set(request.members.filter(\.isSelected).map(\.id))
        let memberSelectionViewModel = ArtistMembersFilterViewModel(
            members: members, selectedMemberIDs: selectedMemberIDs
        )
        let bottomSheet = ArtistMembersFilterBottomSheet(viewModel: memberSelectionViewModel)
        bottomSheet.onComplete = { [weak self] members in
            self?.viewModel.action(.updateSelectedMemberIDs(Set(members.ids)))
        }
        bottomSheet.show(in: navigationController?.view ?? view)
    }

    private func bindRegistrationResult() {
        viewModel.output.registrationCompleted
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.showRegistrationNotice(postId: $0) }
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
        let alert = CustomAlertView(title: "지금 나가면 내용이 저장되지 않아요", message: "계속 작성할까요?", cancelTitle: "나가기",
                                    confirmTitle: "계속 작성하기", rightButtonBackgroundColor: .potiBlack, onLeftButton: { [weak self] in self?.exitProductRegistration() }, onRightButton: {})
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

    private func presentDeadlineBottomSheet(initialDate: Date) {
        let sheetViewController = DeadlinePickerSheetViewController(
            initialDate: initialDate,
            onConfirm: { [weak self] date in
                self?.viewModel.action(.setDeadline(date))
                self?.rootView.clearFieldFocus()
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
        rootView.setArtist(name: artist.name)
        viewModel.action(.setArtist(artist))
    }

    private func showRegistrationNotice(postId: Int) {
        let noticeView = NoticeModalView(type: .register)
        noticeView.onTapConfirm = { [weak self] in self?.replaceWithProductDetail(postId: postId) }
        noticeView.show(in: navigationController?.view ?? view)
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
        Task { [weak self] in
            let imageData = await Self.loadImageData(from: results)
            self?.viewModel.action(.addSelectedImageData(imageData))
        }
    }

    private static func loadImageData(from results: [PHPickerResult]) async -> [Data] {
        await withTaskGroup(of: (Int, Data?).self) { group in
            for (index, result) in results.enumerated() {
                group.addTask {
                    let image = await loadImage(from: result)
                    return (index, image?.jpegData(compressionQuality: 0.8))
                }
            }

            var loadedImageData: [(Int, Data)] = []
            for await (index, data) in group {
                if let data { loadedImageData.append((index, data)) }
            }
            return loadedImageData.sorted { $0.0 < $1.0 }.map(\.1)
        }
    }

    private static func loadImage(from result: PHPickerResult) async -> UIImage? {
        await withCheckedContinuation { continuation in
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                continuation.resume(returning: object as? UIImage)
            }
        }
    }
}
