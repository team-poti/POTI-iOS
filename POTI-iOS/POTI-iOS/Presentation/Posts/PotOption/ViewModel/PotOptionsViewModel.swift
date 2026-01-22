//
//  OrderViewModel.swift
//  POTI-iOS
//
//  Created by mandoo on 1/20/26.
//

import Combine
import Foundation

final class PotOptionsViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case memberSelected(index: Int)
        case deliverySelected(index: Int)
        case memberDeleteButtonTap(name: String)
        case deliveryDeleteButtonTap
    }
    
    // MARK: - Output
    
    struct Output {
        let memberAdded: AnyPublisher<(name: String, priceText: String, price: Int), Never>
        let memberRemoved: AnyPublisher<String, Never>
        let deliveryUpdated: AnyPublisher<(name: String, priceText: String, price: Int), Never>
        let deliveryDeleted: AnyPublisher<Void, Never>
        let totalPrice: AnyPublisher<String, Never>
        let isBottomButtonEnabled: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: PotOptionsUseCase
    private let postId: Int
    private var cancellables = Set<AnyCancellable>()
    let output: Output
    
    private(set) var members: [MemberModel] = []
    private(set) var shippings: [ShippingModel] = []
    
    private(set) var selectedMembers: [String: Int] = [:]
    private(set) var selectedMemberNames: Set<String> = []
    private(set) var selectedDelivery: (name: String, price: Int)?
    
    private var currentTotalAmount: Int {
        let membersSum = selectedMembers.values.reduce(0, +)
        let deliverySum = selectedDelivery?.price ?? 0
        return membersSum + deliverySum
    }
    
    // MARK: - Subject
    
    private let memberAddedSubject = PassthroughSubject<(name: String, priceText: String, price: Int), Never>()
    private let memberRemovedSubject = PassthroughSubject<String, Never>()
    private let deliveryUpdatedSubject = PassthroughSubject<(name: String, priceText: String, price: Int), Never>()
    private let deliveryDeletedSubject = PassthroughSubject<Void, Never>()
    private let totalPriceSubject = CurrentValueSubject<String, Never>("0원")
    private let isBottomButtonEnabledSubject = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Initializer
    
    init(useCase: PotOptionsUseCase, postId: Int) {
        self.useCase = useCase
        self.postId = postId
        self.output = Output(
            memberAdded: memberAddedSubject.eraseToAnyPublisher(),
            memberRemoved: memberRemovedSubject.eraseToAnyPublisher(),
            deliveryUpdated: deliveryUpdatedSubject.eraseToAnyPublisher(),
            deliveryDeleted: deliveryDeletedSubject.eraseToAnyPublisher(),
            totalPrice: totalPriceSubject.eraseToAnyPublisher(),
            isBottomButtonEnabled: isBottomButtonEnabledSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchPotOptionsData()
            
        case .memberSelected(let index):
            handleMemberSelection(at: index)
            
        case .deliverySelected(let index):
            handleDeliverySelection(at: index)
            
        case .memberDeleteButtonTap(let name):
            removeMember(name: name)
            
        case .deliveryDeleteButtonTap:
            removeDelivery()
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchPotOptionsData() {
        Task {
            do {
                let options = try await useCase.execute(postId: self.postId)
                self.members = options.members.map {
                    MemberModel(memberOptionId: $0.id, memberName: $0.name, memberOptionPrice: $0.price)
                }
                self.shippings = options.shippings.map {
                    ShippingModel(deliveryOptionId: $0.id, deliveryName: $0.name, deliveryOptionPrice: $0.price)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func handleMemberSelection(at index: Int) {
        guard index < members.count else { return }
        let member = members[index]
        
        if selectedMemberNames.contains(member.memberName) { return }
        
        selectedMembers[member.memberName] = member.memberOptionPrice
        selectedMemberNames.insert(member.memberName)
        
        let priceText = member.memberOptionPrice == 0 ? "0원" : "\(member.memberOptionPrice.formattedWithComma)원"
        memberAddedSubject.send((member.memberName, priceText, member.memberOptionPrice))
        updateTotalState()
    }
    
    private func handleDeliverySelection(at index: Int) {
        guard index < shippings.count else { return }
        let shipping = shippings[index]
        selectedDelivery = (shipping.deliveryName, shipping.deliveryOptionPrice)
        
        let priceText = "\(shipping.deliveryOptionPrice.formattedWithComma)원"
        deliveryUpdatedSubject.send((shipping.deliveryName, priceText, shipping.deliveryOptionPrice))
        updateTotalState()
    }
    
    private func removeMember(name: String) {
        selectedMembers.removeValue(forKey: name)
        selectedMemberNames.remove(name)
        updateTotalState()
    }
    
    private func removeDelivery() {
        selectedDelivery = nil
        deliveryDeletedSubject.send(())
        updateTotalState()
    }
    
    private func updateTotalState() {
        totalPriceSubject.send("\(currentTotalAmount.formattedWithComma)원")
        let isValid = !selectedMembers.isEmpty && selectedDelivery != nil
        isBottomButtonEnabledSubject.send(isValid)
    }
}

// MARK: - Helper Methods

extension PotOptionsViewModel {
    func getMemberDropdownItems() -> [(name: String, price: Int)] {
        return members.map { ($0.memberName, $0.memberOptionPrice) }
    }
    
    func getDeliveryDropdownItems() -> [(name: String, price: Int)] {
        return shippings.map { ($0.deliveryName, $0.deliveryOptionPrice) }
    }
    
    func getDisabledMemberIndices() -> Set<Int> {
        var indices = Set<Int>()
        for (index, member) in members.enumerated() {
            if selectedMemberNames.contains(member.memberName) {
                indices.insert(index)
            }
        }
        return indices
    }
}
