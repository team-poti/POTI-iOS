//
//  PotOrderViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/21/26.
//

import Combine
import Foundation

final class PotOrderViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case nameDidChange(String)
        case zipcodeDidChange(String)
        case addressDidChange(String)
        case phoneDidChange(String)
        case joinButtonDidTap
    }
    
    // MARK: - Output
    
    struct Output {
        let nickname = PassthroughSubject<String, Never>()
        let orderHeaderData = PassthroughSubject<(items: [(Kind, String, String)], total: String), Never>()
        let isButtonEnabled = CurrentValueSubject<Bool, Never>(false)
        let orderResult = PassthroughSubject<Bool, Never>()
        let nameError = PassthroughSubject<String?, Never>()
        let zipcodeError = PassthroughSubject<String?, Never>()
        let addressError = PassthroughSubject<String?, Never>()
        let phoneError = PassthroughSubject<String?, Never>()
    }
    
    // MARK: - Properties
    
    var cancellables = Set<AnyCancellable>()
    let output = Output()
    
    private let useCase: SubmitOrderUseCase
    
    let postId: Int
    private let shippingId: Int
    private let orderItems: [OrderOptionItem]
    
    // MARK: - Subjects
    
    @Published private var name: String = ""
    @Published private var zipcode: String = ""
    @Published private var address: String = ""
    @Published private var phone: String = ""
    
    // MARK: - Initializer
    
    init(useCase: SubmitOrderUseCase, postId: Int, shippingId: Int,orderItems: [OrderOptionItem]) {
        self.useCase = useCase
        self.postId = postId
        self.shippingId = shippingId
        self.orderItems = orderItems
        
        bindInputs()
    }
    
    // MARK: - Methods
    
    func action(_ input: Input) {
        switch input {
        case .viewDidLoad:
            fetchMockData()
        case .nameDidChange(let text):
            name = text
            output.nameError.send(nil)
        case .zipcodeDidChange(let text):
            zipcode = text
            output.zipcodeError.send(nil)
        case .addressDidChange(let text):
            address = text
            output.addressError.send(nil)
        case .phoneDidChange(let text):
            phone = text
            output.phoneError.send(nil)
        case .joinButtonDidTap:
            if validateFields() {
                requestSubmitOrder()
            }
        }
    }
    
    private func validateFields() -> Bool {
        var isValid = true
        
        if name.isEmpty {
            output.nameError.send("이름을 입력해주세요.")
            isValid = false
        } else { output.nameError.send(nil) }
        
        if zipcode.isEmpty {
            output.zipcodeError.send("우편번호를 입력해주세요.")
            isValid = false
        } else { output.zipcodeError.send(nil) }
        
        if address.isEmpty {
            output.addressError.send("주소를 입력해주세요.")
            isValid = false
        } else { output.addressError.send(nil) }
        
        if phone.isEmpty {
            output.phoneError.send("연락처를 입력해주세요.")
            isValid = false
        } else { output.phoneError.send(nil) }
        
        return isValid
    }
    
    private func bindInputs() {
        Publishers.CombineLatest4($name, $zipcode, $address, $phone)
            .map { _ in true }
            .assign(to: \.value, on: output.isButtonEnabled)
            .store(in: &cancellables)
    }
    
    private func fetchMockData() {
        output.nickname.send("수민이다")
        let dummyItems: [(Kind, String, String)] = [
            (.Member, "포숭이", "10,000원"),
            (.Member, "마마륜", "12,000원"),
            (.Delievery, "포티택배", "3,000원")
        ]
        output.orderHeaderData.send((items: dummyItems, total: "25,000원"))
    }
    
    private func requestSubmitOrder() {
        Task {
            do {
                let entity = OrderRequestEntity(
                    postId: self.postId,
                    shippingId: self.shippingId,
                    receiverName: name,
                    zipcode: zipcode,
                    addressLine: address,
                    phone: phone,
                    items: self.orderItems
                )
                _ = try await useCase.execute(orderInfo: entity)
                output.orderResult.send(true)
            } catch {
                output.orderResult.send(false)
            }
        }
    }
}
