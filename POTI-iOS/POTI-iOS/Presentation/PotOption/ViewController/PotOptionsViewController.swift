//
//  PotOptionsViewController.swift
//  POTI-iOS
//
//  Created by soomin on 7/29/26.
//

import UIKit

import Combine

final class PotOptionsViewController: BaseViewController<PotOptionsViewModel> {
    
    // MARK: - Properties
    
    private let rootView = PotOptionsView()
    var onContinue: ((ParticipationOptionResult) -> Void)?
    
    // MARK: - Life Cycles
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        viewModel.action(.viewDidLoad)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.show()
    }
    
    // MARK: - Custom Methods
    
    override func addTarget() {
        rootView.onMemberSelected = { [weak self] id in
            self?.viewModel.action(.memberSelected(id: id))
        }
        
        rootView.onDeliverySelected = { [weak self] id in
            self?.viewModel.action(.deliverySelected(id: id))
        }
        
        rootView.onMemberDelete = { [weak self] id in
            self?.viewModel.action(.memberDeleteButtonTap(id: id))
        }
        
        rootView.onContinue = { [weak self] in
            self?.continueButtonTapped()
        }
        
        rootView.onClose = { [weak self] in
            self?.dismissOptions()
        }
    }
    
    override func bindViewModel() {
        viewModel.output.state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.rootView.render(state)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    
    private func continueButtonTapped() {
        guard let result = viewModel.makeParticipationOptionResult() else { return }
        let onContinue = self.onContinue
        
        dismissOptions {
            onContinue?(result)
        }
    }
    
    private func dismissOptions(completion: (() -> Void)? = nil) {
        rootView.hide { [weak self] in
            self?.dismiss(animated: false, completion: completion)
        }
    }
}
