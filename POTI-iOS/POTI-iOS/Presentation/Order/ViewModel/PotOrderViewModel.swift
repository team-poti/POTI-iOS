//
//  PotOrderViewModel.swift
//  POTI-iOS
//
//  Created by soomin on 1/21/26.
//

import Combine
import Foundation

final class PotOrderViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case nameDidChange(String)
        case addressSelected(zipcode: String, address: String)
        case detailAddressDidChange(String)
        case phoneDidChange(String)
        case shipmentRegistrationDidTap
        case joinButtonDidTap
    }
    
    // MARK: - Output
    
    struct Output {
        let nickname = PassthroughSubject<String, Never>()
        let orderHeaderData = PassthroughSubject<(items: [(Kind, String, String)], total: String), Never>()
        let orderCompleted = PassthroughSubject<Void, Never>()
        let orderError = PassthroughSubject<String, Never>()
        let savedAddress = PassthroughSubject<AddressEntity, Never>()
        let shipmentRegistrationState = CurrentValueSubject<ShipmentRegistrationState, Never>(.unselected)
        let nameError = PassthroughSubject<String?, Never>()
        let zipcodeError = PassthroughSubject<String?, Never>()
        let addressError = PassthroughSubject<String?, Never>()
        let phoneError = PassthroughSubject<String?, Never>()
    }
    
    // MARK: - Properties
    
    var cancellables = Set<AnyCancellable>()
    let output = Output()
    
    private let useCase: ApplyParticipationUseCase
    private let getAddressUseCase: GetAddressUseCase
    private let updateAddressUseCase: UpdateAddressUseCase
    
    let postId: Int
    private let shippingId: Int
    private let uploaderNickname: String
    private let orderItems: [ParticipationItem]
    private let memberInfos: [(name: String, price: Int)]
    private let shippingInfo: (name: String, price: Int)
    
    // MARK: - Subjects
    
    private var name = ""
    private var zipcode = ""
    private var address = ""
    private var detailAddress = ""
    private var phone = ""
    private var storedAddress: AddressEntity?
    private var shouldSaveAddress = false
    
    // MARK: - Initializer
    
    init(useCase: ApplyParticipationUseCase,
         getAddressUseCase: GetAddressUseCase,
         updateAddressUseCase: UpdateAddressUseCase,
         postId: Int,
         shippingId: Int,
         orderItems: [ParticipationItem],
         shippingInfo: (name: String, price: Int),
         memberInfos: [(name: String, price: Int)], uploaderNickname: String) {
        
        self.useCase = useCase
        self.getAddressUseCase = getAddressUseCase
        self.updateAddressUseCase = updateAddressUseCase
        self.postId = postId
        self.shippingId = shippingId
        self.orderItems = orderItems
        self.memberInfos = memberInfos
        self.shippingInfo = shippingInfo
        self.uploaderNickname = uploaderNickname
        
    }
    
    // MARK: - Methods
    
    func action(_ input: Input) {
        switch input {
        case .viewDidLoad:
            fetchOrderData()
            fetchSavedAddress()
        case .nameDidChange(let text):
            name = text
            output.nameError.send(nil)
            updateShipmentRegistrationState()
        case let .addressSelected(zipcode, address):
            self.zipcode = zipcode
            self.address = address
            output.zipcodeError.send(nil)
            output.addressError.send(nil)
            updateShipmentRegistrationState()
        case .detailAddressDidChange(let text):
            detailAddress = text
            updateShipmentRegistrationState()
        case .phoneDidChange(let text):
            phone = text
            output.phoneError.send(nil)
            updateShipmentRegistrationState()
        case .shipmentRegistrationDidTap:
            guard output.shipmentRegistrationState.value != .unavailable else { return }
            shouldSaveAddress.toggle()
            output.shipmentRegistrationState.send(shouldSaveAddress ? .selected : .unselected)
        case .joinButtonDidTap:
            if validateFields() {
                requestSubmitOrder()
            }
        }
    }
    
    private func validateFields() -> Bool {
        var isValid = true
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            output.nameError.send("이름을 입력해주세요")
            isValid = false
        } else {
            output.nameError.send(nil)
        }
        
        if zipcode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            output.zipcodeError.send("우편번호를 입력해주세요")
            isValid = false
        } else {
            output.zipcodeError.send(nil)
        }

        if address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            output.addressError.send("주소를 입력해주세요")
            isValid = false
        } else {
            output.addressError.send(nil)
        }
        
        if phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            output.phoneError.send("연락처를 입력해주세요")
            isValid = false
        } else {
            output.phoneError.send(nil)
        }
        
        return isValid
    }
    
    private func fetchOrderData() {
        var displayItems: [(Kind, String, String)] = []
        var totalAmount = 0
        
        memberInfos.forEach { member in
            displayItems.append((.Member, member.name, "\(member.price.formattedWithComma)원"))
            totalAmount += member.price
        }
        
        displayItems.append((.Delievery, shippingInfo.name, "\(shippingInfo.price.formattedWithComma)원"))
        totalAmount += shippingInfo.price
        
        output.orderHeaderData.send((items: displayItems, total: "\(totalAmount.formattedWithComma)원"))
        output.nickname.send(uploaderNickname)
    }

    private func fetchSavedAddress() {
        Task {
            do {
                let savedAddress = try await getAddressUseCase.execute()
                guard !savedAddress.isEmpty else {
                    output.shipmentRegistrationState.send(.unselected)
                    return
                }

                storedAddress = savedAddress
                name = savedAddress.name
                zipcode = savedAddress.postalCode
                address = savedAddress.address
                detailAddress = savedAddress.detailAddress
                phone = savedAddress.phoneNumber
                shouldSaveAddress = false

                output.savedAddress.send(savedAddress)
                output.shipmentRegistrationState.send(.unavailable)
            } catch {
                PotiLogger.error(error)
            }
        }
    }

    private func updateShipmentRegistrationState() {
        guard let storedAddress else {
            output.shipmentRegistrationState.send(shouldSaveAddress ? .selected : .unselected)
            return
        }

        if currentAddress == storedAddress {
            shouldSaveAddress = false
            output.shipmentRegistrationState.send(.unavailable)
        } else {
            shouldSaveAddress = true
            output.shipmentRegistrationState.send(.selected)
        }
    }

    private var currentAddress: AddressEntity {
        AddressEntity(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            postalCode: zipcode.trimmingCharacters(in: .whitespacesAndNewlines),
            address: address.trimmingCharacters(in: .whitespacesAndNewlines),
            detailAddress: detailAddress.trimmingCharacters(in: .whitespacesAndNewlines),
            phoneNumber: phone.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
    
    private func requestSubmitOrder() {
        Task {
            do {
                let entity = ParticipationEntity(
                    postId: postId,
                    shippingId: shippingId,
                    receiverName: name.trimmingCharacters(in: .whitespacesAndNewlines),
                    zipcode: zipcode.trimmingCharacters(in: .whitespacesAndNewlines),
                    address: address.trimmingCharacters(in: .whitespacesAndNewlines),
                    addressDetail: detailAddress.trimmingCharacters(in: .whitespacesAndNewlines),
                    phone: phone.trimmingCharacters(in: .whitespacesAndNewlines),
                    items: orderItems
                )
                
                _ = try await useCase.execute(info: entity)
                if shouldSaveAddress {
                    _ = try await updateAddressUseCase.execute(currentAddress)
                }
                output.orderCompleted.send()
            } catch {
                let message = error.localizedDescription
                if !applyServerValidationError(message) {
                    output.orderError.send(message)
                }
            }
        }
    }

    private func applyServerValidationError(_ message: String) -> Bool {
        if message.contains("우편번호") {
            output.zipcodeError.send(message)
        } else if message.contains("상세주소") {
            output.addressError.send(message)
        } else if message.contains("주소") {
            output.addressError.send(message)
        } else if message.contains("이름") || message.contains("수령인") {
            output.nameError.send(message)
        } else if message.contains("연락처") || message.contains("전화번호") {
            output.phoneError.send(message)
        } else {
            return false
        }
        return true
    }
}

private extension AddressEntity {
    var isEmpty: Bool {
        name.isEmpty && postalCode.isEmpty && address.isEmpty && detailAddress.isEmpty && phoneNumber.isEmpty
    }
}
