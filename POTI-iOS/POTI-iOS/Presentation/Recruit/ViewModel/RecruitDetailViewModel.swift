//
//  RecruitDetailViewModel.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import Combine

final class RecruitDetailViewModel: BaseViewModelType {
    
    // MARK: - Input
    
    enum Input {
        case viewDidLoad
    }
    
    // MARK: - Output
    
    struct Output {
        let reloadData: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    let output: Output
    
    // MARK: - Subject
    
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Initializer
    
    init() {
       //self.useCase = useCase
        self.output = Output(
            reloadData: reloadDataSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Action
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchRecruitDetail()
        
        }
    }
    // MARK: - Private Method
    
    private func fetchRecruitDetail() {
//        Task {
//            do {
//                let data = try await useCase.execute()
//                self.groupItems = data.toGroupItemModel()
//                reloadDataSubject.send(())
//            } catch {
//                print("Error: \(error)")
//            }
//        }
    }
}
