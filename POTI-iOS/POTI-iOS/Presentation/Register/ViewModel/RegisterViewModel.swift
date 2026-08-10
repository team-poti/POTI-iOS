//
//  RegisterViewModel.swift
//  POTI-iOS
//
//  Created by soomin on 1/16/26.
//

import UIKit

import Combine
import PhotosUI

final class RegisterViewModel: BaseViewModelType {

    // MARK: - Input

    enum Input {
        case addImageButtonTapped
        case deleteImageButtonTapped(Int)
        case didFinishPicking([PHPickerResult])
        case setArtist(ArtistSearchResultEntity)
        case fetchProductTypes(keyword: String)
        case fetchArtistMembers(artistId: Int)
        case requestProductRegistration(info: ProductRegisterDraft, memberPrices: [Int: Int], shippingRequests: [ShippingSettingSectionView.ShippingRequest])
    }

    // MARK: - Output

    struct Output {
        let images: AnyPublisher<[UIImage], Never>
        let imagePickerRequest: AnyPublisher<Int, Never>
        let fieldErrors: AnyPublisher<ProductRegisterValidationErrors, Never>
        let productTypes: AnyPublisher<[String], Never>
        let artistMembers: AnyPublisher<[String], Never>
        let registrationCompleted: AnyPublisher<Int, Never>
        let registrationFailed: AnyPublisher<String, Never>
    }

    let output: Output

    // MARK: - Properties

    private let maxImageCount: Int
    private var productTypeSearchTask: Task<Void, Never>?
    private var currentProductTypeQuery = ""
    private var selectedArtist: ArtistSearchResultEntity?
    private var hasEverHadMembers = false
    private var artistMembers: [MemberEntity] = []
    
    private let fetchProductTitlesUseCase: FetchProductTitlesUseCase
    private let registerPostsUseCase: RegisterPostsUseCase
    private let imagesRepository: ImagesInterface
    private let artistMembersUseCase: ArtistMembersUseCase

    // MARK: - Subjects

    private let registrationCompletedSubject = PassthroughSubject<Int, Never>()
    private let registrationFailedSubject = PassthroughSubject<String, Never>()
    private let productTypesSubject = CurrentValueSubject<[String], Never>([])
    private let imagesSubject = CurrentValueSubject<[UIImage], Never>([])
    private let imagePickerRequestSubject = PassthroughSubject<Int, Never>()
    private let artistMembersSubject = CurrentValueSubject<[String], Never>([])
    private let fieldErrorsSubject = CurrentValueSubject<ProductRegisterValidationErrors, Never>(.init())

    // MARK: - Initializer

    init(
        maxImageCount: Int = 5, fetchProductTitlesUseCase: FetchProductTitlesUseCase, registerPostsUseCase: RegisterPostsUseCase,
        imagesRepository: ImagesInterface, artistMembersUseCase: ArtistMembersUseCase
    ) {
        self.maxImageCount = maxImageCount
        self.fetchProductTitlesUseCase = fetchProductTitlesUseCase
        self.registerPostsUseCase = registerPostsUseCase
        self.imagesRepository = imagesRepository
        self.artistMembersUseCase = artistMembersUseCase

        self.output = Output(
            images: imagesSubject.eraseToAnyPublisher(), imagePickerRequest: imagePickerRequestSubject.eraseToAnyPublisher(),
            fieldErrors: fieldErrorsSubject.eraseToAnyPublisher(), productTypes: productTypesSubject.eraseToAnyPublisher(),
            artistMembers: artistMembersSubject.eraseToAnyPublisher(), registrationCompleted: registrationCompletedSubject.eraseToAnyPublisher(),
            registrationFailed: registrationFailedSubject.eraseToAnyPublisher()
        )
    }

    deinit {
        productTypeSearchTask?.cancel()
    }

    // MARK: - Action

    func action(_ trigger: Input) {
        switch trigger {

        case .addImageButtonTapped:
            requestImageSelection()

        case .deleteImageButtonTapped(let index):
            deleteImage(at: index)

        case .didFinishPicking(let results):
            loadSelectedImages(from: results)

        case .setArtist(let artist):
            updateSelectedArtist(artist)

        case .fetchProductTypes(let keyword):
            fetchProductTypes(keyword: keyword)

        case let .requestProductRegistration(info, memberPrices, shippingRequests):
            requestProductRegistration(info: info, memberPrices: memberPrices, shippingRequests: shippingRequests)

        case .fetchArtistMembers(let artistId):
            fetchArtistMembers(artistId: artistId)
        }
    }

    // MARK: - Private Methods

    private func requestImageSelection() {
        let remainingImageCount = maxImageCount - imagesSubject.value.count
        guard remainingImageCount > 0 else { return }
        imagePickerRequestSubject.send(remainingImageCount)
    }

    private func deleteImage(at index: Int) {
        var images = imagesSubject.value
        guard images.indices.contains(index) else { return }
        images.remove(at: index)
        imagesSubject.send(images)
    }

    private func loadSelectedImages(from results: [PHPickerResult]) {
        guard !results.isEmpty else { return }

        let remainingImageCount = maxImageCount - imagesSubject.value.count
        guard remainingImageCount > 0 else { return }

        Task { [weak self] in
            guard let self else { return }
            let loadedImages = await loadImages(from: results)
            let selectedImages = Array(loadedImages.prefix(remainingImageCount))

            await MainActor.run {
                self.imagesSubject.send(self.imagesSubject.value + selectedImages)
            }
        }
    }

    private func updateSelectedArtist(_ artist: ArtistSearchResultEntity) {
        productTypeSearchTask?.cancel()
        currentProductTypeQuery = ""
        selectedArtist = artist
        productTypesSubject.send([])
        updateArtistValidationError(nil)
    }

    private func fetchProductTypes(keyword: String) {
        let keyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        productTypeSearchTask?.cancel()
        currentProductTypeQuery = keyword

        guard !keyword.isEmpty else {
            productTypesSubject.send([])
            return
        }

        guard let artistId = selectedArtist?.artistId else {
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

    private func requestProductRegistration(info: ProductRegisterDraft, memberPrices: [Int: Int], shippingRequests: [ShippingSettingSectionView.ShippingRequest]) {
        let errors = validateRegistration(info: info, memberPrices: memberPrices)
        fieldErrorsSubject.send(errors)
        guard !errors.hasError, let artistId = info.artistId ?? selectedArtist?.artistId else { return }

        Task { [weak self] in
            guard let self else { return }
            do {
                let imageFileNames = try await uploadImages()
                let request = makeRegisterRequestEntity(
                    info: info, artistId: artistId, imageFileNames: imageFileNames,
                    memberPrices: memberPrices, shippingRequests: shippingRequests
                )
                let response = try await registerPostsUseCase.execute(request)
                await MainActor.run { self.registrationCompletedSubject.send(response.postId) }
            } catch {
                PotiLogger.error(error)
                await MainActor.run { self.registrationFailedSubject.send("등록에 실패했어요") }
            }
        }
    }

    private func validateRegistration(info: ProductRegisterDraft, memberPrices: [Int: Int]) -> ProductRegisterValidationErrors {
        ProductRegisterValidationErrors(
            images: imagesSubject.value.isEmpty ? "사진을 1장 이상 등록해주세요" : nil,
            productForm: validateProductForm(info),
            members: validateMemberPrices(memberPrices)
        )
    }

    private func validateProductForm(_ info: ProductRegisterDraft) -> ProductFormValidationErrors {
        ProductFormValidationErrors(
            artist: (info.artistId ?? selectedArtist?.artistId) == nil ? "아티스트를 선택해주세요" : nil,
            productType: info.productType.isBlank ? "상품 종류를 입력해주세요" : nil,
            deadline: info.deadlineText.isBlank ? "모집 기한을 선택해주세요" : nil,
            description: info.description.isBlank ? "설명을 입력해주세요" : nil,
            accountNumber: info.accountNumber.isBlank ? "계좌번호를 입력해주세요" : nil,
            bank: info.bank.isBlank ? "은행 정보를 입력해주세요" : nil
        )
    }

    private func validateMemberPrices(_ memberPrices: [Int: Int]) -> String? {
        guard hasEverHadMembers else { return nil }
        guard !artistMembersSubject.value.isEmpty else { return "선택한 멤버가 없어요" }

        let hasMissingPrice = artistMembersSubject.value.indices.contains { memberPrices[$0] == nil }
        return hasMissingPrice ? "모든 멤버에 가격을 설정해주세요" : nil
    }

    private func uploadImages() async throws -> [String] {
        let imageData = imagesSubject.value.compactMap { $0.jpegData(compressionQuality: 0.8) }
        let presignedURLs = try await imagesRepository.fetchPresignedUrls(count: imageData.count)
        var imageFileNames: [String] = []

        for (data, presignedURL) in zip(imageData, presignedURLs) {
            try await imagesRepository.uploadImage(data: data, to: presignedURL.uploadUrl)
            imageFileNames.append(presignedURL.fileName)
        }
        return imageFileNames
    }

    private func makeRegisterRequestEntity(info: ProductRegisterDraft, artistId: Int, imageFileNames: [String], memberPrices: [Int: Int], shippingRequests: [ShippingSettingSectionView.ShippingRequest]) -> RegisterRequestEntity {
        RegisterRequestEntity(
            artistId: artistId, title: info.productType, content: info.description,
            deadline: info.deadlineText, bankName: info.bank, accountNumber: info.accountNumber,
            imageUrls: imageFileNames, options: makeMemberOptions(from: memberPrices), shippings: makeShippingEntities(from: shippingRequests)
        )
    }

    private func makeShippingEntities(from shippingRequests: [ShippingSettingSectionView.ShippingRequest]) -> [RegisterRequestEntity.Shipping] {
        shippingRequests.map { .init(deliveryMethodId: $0.deliveryMethodId, price: $0.price) }
    }

    private func loadImages(from results: [PHPickerResult]) async -> [UIImage] {
        await withTaskGroup(of: UIImage?.self) { group in
            for result in results {
                group.addTask {
                    await Self.loadImage(from: result)
                }
            }

            var images: [UIImage] = []
            for await image in group {
                if let image { images.append(image) }
            }
            return images
        }
    }

    private static func loadImage(from result: PHPickerResult) async -> UIImage? {
        await withCheckedContinuation { continuation in
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                continuation.resume(returning: object as? UIImage)
            }
        }
    }

    private func fetchArtistMembers(artistId: Int) {
        artistMembersSubject.send([])
        hasEverHadMembers = false
        artistMembers = []

        Task { [weak self] in
            guard let self else { return }
            do {
                let entities = try await self.artistMembersUseCase.execute(artistId: artistId)

                let mappedMembers = entities.map { entity in
                    MemberEntity(id: entity.memberId, name: entity.name, price: 0)
                }

                let names = mappedMembers.map { $0.name }

                await MainActor.run {
                    self.artistMembers = mappedMembers
                    self.hasEverHadMembers = !mappedMembers.isEmpty
                    self.artistMembersSubject.send(names)
                }
            } catch {
                PotiLogger.error(error)
            }
        }
    }

    private func makeMemberOptions(from memberPrices: [Int: Int]) -> [RegisterRequestEntity.Option] {
        memberPrices.compactMap { index, price in
            guard artistMembers.indices.contains(index) else { return nil }
            return RegisterRequestEntity.Option(memberId: artistMembers[index].id, price: price)
        }
        .sorted { $0.memberId < $1.memberId }
    }
}
