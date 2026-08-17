//
//  PotOptionsViewModel.swift
//  POTI-iOS
//
//  Created by soomin on 1/20/26.
//

import Combine
import Foundation

final class PotOptionsViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
        case memberSelected(id: Int)
        case deliverySelected(id: Int)
        case memberDeleteButtonTap(id: Int)
    }
    
    // MARK: - Output
    
    struct Output {
        let state: AnyPublisher<PotOptionsViewState, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: FetchPotOptionsUseCase
    private let postId: Int
    let output: Output
    
    private var members: [MemberModel] = []
    private var shippings: [ShippingModel] = []
    
    private var selectedMembers: [Int: MemberModel] = [:]
    private var selectedDelivery: ShippingModel?
    
    private var currentTotalAmount: Int {
        let membersSum = selectedMembers.values.reduce(0) { $0 + $1.memberOptionPrice }
        let deliverySum = selectedDelivery?.deliveryOptionPrice ?? 0
        return membersSum + deliverySum
    }
    
    // MARK: - Subject
    
    private let stateSubject = CurrentValueSubject<PotOptionsViewState, Never>(.initial)
    
    // MARK: - Initializer
    
    init(useCase: FetchPotOptionsUseCase, postId: Int) {
        self.useCase = useCase
        self.postId = postId
        self.output = Output(state: stateSubject.eraseToAnyPublisher())
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchPotOptionsData()
            
        case .memberSelected(let id):
            handleMemberSelection(id: id)
            
        case .deliverySelected(let id):
            handleDeliverySelection(id: id)
            
        case .memberDeleteButtonTap(let id):
            removeMember(id: id)
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchPotOptionsData() {
        Task {
            do {
                let options = try await self.useCase.execute(postId: self.postId)
                
                self.members = options.members.map {
                    MemberModel(memberOptionId: $0.id, memberName: $0.name, memberOptionPrice: $0.price)
                }
                self.shippings = options.shippings.map {
                    ShippingModel(deliveryOptionId: $0.id, deliveryName: $0.name, deliveryOptionPrice: $0.price)
                }
                self.updateState()
                
            } catch {
                PotiLogger.error(error)
            }
        }
    }
    
    private func handleMemberSelection(id: Int) {
        guard let member = members.first(where: { $0.memberOptionId == id }),
              selectedMembers[id] == nil
        else {
            return
        }

        selectedMembers[id] = member
        
        updateState()
    }
    
    private func handleDeliverySelection(id: Int) {
        guard let shipping = shippings.first(where: { $0.deliveryOptionId == id }) else { return }
        selectedDelivery = shipping
        
        updateState()
    }
    
    private func removeMember(id: Int) {
        selectedMembers.removeValue(forKey: id)
        updateState()
    }
    
    private func removeDelivery() {
        selectedDelivery = nil
        updateState()
    }

    private func updateState() {
        let selectedMemberOptions = members.compactMap { member -> PotOptionsViewState.SelectedOption? in
            guard selectedMembers[member.memberOptionId] != nil else { return nil }
            return PotOptionsViewState.SelectedOption(id: member.memberOptionId, name: member.memberName, priceText: formatPrice(member.memberOptionPrice))
        }

        let selectedDeliveryOption = selectedDelivery.map {
            PotOptionsViewState.SelectedOption(id: $0.deliveryOptionId, name: $0.deliveryName, priceText: formatPrice($0.deliveryOptionPrice))
        }

        stateSubject.send(
            PotOptionsViewState(
                memberDropdownItems: makeMemberDropdownItems(),
                deliveryDropdownItems: makeDeliveryDropdownItems(),
                selectedMembers: selectedMemberOptions,
                selectedDelivery: selectedDeliveryOption,
                totalPriceText: formatPrice(currentTotalAmount),
                isContinueEnabled: !selectedMembers.isEmpty && selectedDelivery != nil
            )
        )
    }
    
    private func formatPrice(_ price: Int) -> String {
        return "\(price.formattedWithComma)원"
    }
    
    private func makeMemberDropdownItems() -> [DropdownItem] {
        return members.map {
            DropdownItem(id: $0.memberOptionId, name: $0.memberName,
                         price: $0.memberOptionPrice, isEnabled: selectedMembers[$0.memberOptionId] == nil)
        }
    }
    
    private func makeDeliveryDropdownItems() -> [DropdownItem] {
        return shippings.map {
            DropdownItem(id: $0.deliveryOptionId, name: $0.deliveryName,
                         price: $0.deliveryOptionPrice, isEnabled: true)
        }
    }
    
    // MARK: - Public Method
    
    func makeParticipationOptionResult() -> ParticipationOptionResult? {
        guard let selectedDelivery else { return nil }

        let orderItems = members.compactMap { member -> ParticipationItem? in
            guard selectedMembers[member.memberOptionId] != nil else { return nil }
            return ParticipationItem(optionId: member.memberOptionId, count: 1)
        }

        guard !orderItems.isEmpty else { return nil }

        let memberInfos = members.compactMap { member -> (name: String, price: Int)? in
            guard selectedMembers[member.memberOptionId] != nil else { return nil }
            return (name: member.memberName, price: member.memberOptionPrice)
        }

        return ParticipationOptionResult(shippingId: selectedDelivery.deliveryOptionId, orderItems: orderItems,
            shippingInfo: (name: selectedDelivery.deliveryName, price: selectedDelivery.deliveryOptionPrice), memberInfos: memberInfos)
    }
}
