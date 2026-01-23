//
//  YourPageViewController.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class YourPageViewController: BaseViewController<YourPageViewModel>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        .backButton
    }
    
    private let rootView = YourPageView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.action(.viewDidLoad)
    }
    
    override func bindViewModel() {
        viewModel.output.yourPage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.rootView.configure(with: model)
            }
            .store(in: &cancellables)
        
        viewModel.output.error
            .sink { message in
                print(message)
            }
            .store(in: &cancellables)
    }
}
