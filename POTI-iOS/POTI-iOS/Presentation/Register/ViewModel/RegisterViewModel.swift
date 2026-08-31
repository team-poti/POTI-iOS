//
//  RegisterViewModel.swift
//  POTI-iOS
//
//  Created by soomin on 1/16/26.
//

import Combine
import Foundation

final class RegisterViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case viewDidLoad
        case addImageButtonTapped
        case deleteImageButtonTapped(Int)
        case addOptimizedImages([OptimizedImage])
        case setArtist(ArtistSearchItem)
        case fetchProductTypes(keyword: String)
        case updateProductType(String)
        case updateDescription(String)
        case updateAccountNumber(String)
        case updateBank(String)
        case requestDeadlinePicker
        case setDeadline(Date)
        case updateMemberPrice(memberID: Int, price: Int?)
        case editMembersButtonTapped
        case updateSelectedMemberIDs(Set<Int>)
        case toggleShippingSelection(deliveryMethodID: Int)
        case updateShippingPrice(deliveryMethodID: Int, price: Int?)
        case requestProductRegistration
    }

    // MARK: - Output

    struct Output {
        let optimizedImages: AnyPublisher<[OptimizedImage], Never>
        let imagePickerRequest: AnyPublisher<Int, Never>
        let fieldErrors: AnyPublisher<ProductRegisterValidationErrors, Never>
        let productTypes: AnyPublisher<[String], Never>
        let memberSetting: AnyPublisher<MemberSettingViewState, Never>
        let memberSelectionRequest: AnyPublisher<RegisterMemberSelectionRequest, Never>
        let shippingSetting: AnyPublisher<ShippingSettingViewState, Never>
        let deadlinePickerRequest: AnyPublisher<Date, Never>
        let deadline: AnyPublisher<Date, Never>
        let registrationCompleted: AnyPublisher<Int, Never>
        let registrationFailed: AnyPublisher<String, Never>
    }

    let output: Output

    // MARK: - Properties

    private let maxImageCount: Int
    private var productTypeSearchTask: Task<Void, Never>?
    private var currentProductTypeQuery = ""
    private var selectedArtist: ArtistSearchItem?
    private var formState = ProductRegisterFormState()
    private var members: [RegisterMemberItem] = []
    private var showsMemberGuide = false
    private var artistMembersFetchTask: Task<Void, Never>?
    private var shippingOptions: [RegisterShippingOptionItem]

    private let fetchProductTitlesUseCase: FetchProductTitlesUseCase
    private let registerPostUseCase: RegisterPostUseCase
    private let uploadPostImagesUseCase: UploadPostImagesUseCase
    private let artistMembersUseCase: ArtistMembersUseCase
    private let fetchShippingOptionsUseCase: FetchShippingOptionsUseCase

    // MARK: - Subjects

    private let registrationCompletedSubject = PassthroughSubject<Int, Never>()
    private let registrationFailedSubject = PassthroughSubject<String, Never>()
    private let productTypesSubject = CurrentValueSubject<[String], Never>([])
    private let optimizedImagesSubject = CurrentValueSubject<[OptimizedImage], Never>([])
    private let imagePickerRequestSubject = PassthroughSubject<Int, Never>()
    private let memberSettingSubject = CurrentValueSubject<MemberSettingViewState, Never>(
        .init(content: .artistNotSelected, error: nil, showsGuide: false)
    )
    private let memberSelectionRequestSubject = PassthroughSubject<RegisterMemberSelectionRequest, Never>()
    private let shippingSettingSubject: CurrentValueSubject<ShippingSettingViewState, Never>
    private let deadlinePickerRequestSubject = PassthroughSubject<Date, Never>()
    private let deadlineSubject = PassthroughSubject<Date, Never>()
    private let fieldErrorsSubject = CurrentValueSubject<ProductRegisterValidationErrors, Never>(.init())

    // MARK: - Initializer

    init(
        maxImageCount: Int = 5, fetchProductTitlesUseCase: FetchProductTitlesUseCase, registerPostUseCase: RegisterPostUseCase,
        uploadPostImagesUseCase: UploadPostImagesUseCase, artistMembersUseCase: ArtistMembersUseCase,
        fetchShippingOptionsUseCase: FetchShippingOptionsUseCase
    ) {
        let shippingOptions = DefaultRegisterShippingOptions.items
        self.maxImageCount = maxImageCount
        self.shippingOptions = shippingOptions
        self.shippingSettingSubject = .init(.init(options: shippingOptions, error: nil))
        self.fetchProductTitlesUseCase = fetchProductTitlesUseCase
        self.registerPostUseCase = registerPostUseCase
        self.uploadPostImagesUseCase = uploadPostImagesUseCase
        self.artistMembersUseCase = artistMembersUseCase
        self.fetchShippingOptionsUseCase = fetchShippingOptionsUseCase

        self.output = Output(
            optimizedImages: optimizedImagesSubject.eraseToAnyPublisher(), imagePickerRequest: imagePickerRequestSubject.eraseToAnyPublisher(),
            fieldErrors: fieldErrorsSubject.eraseToAnyPublisher(), productTypes: productTypesSubject.eraseToAnyPublisher(),
            memberSetting: memberSettingSubject.eraseToAnyPublisher(), memberSelectionRequest: memberSelectionRequestSubject.eraseToAnyPublisher(),
            shippingSetting: shippingSettingSubject.eraseToAnyPublisher(),
            deadlinePickerRequest: deadlinePickerRequestSubject.eraseToAnyPublisher(), deadline: deadlineSubject.eraseToAnyPublisher(),
            registrationCompleted: registrationCompletedSubject.eraseToAnyPublisher(),
            registrationFailed: registrationFailedSubject.eraseToAnyPublisher()
        )
    }

    deinit {
        productTypeSearchTask?.cancel()
        artistMembersFetchTask?.cancel()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {

        case .viewDidLoad:
            fetchShippingOptions()

        case .addImageButtonTapped:
            requestImageSelection()

        case .deleteImageButtonTapped(let index):
            deleteImage(at: index)

        case .addOptimizedImages(let images):
            addOptimizedImages(images)

        case .setArtist(let artist):
            updateSelectedArtist(artist)

        case .fetchProductTypes(let keyword):
            fetchProductTypes(keyword: keyword)

        case let .updateProductType(productType):
            updateProductType(productType)

        case let .updateDescription(description):
            updateDescription(description)

        case let .updateAccountNumber(accountNumber):
            updateAccountNumber(accountNumber)

        case let .updateBank(bank):
            updateBank(bank)

        case .requestDeadlinePicker:
            deadlinePickerRequestSubject.send(formState.deadline ?? Date())

        case let .setDeadline(deadline):
            updateDeadline(deadline)

        case .requestProductRegistration:
            requestProductRegistration()

        case let .updateMemberPrice(memberID, price):
            updateMemberPrice(memberID: memberID, price: price)

        case .editMembersButtonTapped:
            requestMemberSelection()

        case .updateSelectedMemberIDs(let selectedMemberIDs):
            updateSelectedMembers(selectedMemberIDs)

        case let .toggleShippingSelection(deliveryMethodID):
            toggleShippingSelection(deliveryMethodID: deliveryMethodID)

        case let .updateShippingPrice(deliveryMethodID, price):
            updateShippingPrice(deliveryMethodID: deliveryMethodID, price: price)
        }
    }

    // MARK: - Private Methods

    private func requestImageSelection() {
        let remainingImageCount = maxImageCount - optimizedImagesSubject.value.count
        guard remainingImageCount > 0 else { return }
        imagePickerRequestSubject.send(remainingImageCount)
    }

    private func fetchShippingOptions() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let options = try await fetchShippingOptionsUseCase.execute()
                let items = options.map {
                    RegisterShippingOptionItem(
                        deliveryMethodID: $0.deliveryID,
                        name: $0.name,
                        price: $0.price,
                        isSelected: true
                    )
                }

                await MainActor.run {
                    guard !items.isEmpty else { return }
                    self.shippingOptions = items
                    self.shippingSettingSubject.send(.init(options: items, error: nil))
                }
            } catch {
                PotiLogger.error(error)
            }
        }
    }

    private func deleteImage(at index: Int) {
        var images = optimizedImagesSubject.value
        guard images.indices.contains(index) else { return }
        images.remove(at: index)
        optimizedImagesSubject.send(images)
    }

    private func addOptimizedImages(_ newImages: [OptimizedImage]) {
        guard !newImages.isEmpty else { return }
        let remainingImageCount = maxImageCount - optimizedImagesSubject.value.count
        guard remainingImageCount > 0 else { return }
        optimizedImagesSubject.send(optimizedImagesSubject.value + Array(newImages.prefix(remainingImageCount)))
        clearImageValidationError()
    }

    private func clearImageValidationError() {
        guard fieldErrorsSubject.value.images != nil else { return }
        var errors = fieldErrorsSubject.value
        errors.images = nil
        fieldErrorsSubject.send(errors)
    }

    private func updateSelectedArtist(_ artist: ArtistSearchItem) {
        productTypeSearchTask?.cancel()
        artistMembersFetchTask?.cancel()
        currentProductTypeQuery = ""
        selectedArtist = artist
        members = []
        showsMemberGuide = false
        productTypesSubject.send([])
        var errors = fieldErrorsSubject.value
        errors.productForm.artist = nil
        errors.members = nil
        fieldErrorsSubject.send(errors)
        sendMemberSettingState()
        fetchArtistMembers(artistId: artist.id)
    }

    private func updateProductType(_ productType: String) {
        formState.productType = productType
        clearProductFormError(\.productType, when: !productType.isBlank)
    }

    private func updateDescription(_ description: String) {
        formState.description = description
        clearProductFormError(\.description, when: !description.isBlank)
    }

    private func updateAccountNumber(_ accountNumber: String) {
        formState.accountNumber = accountNumber
        clearProductFormError(\.accountNumber, when: !accountNumber.isBlank)
    }

    private func updateBank(_ bank: String) {
        formState.bank = bank
        clearProductFormError(\.bank, when: !bank.isBlank)
    }

    private func updateDeadline(_ deadline: Date) {
        formState.deadline = deadline
        clearProductFormError(\.deadline, when: true)
        deadlineSubject.send(deadline)
    }

    private func clearProductFormError(_ keyPath: WritableKeyPath<ProductFormValidationErrors, String?>, when condition: Bool) {
        guard condition, fieldErrorsSubject.value.productForm[keyPath: keyPath] != nil else { return }
        var errors = fieldErrorsSubject.value
        errors.productForm[keyPath: keyPath] = nil
        fieldErrorsSubject.send(errors)
    }

    private func fetchProductTypes(keyword: String) {
        let keyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        productTypeSearchTask?.cancel()
        currentProductTypeQuery = keyword

        guard !keyword.isEmpty else {
            productTypesSubject.send([])
            return
        }

        guard let artistId = selectedArtist?.id else {
            updateArtistValidationError("아티스트를 먼저 선택해주세요")
            productTypesSubject.send([])
            return
        }

        updateArtistValidationError(nil)

        productTypeSearchTask = Task { [weak self] in
            guard let self else { return }
            do {
                let productTypes = try await fetchProductTitlesUseCase.execute(artistId: artistId, keyword: keyword)
                await MainActor.run {
                    guard !Task.isCancelled, self.currentProductTypeQuery == keyword else { return }
                    self.productTypesSubject.send(productTypes)
                }
            } catch {
                await MainActor.run {
                    guard !Task.isCancelled, self.currentProductTypeQuery == keyword else { return }
                    self.productTypesSubject.send([])
                }
                PotiLogger.error(error)
            }
        }
    }

    private func updateArtistValidationError(_ message: String?) {
        var errors = fieldErrorsSubject.value
        errors.productForm.artist = message
        fieldErrorsSubject.send(errors)
    }

    private func requestProductRegistration() {
        let errors = validateRegistration()
        fieldErrorsSubject.send(errors)
        sendMemberSettingState()
        sendShippingSettingState()
        guard !errors.hasError, let artistId = selectedArtist?.id else { return }

        Task { [weak self] in
            guard let self else { return }
            do {
                let imagePaths = try await uploadImages()
                let entity = makeRegisterPostEntity(artistId: artistId, imagePaths: imagePaths)
                let response = try await registerPostUseCase.execute(entity)
                await MainActor.run { self.registrationCompletedSubject.send(response.postId) }
            } catch {
                PotiLogger.error(error)
                await MainActor.run { self.registrationFailedSubject.send("등록에 실패했어요") }
            }
        }
    }

    private func validateRegistration() -> ProductRegisterValidationErrors {
        ProductRegisterValidationErrors(
            images: optimizedImagesSubject.value.isEmpty ? "사진을 1장 이상 등록해주세요" : nil,
            productForm: validateProductForm(),
            members: validateMembers(),
            shipping: validateShipping()
        )
    }

    private func validateProductForm() -> ProductFormValidationErrors {
        ProductFormValidationErrors(
            artist: selectedArtist == nil ? "아티스트를 선택해주세요" : nil,
            productType: formState.productType.isBlank ? "상품 종류를 입력해주세요" : nil,
            deadline: formState.deadline == nil ? "모집 기한을 선택해주세요" : nil,
            description: formState.description.isBlank ? "설명을 입력해주세요" : nil,
            accountNumber: formState.accountNumber.isBlank ? "계좌번호를 입력해주세요" : nil,
            bank: formState.bank.isBlank ? "은행 정보를 입력해주세요" : nil
        )
    }

    private func validateMembers() -> MemberSettingValidationError? {
        guard selectedArtist != nil else { return nil }
        guard !selectedMembers.isEmpty else { return .noSelectedMember }
        return selectedMembers.contains(where: { $0.price == nil }) ? .missingPrice : nil
    }

    private func validateShipping() -> ShippingSettingValidationError? {
        guard !selectedShippingOptions.isEmpty else { return .noSelectedOption }
        return selectedShippingOptions.contains(where: { $0.price == nil }) ? .missingPrice : nil
    }

    private func uploadImages() async throws -> [String] {
        try await uploadPostImagesUseCase.execute(images: optimizedImagesSubject.value.map { $0.toUploadImageEntity() })
    }

    private func makeRegisterPostEntity(artistId: Int, imagePaths: [String]) -> RegisterPostEntity {
        RegisterPostEntity(
            artistId: artistId, title: formState.productType, content: formState.description,
            deadline: formState.deadline?.toYMDString() ?? "", bankName: formState.bank, accountNumber: formState.accountNumber,
            imageUrls: imagePaths, options: makeMemberOptions(), shippings: makeShippingEntities()
        )
    }

    private func makeShippingEntities() -> [RegisterPostShippingEntity] {
        makeShippingItems().map { item in
            .init(deliveryMethodId: item.deliveryMethodID, price: item.price)
        }
    }

    private func makeShippingItems() -> [RegisterShippingItem] {
        selectedShippingOptions.compactMap { option in
            guard let price = option.price else { return nil }
            return .init(deliveryMethodID: option.deliveryMethodID, price: price)
        }
        .sorted { $0.deliveryMethodID < $1.deliveryMethodID }
    }

    private func fetchArtistMembers(artistId: Int) {
        artistMembersFetchTask?.cancel()
        members = []
        showsMemberGuide = false
        sendMemberSettingState()

        artistMembersFetchTask = Task { [weak self] in
            guard let self else { return }
            do {
                let artistMembers = try await self.artistMembersUseCase.execute(artistId: artistId)

                await MainActor.run {
                    guard !Task.isCancelled, self.selectedArtist?.id == artistId else { return }
                    self.members = artistMembers.map {
                        .init(id: $0.memberId, name: $0.name, isSelected: true, price: nil)
                    }
                    self.showsMemberGuide = !artistMembers.isEmpty
                    self.sendMemberSettingState()
                }
            } catch {
                PotiLogger.error(error)
            }
        }
    }

    private var selectedMembers: [RegisterMemberItem] {
        members.filter(\.isSelected)
    }

    private var selectedShippingOptions: [RegisterShippingOptionItem] {
        shippingOptions.filter(\.isSelected)
    }

    private func updateMemberPrice(memberID: Int, price: Int?) {
        guard let index = members.firstIndex(where: { $0.id == memberID }) else { return }
        members[index].price = price
        updateMemberValidationIfNeeded()
    }

    private func requestMemberSelection() {
        if showsMemberGuide {
            showsMemberGuide = false
            sendMemberSettingState()
        }
        memberSelectionRequestSubject.send(.init(members: members))
    }

    private func updateSelectedMembers(_ newSelectedMemberIDs: Set<Int>) {
        for index in members.indices {
            let isSelected = newSelectedMemberIDs.contains(members[index].id)
            if members[index].isSelected && !isSelected {
                members[index].price = nil
            }
            members[index].isSelected = isSelected
        }
        updateMemberSelectionError()
    }

    private func sendMemberSettingState() {
        let content: MemberSettingViewState.Content
        if selectedArtist == nil {
            content = .artistNotSelected
        } else if selectedMembers.isEmpty {
            content = .noSelectedMembers
        } else {
            content = .members(selectedMembers)
        }

        memberSettingSubject.send(
            .init(content: content, error: fieldErrorsSubject.value.members, showsGuide: showsMemberGuide)
        )
    }

    private func makeMemberOptions() -> [RegisterPostOptionEntity] {
        selectedMembers.compactMap { member in
            guard let price = member.price else { return nil }
            return .init(memberId: member.id, price: price)
        }
        .sorted { $0.memberId < $1.memberId }
    }

    private func updateMemberValidationIfNeeded() {
        guard fieldErrorsSubject.value.members != nil else { return }
        var errors = fieldErrorsSubject.value
        errors.members = validateMembers()
        fieldErrorsSubject.send(errors)
        sendMemberSettingState()
    }

    private func updateMemberSelectionError() {
        var errors = fieldErrorsSubject.value
        if selectedMembers.isEmpty {
            errors.members = .noSelectedMember
        } else if errors.members == .noSelectedMember {
            errors.members = nil
        } else if errors.members != nil {
            errors.members = validateMembers()
        }
        fieldErrorsSubject.send(errors)
        sendMemberSettingState()
    }

    private func toggleShippingSelection(deliveryMethodID: Int) {
        guard let index = shippingOptions.firstIndex(where: { $0.deliveryMethodID == deliveryMethodID }) else { return }
        shippingOptions[index].isSelected.toggle()
        updateShippingValidation()
    }

    private func updateShippingPrice(deliveryMethodID: Int, price: Int?) {
        guard let index = shippingOptions.firstIndex(where: { $0.deliveryMethodID == deliveryMethodID }) else { return }
        shippingOptions[index].price = price
        updateShippingValidationIfNeeded()
        sendShippingSettingState()
    }

    private func updateShippingValidation() {
        var errors = fieldErrorsSubject.value
        errors.shipping = validateShipping()
        fieldErrorsSubject.send(errors)
        sendShippingSettingState()
    }

    private func updateShippingValidationIfNeeded() {
        guard fieldErrorsSubject.value.shipping != nil else { return }
        var errors = fieldErrorsSubject.value
        errors.shipping = validateShipping()
        fieldErrorsSubject.send(errors)
    }

    private func sendShippingSettingState() {
        shippingSettingSubject.send(
            .init(options: shippingOptions, error: fieldErrorsSubject.value.shipping)
        )
    }
}
